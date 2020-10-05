classdef Render
    
    properties
        mHeight = 0;
        mWidth = 0;
        mSubSampling = 1;
        
    end
    
    
    methods
        function [obj] = Render( InHeight, InWidth, InSubSampling )
            obj.mHeight      = InHeight;
            obj.mWidth       = InWidth;
            obj.mSubSampling = InSubSampling;
            
        end
        
        function [OutBool, OutColourMatrix]  = start( obj, InCamera, InScene, InDepth )
      
            % -- Camera X and Camera Y --
            cx     = [ obj.mWidth * 0.5135 / obj.mHeight, 0, 0];
            cy     = unit( crossP( cx, InCamera.mDirection ) )  * 0.5135;
            
            OutColourMatrix  = cell( 1, obj.mWidth * obj.mHeight );

            
            parfor_progress( obj.mHeight );
            
            for y = 0:obj.mHeight-1
                
                % -- set random generation algorithm --
                rng(y,'twister');
                
                for x=0:obj.mWidth-1
                    i            = ( ( obj.mHeight - y - 1) * obj.mWidth + x ) + 1;
                    
                    OutColourMatrix{i}  = [0,0,0];
                 
                    % -- loop subpixel row --
                    for sy=0:1
                        
                        % -- loop subpixel row --
                        for sx=0:1
                            
                            radianceCol   = [0,0,0];
                            InObjectIndex = 0;
                            
                            % -- loop subsampling --
                            for s=0:obj.mSubSampling-1
                                
                                r1 = 2 * rand;
                                
                                if ( r1<1 )
                                    dx = sqrt( r1 ) - 1;
                                else
                                    dx = 1-sqrt( 2 - r1);
                                end
                                
                                r2 = 2 * rand;
                                
                                if ( r2<1 )
                                    dy = sqrt(r2)-1;
                                else
                                    dy = 1-sqrt(2-r2);
                                end
                                
                                % Generate Random Direction
                                d = unit ( InCamera.mDirection + ...
                                    cx * ( ( (sx + 0.5 + dx)/2 + x )/ obj.mWidth  - 0.5) + ...
                                    cy * ( ( (sy + 0.5 + dy)/2 + y )/ obj.mHeight - 0.5));
                                
                                % -- Send the new ray with random direction --
                                [color, InObjectIndex ] = obj.radiance( Ray ( InCamera.mOrigin + d * 140, d ), InScene, InDepth);
                                radianceCol = radianceCol + color *(1/obj.mSubSampling) ;
                                
                                % -- 0 = no hit, 6 = z Sphere  -- %
                                if ( InObjectIndex == 0 || InObjectIndex == 6 )
                                    radianceCol = [0,0,0];
                                end
                              
                                
                                
                            end
                            
                            r = clamp ( radianceCol(1) );
                            g = clamp ( radianceCol(2) );
                            b = clamp ( radianceCol(3) );
                            
                            % -- store radiance value i.e colour --
                            
                            OutColourMatrix{i} = OutColourMatrix{i} + [r,g,b] * 0.25 ;
                                        
                            
                        end
                        
                    end
                    
                end
                
                % -- Progress Bar --%
                parfor_progress;
            end
            parfor_progress(0);
            
            
            
            OutBool = true;
        end
        
        function [ OutColor, OutObjectIndex ] = radiance(obj, InRay, InScene, InDepth)
            % -- init -- %
            OutColor         = [0,0,0];
            OutObjectIndex   = 0;
            % intersect the list of object
            [ InObjectData ] = obj.intersection( InScene, InRay, InDepth );
            
            
            % -- Check if any object is intersected --
            if( InObjectData.mBIsInterseted ~= true )
                return
            end
            
            % -- Check if object index is 0 --
            if ( InObjectData.mIndex == 0 )
                return
            end
            
            
            % -- get Color, emission and material type of interseted obj --
            point          = InRay.mOrigin + InRay.mDirection * InObjectData.mSmallestT;
            color          = InScene{ InObjectData.mIndex }.mColor;
            emission       = InScene{ InObjectData.mIndex }.mEmission;
            
            OutObjectIndex = InObjectData.mIndex;
            
            
            % materialType = InScene{ InObjectData{3} }.mMaterialType;
            
            normal       = InObjectData.mNormal;
            
            % Change the direction of Normal if Ray is inside/Outside
            if ( dotp( normal, InRay.mDirection) < 0 )
                normalFixed = normal;
            else
                normalFixed = normal * -1;
            end
            
            % max refl
            p = 0;
            p = max( max(color(1), color(2) ), color(3) );
            
            if (color(1) > color(2) && color(1) > color(3))
                p =  color(1);
            elseif (color(2) > color(3))
                p = color(2);
            else
                p = color(3);
            end
            
            
            %Russian.Roulate.
            InDepth = InDepth + 1;
            if ( InDepth > 5 )
                if ( rand < p )

                    color = color * (1/p);
                else
                    % -- return Light --
                    OutColor   = emission;
                    return
                end
            end

            % -- Ray bounce 1 -- %
            if ( InDepth > 3 )
                OutColor = color;
                return
            end
            
            % --- Diffuse Material --- %
            % if ( materialType == 0)
   
            r1 = 2 * 3.141593 * rand;
            
            r2  = rand;
            r2s = sqrt(r2);
            
            w = normalFixed;
            u = [0,0,0];
            
            if ( abs( w(1) ) > 0.1 )
                u = unit ( crossP( [0,1,0], w) );
            else
                u = unit ( crossP( [1,0,0], w) );
            end
            
            v         = crossP(w, u);
            
            direction =  unit(  u * cos(r1) * r2s + ...
                v * sin(r1) * r2s + ...
                w * sqrt( 1 - r2 ) );
            
            [ color, OutObjectIndex]  = obj.radiance(  Ray (point, direction),  InScene, InDepth) ;
            
            OutColor = emission + color;
            return
            
            
        end
        
