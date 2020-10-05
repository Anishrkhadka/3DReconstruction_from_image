function [OutColourMatrix] = ParallelTracer ( heightStart, heightEnd, widthStart,widthEnd, ...
    InsubSamples, InCamera, InScene, InDirectionsMatrix, InSamplerClass, InTotalReflectionRay)

% -- Camera X and Camera Y --
imageSize = 64;

cx     = [ imageSize * 0.5135 / imageSize, 0, 0];
cy     = unit( crossP( cx, InCamera.direction ) )  * 0.5135;

ray = createRay([0,0,0],[0,0,0]);

% -- Loop Row -- %
    for y = heightStart:-1:heightEnd

        %     rng(y, 'twister' );
        for x=widthStart:widthEnd

            OutColourMatrix  = [0,0,0];

            % -- loop subpixel row --
            for sy=0:1

                % -- loop subpixel row --
                for sx=0:1
                    % -- init require variables -- %
                    subPixelcolour    = [0,0,0];
%                     countNoOfTries    = 0;

                    % -- loop subsampling -- %
                    for s=0:InsubSamples-1
                        
                        % -- Send the new ray with random direction -- %
                        %                         rayDirection  = InDirectionsMatrix(1,:, s+1, sx+1, sy+1, x, y);
                        
                        
                        % == Genarate first Ray that hits the back Or mesh == %
%                         while(true)
                            
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
                            
                            
                            rayDirection = unit ( InCamera.direction + ...
                                cx * ( ( (sx + 0.5 + dx )/2 + x )/ imageSize  - 0.5) + ...
                                cy * ( ( (sy + 0.5 + dy )/2 + y )/ imageSize - 0.5));
                            
                            ray.origin    = InCamera.origin + rayDirection;
                            ray.direction = rayDirection ;
                            
                            IntersectionData = intersection( InScene, ray );
                                                  
%                             if ( IntersectionData.mIndex == 6 )
                         
                                normal          = IntersectionData.mNormal;
                                
                                if ( dotp( normal, ray.direction ) < 0 )
                                    normalFixed = normal;
                                else
                                    normalFixed = normal * -1;
                                end
                                
                                ray.origin    = ray.origin + ray.direction * IntersectionData.mSmallestT;
                                ray.direction = generatedHemisphereSampling( normalFixed );
                          
%                                 break;
%                             end
%                             
%                             if (countNoOfTries > 2)
%                                 break;
%                             end
%                             
%                             countNoOfTries = countNoOfTries + 1;
%                         end
%                         
%                         countNoOfTries = 0;
                        
                        subPixelcolour = subPixelcolour + radiance( ray, InScene, 0, InTotalReflectionRay ) * (1.0/InsubSamples);
                    end

                    
                    r = clamp ( subPixelcolour(1) );
                    g = clamp ( subPixelcolour(2) );
                    b = clamp ( subPixelcolour(3) );

                    % -- store radiance value i.e colour -- %
                    OutColourMatrix = OutColourMatrix + [r,g,b] * 0.25;


                end

            end

        end

    end

end



function [ OutColor ] = radiance(InRay, InScene, InDepth, InTotalReflectionRay)
% -- init -- %
OutColor           = [0,0,0];
totalReflectionRay = InTotalReflectionRay;


% intersect the list of object
[ InObjectData ]   = intersection( InScene, InRay );

% -- Check if any object is intersected -- %
if( InObjectData.mBIsInterseted ~= true )
    return
end


% -- get Color, emission and material type of interseted obj --
pointOnSurface      = InRay.origin + InRay.direction * InObjectData.mSmallestT;
objectColor         = InScene{ InObjectData.mIndex }.colour;
objectNormal        = InObjectData.mNormal;

% objectEmission    = InScene{ InObjectData.mIndex }.emission;

[ objectInShadow ] = IsObjectInShadow( InScene,pointOnSurface );
if( objectInShadow || InObjectData.mIndex == 6 )
    return;
end



% p = max( max(color(1), color(2) ), color(3) );

InDepth = InDepth + 1;
if (InDepth >= totalReflectionRay  )
     OutColor =  objectColor;
    return;
end

% -- Change the direction of Normal if Ray is inside/Outside -- %
if ( dotp( objectNormal, InRay.direction) < 0 )
    normalFixed = objectNormal;
else
    normalFixed = objectNormal * -1;
end

% -- Hemisphere Sampling -- %
direction       = generatedHemisphereSampling( normalFixed );

InRay.origin    = pointOnSurface;
InRay.direction = direction;


[ InColour]  = radiance(  InRay,  InScene, InDepth, InTotalReflectionRay) ;

OutColor    =  objectColor.* InColour ;



end

function  [ OutObjectData ] = intersection( InScene, InRay )
% -- Get the total Object size --

inf         = 1e20;

OutObjectData.mSmallestT     = 1e20;    % closest T
OutObjectData.mIndex         = 0;       % object Index
OutObjectData.mNormal        = [0,0,0]; % object Normal
OutObjectData.mBIsInterseted = false;

[~,totalObjects]   = size(InScene);
% % -- Loop through total object -- %
% for i = totalObject:-1:1
%     % --  Try to intersect the object with the Ray --
%     [ InIntersectionData ] = InScene{i}.intersection( InRay );
%     
%     if ( InIntersectionData{1} &&  ( InIntersectionData{1} < OutObjectData.mSmallestT ) )
%         OutObjectData.mSmallestT  = InIntersectionData{1};
%         OutObjectData.mIndex      = i;
%         OutObjectData.mNormal     = InIntersectionData{2};
%     end
%     
% end

tempIntersectionData = cell(1,totalObjects);

parfor j = 1:totalObjects
    % --  Try to intersect the object with the Ray -- %
    tempIntersectionData{j} = InScene{j}.intersection( InRay );
end


for i = 1:totalObjects
    if ( tempIntersectionData{i}{1} && tempIntersectionData{i}{1} < OutObjectData.mSmallestT )
        OutObjectData.mSmallestT  = tempIntersectionData{i}{1};
        OutObjectData.mIndex      = i;
        OutObjectData.mNormal     = tempIntersectionData{i}{2};
    end
end


% Is object intersected?
OutObjectData.mBIsInterseted = OutObjectData.mSmallestT<inf;

end


function [OutDirection] = generatedHemisphereSampling( InNormal )

    r1 = 2 * 3.141593 * rand;

    r2  = rand;
    r2s = sqrt(rand);

    w = InNormal;
    u = [0,0,0];

    if ( abs( w(1) ) > 0.1 )
        u = unit ( crossP( [0,1,0], w) );
    else
        u = unit ( crossP( [1,0,0], w) );
    end

    v         = crossP(w, u);

 OutDirection =  unit(  u * cos(r1) * r2s +  v * sin(r1) * r2s + w * sqrt( 1 - r2 ) );

end


function [ IsInShadow ] = IsObjectInShadow( InScene, InPointOnObjectSurface )
% -- Sphere is Light -- % 
SphereIndexInScene   = 1;

pointOnLightSurface  = InScene{1}.getPointOnSurface; % P0
pointOnObjectSurface = InPointOnObjectSurface;       % p1

shadowRay.direction  = unit( pointOnLightSurface - pointOnObjectSurface ) ;
shadowRay.origin     = pointOnLightSurface;

IntersectionData     = intersection( InScene, shadowRay );

    if( IntersectionData.mIndex == SphereIndexInScene )
        IsInShadow = false;
    else
        IsInShadow = true;
    end

end
