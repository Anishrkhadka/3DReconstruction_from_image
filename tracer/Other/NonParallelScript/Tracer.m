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
            
            parfor_progress( obj.imageHeight );
            
            for y = 0:obj.imageHeight-1
                
                % -- set random generation algorithm --
                %  rng(y,'twister');
                
                for x= 0:obj.imageWidth-1
                    i = ( ( obj.imageHeight - y - 1) * obj.imageWidth + x ) + 1;
                    
                    OutAllPixelColourMatrix{i}  = [0,0,0];
                    
                    % -- loop subpixel row -- %
                    for sy = 0:1;
                        
                        % -- loop subpixel row -- %
                        for sx = 0:1
                            
                            subPixelColour   = [0,0,0];
                            ray              = createRay([0,0,0],[0,0,0]);
                            
                            % -- loop subsampling -- %
                            for s = 0:obj.totalSubSampling-1;
                                
                                direction = InDirectionMatrix(1,:, s+1,sx+1,sy+1,x+1,y+1);
                                
                                ray.origin    = InCamera.origin + direction;
                                ray.direction = direction;
                                
                                subPixelColour = subPixelColour + obj.radiance( ray, InScene, 0 ) *(1.0/obj.totalSubSampling);
                                
                            end
                            
                            r = clamp ( subPixelColour(1) );
                            g = clamp ( subPixelColour(2) );
                            b = clamp ( subPixelColour(3) );
                            
                            % -- store radiance value i.e colour -- %
                            OutAllPixelColourMatrix{i} = OutAllPixelColourMatrix{i} + [r,g,b] * 0.25 ;
                            % --Test -- %
                           
                            %
                        end
                        
                    end
                    
                     
                end
                
                % -- Progress Bar --%
                parfor_progress;
            end
            parfor_progress(0);
            
            OutBool = true;
        end
        
        function [ OutColour ] = radiance(obj, InRay, InScene, InDepth)
            % -- init -- %
            OutColour         = [0,0,0];
            
            % intersect the list of object
            [ InObjectData ] = obj.intersection( InScene, InRay );
            
            % -- Check if any object is intersected --
            if( InObjectData.mBIsInterseted ~= true )
                return
            end
            
            % -- get Color, emission and material type of interseted obj --
            point          = InRay.origin + InRay.direction * InObjectData.mSmallestT;
            colour          = InScene{ InObjectData.mIndex }.colour;
            emission       = InScene{ InObjectData.mIndex }.emission;
            
            
            % materialType = InScene{ InObjectData{3} }.mMaterialType;
            
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
            InDepth = InDepth + 1;
            if ( InDepth > 5 )
                if ( rand < p )
                    colour = colour * (1/p);
                else
                    % -- return Light --
                    OutColour   = emission;
                    return
                end
            end
            
            
            % --- Diffuse Material --- %
            % if ( materialType == 0)
            
%             r1 = 2 * 3.141593 * rand;
%             
%             r2  = rand;
%             r2s = sqrt(r2);
%             
%             w = normalFixed;
%             u = [0,0,0];
%             
%             if ( abs( w(1) ) > 0.1 )
%                 u = unit ( crossP( [0,1,0], w) );
%             else
%                 u = unit ( crossP( [1,0,0], w) );
%             end
%             
%             v         = crossP(w, u);
%             
%             direction =  unit(  u * cos(r1) * r2s + ...
%                             v * sin(r1) * r2s + ...
%                             w * sqrt( 1 - r2 ) );

            direction = obj.sampler.getSamplesToHemisphere() + normalFixed;
            
            InRay.origin = point;
            InRay.direction = direction;
            
            [ InColour]  = obj.radiance(  InRay,  InScene, InDepth) ;
            
            OutColour = emission + ( colour.*InColour);
            
            
        end
        
        function  [ OutObjectData ] = intersection( obj, InScene, InRay )
            % -- Get the total Object size --
            [~,totalObjects]   = size(InScene);
            
            inf         = 1e20;
            % OutObjectData{1} = false;   % BIsInteresect
            OutObjectData.mSmallestT     = 1e20;    % closest T
            OutObjectData.mIndex         = 0;       % object Index
            OutObjectData.mNormal        = [0,0,0]; % object Normal
            OutObjectData.mBIsInterseted = false;
            
            
            for i = totalObjects:-1:1
                % --  Try to intersect the object with the Ray -- %
                [ InIntersectionData ] = InScene{i}.intersection( InRay );
                
                if ( InIntersectionData{1} && InIntersectionData{1} < OutObjectData.mSmallestT )
                    OutObjectData.mSmallestT  = InIntersectionData{1};
                    OutObjectData.mIndex      = i;
                    OutObjectData.mNormal     = InIntersectionData{2};
                end
                
                
            end
            % end
            
            % Is object intersected?
            OutObjectData.mBIsInterseted = OutObjectData.mSmallestT<inf;
            
            return
        end
        
    end
    
    
    
    
end