%         function [OutColor] =  diffuse ( obj, InRay, InScene,  InDepth)
%             
%             % -- init -- %
%             OutColor = [0,0,0];
%             
%             % intersect the list of object
%             [ InObjData ] = obj.diffuseIntersection(InScene, InRay);
%             
%             % -- Check if any object is intersected --
%             if( InObjData.mIsIntersected ~= true )
%                 return
%             end
%             
%             
%             %-- init -- %
%             point        = InRay.mOrigin + InRay.mDirection * InObjData.mSmallestT;
%             % -- get Color, emission and material type of interseted obj -- %
%             normal       = InObjData.mNormal;
%             
%             % Change the direction of Normal if Ray is inside/Outside
%             if ( dotp( normal, InRay.mDirection) < 0 )
%                 normalFixed = normal;
%             else
%                 normalFixed = normal * -1;
%             end
%             
%             color      = InScene{InObjData.mIndex}.mColor;
%             %             emission   = InScene{InObjData.mIndex}.mEmission;
%             
%             % materialType = InScene{2}{ InObjectData{3} }.mMaterialType;
%             
%             
%             
%             % max refl
%             %             p = 0;
%             %             if (color(1) > color(2) && color(1) > color(3))
%             %                 p =  color(1);
%             %             elseif (color(2) > color(3))
%             %                 p = color(2);
%             %             else
%             %                 p = color(3);
%             %             end
%             %
%             
%             % -- Russian.Roulate --%
%             % InDepth = InDepth + 1;
%             %
%             % if ( InDepth > 5 )
%             %     if ( rand < p )
%             %         return
%             %     end
%             % end
%             
%             
%             
%             % -- if the object is light --- %
%             if (InObjData.mIndex == 1 )
%                 %     out   = InScene{InObjData.mIndex}.mEmission;
%                 OutColor = [1,1,1];
%                 return
%             end
%             
%             % -- Get the random point on the surface of light -- %
%             pointOnLight = InScene{1}.getPoint;
%             
%             lightDirection    = unit( pointOnLight - point) ;
%             diffuseCoefficient = max ([ 0, dotp(normalFixed, lightDirection) ] ) ;
%             
%             
%             % -- Calculate the Shadow -- %
%             ShadowRay = Ray(point, lightDirection );
%             
%             [ InShadowData ] = obj.diffuseIntersection( InScene, ShadowRay );
%             
%             diffuseCol = [0,0,0];
%             
%             if ( InShadowData.mIsIntersected && InShadowData.mIndex == 1 )
%                 
%                 % ---- %
%                 costheta = max([ 0, dotp( InShadowData.mNormal, -lightDirection )] );
%                 lightDistanceSquare = length(lightDirection)^2;
%                 % -- need to play with 1  as its light surface area -- %
%                 surfaceIlluminace = ( 16 *  costheta )/lightDistanceSquare;
%                 
%                 diffuseCol = ( diffuseCoefficient * surfaceIlluminace) .* [1,1,1];
%             end
%             
%             
%             
%             OutColor = diffuseCol .* color;
%             
%             
%         end
%         
%         function  [ OutColor ] = diffuseIntersection(obj, InObjList, InRay)
%             % -- Get the total Object size --
%             [~,totalObject]   = size(InObjList);
%             % totalObject   = totalObject(1,2);
%             
%             inf         = 1e20;
%             
%             OutColor.mSmallestT = 1e20; % closest T
%             OutColor.mIndex = 0;       % object Index
%             OutColor.mNormal= [0,0,0]; % object Normal
%             
%             % -- Loop through total object --
%             for i = 1:1:totalObject
%                 % --  Try to intersect the object with the Ray --
%                 [ InData ] = InObjList{i}.intersection(InRay);
%                 
%                 if ( InData{1} && InData{1} < OutColor.mSmallestT )
%                     OutColor.mSmallestT = InData{1};
%                     OutColor.mIndex     = i;
%                     OutColor.mNormal    = InData{2};
%                 end
%                 
%             end
%             
%             % Is object intersected?
%             OutColor.mIsIntersected = OutColor.mSmallestT <inf;
%             
%             return
%         end
%         
%         
        
        function  [ OutObjectData ] = intersection( obj, InScene, InRay, InDepth )
            % -- Get the total Object size --
            [~,totalObject]   = size(InScene);
            
            inf         = 1e20;
            % OutObjectData{1} = false;   % BIsInteresect
            OutObjectData.mSmallestT     = 1e20;    % closest T
            OutObjectData.mIndex         = 0;       % object Index
            OutObjectData.mNormal        = [0,0,0]; % object Normal
            OutObjectData.mBIsInterseted = false;
            
            % -- Loop through total object -- %
            for i = totalObject:-1:1
                % --  Try to intersect the object with the Ray --
                [ InIntersectionData ] = InScene{i}.intersection( InRay );
                
                if ( InIntersectionData{1} && InIntersectionData{1} < OutObjectData.mSmallestT )
                    OutObjectData.mSmallestT  = InIntersectionData{1};
                    OutObjectData.mIndex      = i;
                    OutObjectData.mNormal     = InIntersectionData{2};
                end
                
                % -- Check if the first ray intersect with new surface or not -- %
                if ( InDepth == 0 && OutObjectData.mIndex ~= 7 )
                    return
                end
                
            end
            
            % Is object intersected?
            OutObjectData.mBIsInterseted = OutObjectData.mSmallestT<inf;
            
            return
        end
        
        
      
        
        
    end
    
    
    
    
end