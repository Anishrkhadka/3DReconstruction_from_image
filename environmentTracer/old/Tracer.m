classdef Tracer
    
    properties
        imageHeight = 0;
        imageWidth = 0;
        totalSubSampling = 0;
        sampler = 0;
    end
    
    
    methods
        function [obj] = Tracer( InHeight, InWidth, InSubSampling )
            obj.imageHeight      = InHeight;
            obj.imageWidth       = InWidth;
            obj.totalSubSampling = InSubSampling;
            obj.sampler          = Sampler(InSubSampling);
        end
        
        function [OutBool, OutAllPixelColourMatrix]  = render( obj, InCamera, InScene, InDirectionMatrix )
            
            OutAllPixelColourMatrix  = cell( 1, obj.imageWidth * obj.imageHeight );
            
            tempimageHeight = obj.imageHeight;
            tempimageWidth  = obj.imageWidth;
            
            cx     = [ obj.imageWidth * 0.5135 / obj.imageHeight, 0, 0];
            cy     = unit( crossP( cx, InCamera.direction ) )  * 0.5135;
            
            InObjectData.mSmallestT     = 1e20;    % closest T
            InObjectData.mIndex         = 0;       % object Index
            InObjectData.mNormal        = [0,0,0]; % object Normal
            InObjectData.mBIsInterseted = false;
            
            
            
            
            parfor_progress( obj.imageHeight );
            
            for y = 0:obj.imageHeight-1
                
                % -- set random generation algorithm -- %
                for x= 0:obj.imageWidth-1
                    i = ( ( tempimageHeight - y - 1) * tempimageWidth + x ) + 1;
                    
                    OutAllPixelColourMatrix{i}  = [0,0,0];
                    
                    % -- loop subpixel row -- %
                    for sy = 0:1
                        
                        % -- loop subpixel row -- %
                        for sx = 0:1
                            
                            subPixelColour   = [0,0,0];
                            ray              = createRay([0,0,0],[0,0,0]);
                            
                            % -- loop subsampling -- %
                            for s = 0:obj.totalSubSampling-1
                               
                                while ( InObjectData.mIndex ~= 6 || InObjectData.mIndex ~= 5  )
                                    
                                    %   samplePoint = obj.sampler.sampleUnitSquare;
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
                                    
                         
                                    direction = unit ( InCamera.direction + ...
                                    cx * ( ( (sx + 0.5 + dx)/2 + x )/ tempimageWidth  - 0.5) + ...
                                    cy * ( ( (sy + 0.5 + dy)/2 + y )/ tempimageHeight - 0.5));
                                    
                                
                                    ray.origin       = InCamera.origin + direction;
                                    ray.direction    = direction;
                                    
                                  
                                    [ InObjectData ] = obj.intersection( InScene, ray, 0 );
                                    
                                end
                                
                                subPixelColour = subPixelColour + obj.radiance( ray, InScene, 0 ) *(1.0/obj.totalSubSampling);
                                
                                
                                
                            end
                            
                            r = clamp ( subPixelColour(1) );
                            g = clamp ( subPixelColour(2) );
                            b = clamp ( subPixelColour(3) );
                            
                            % -- store radiance value i.e colour -- %
                            OutAllPixelColourMatrix{i} = OutAllPixelColourMatrix{i} + [r,g,b] * 0.25 ;
                            
                        end
                        
                    end
                    
                    
                end
                
                
                parfor_progress;
            end
            parfor_progress(0);
            
            OutBool = true;
        end
        
        function [ OutColour ] = radiance(obj, InRay, InScene, InDepth )
            
            % -- init -- %
            OutColour         = [0,0,0];
            
            % -- intersect the list of object  -- % 
            [ InObjectData ] = obj.intersection( InScene, InRay );
        
            % -- Check if any object is intersected -- % 
            if( InObjectData.mBIsInterseted ~= true)
                return
            end
            
            
            % -- get Color, emission and material type of interseted obj --
            point          = InRay.origin + InRay.direction * InObjectData.mSmallestT;

            % -- Don't get the colour from the newMesh -- % 
            if (InDepth ~= 0)
                colour         = InScene{ InObjectData.mIndex }.colour;
                emission       = InScene{ InObjectData.mIndex }.emission;
            else
                colour = [0,0,0];
            end
                        
            normal       = InObjectData.mNormal;
            
            % Change the direction of Normal if Ray is inside/Outside
            
            if ( dotp( normal, InRay.direction) < 0 )
                normalFixed = normal;
            else
                normalFixed = normal * -1;
            end
            
            %-- max refl --%
            p = max( max(colour(1), colour(2) ), colour(3) );
            
            
            
            % -- Russian.Roulate --%
            totalNumberOfRayReflection = 2;
            
            InDepth = InDepth + 1;
            if ( InDepth > totalNumberOfRayReflection )
                 OutColour = colour;
                return
            end

            
            % --- Diffuse Material --- %
            
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
            
            v     = crossP(w, u);
            
            direction =  unit(  u * cos(r1) * r2s + ...
                                v * sin(r1) * r2s + ...
                                w * sqrt( 1 - r2 ) );

            
            InRay.origin    = point;
            InRay.direction = direction;
            
            [ InColour]  = obj.radiance(  InRay,  InScene, InDepth) ;
            
            OutColour = emission + ( colour.* InColour ); 
            
        end
        
        
        
        function  [ OutObjectData ] = intersection( obj, InScene, InRay, InDepth )
            % -- Get the total Object size --
            [~,totalObjects]   = size(InScene);
            
            inf         = 1e20;
            % OutObjectData{1} = false;   % BIsInteresect
            OutObjectData.mSmallestT     = 1e20;    % closest T
            OutObjectData.mIndex         = 0;       % object Index
            OutObjectData.mNormal        = [0,0,0]; % object Normal
            OutObjectData.mBIsInterseted = false;
            
            tempIntersectionData = cell(1,totalObjects);
            
            for j = 1:totalObjects
                % --  Try to intersect the object with the Ray -- %
                tempIntersectionData{j} = InScene{j}.intersection( InRay );
                tempIntersectionData{j}{1,1}
            end
           

            for i = 1:totalObjects
                if ( tempIntersectionData{i}{1} && tempIntersectionData{i}{1} < OutObjectData.mSmallestT )
                    OutObjectData.mSmallestT  = tempIntersectionData{i}{1};
                    OutObjectData.mIndex      = i;
                    OutObjectData.mNormal     = tempIntersectionData{i}{2};
                end
            end
             
            % -- Check if the first ray intersect with new surface or not -- %
            if ( InDepth == 0 && ( OutObjectData.mIndex ~= 6 || OutObjectData.mIndex ~= 5) )
                return
            end
            
            
%             for i =1:totalObjects
%                 % --  Try to intersect the object with the Ray -- %
%                 [ InIntersectionData ] = InScene{i}.intersection( InRay );
%                 
%                 if ( InIntersectionData{1} && InIntersectionData{1} < OutObjectData.mSmallestT )
%                     OutObjectData.mSmallestT  = InIntersectionData{1};
%                     OutObjectData.mIndex      = i;
%                     OutObjectData.mNormal     = InIntersectionData{2};
%                 end
%                 
%                 
%             end
 
            
            % Is object intersected?
            OutObjectData.mBIsInterseted = OutObjectData.mSmallestT<inf;
            
            return
        end
        
    end
    
    
    
    
end