function [OutColourMatrix] = ParallelTracer ( heightStart, heightEnd, widthStart,widthEnd, ...
                                     InsubSamples, InCamera, InScene, InDirectionsMatrix, InSamplerClass)

ray              = createRay([0,0,0],[0,0,0]);
% -- Loop Row -- %
for y = heightStart:-1:heightEnd
    
    %     rng(y, 'twister' );
    for x=widthStart:widthEnd
        
        OutColourMatrix  = [0,0,0];
        
        % -- loop subpixel row --
        for sy=0:1;
            
            % -- loop subpixel row --
            for sx=0:1
                % -- init require variables -- % 
                subPixelcolour    = [0,0,0];

                 
                % -- loop subsampling -- % 
                for s=0:InsubSamples-1;
               
                    % -- Send the new ray with random direction -- % 
                    rayDirection = InDirectionsMatrix(1,:, s+1, sx+1, sy+1, x, y);
                    
                    ray.origin    = InCamera.origin + rayDirection;
                    ray.direction = rayDirection ;
                    
                    
                    subPixelcolour = subPixelcolour + radiance( ray, InScene, 0, InSamplerClass ) * (1.0/InsubSamples);
                    
                end
                
                
                r = clamp ( subPixelcolour(1) );
                g = clamp ( subPixelcolour(2) );
                b = clamp ( subPixelcolour(3) );
                
                % -- store radiance value i.e colour --
                OutColourMatrix = OutColourMatrix + [r,g,b] * 0.25 ;
                
                
            end
            
        end
        
    end
    
end

% fprintf('rendering : end\n ');
end



function [ OutColor ] = radiance(InRay, InScene, InDepth, InSamplerClass)
% -- init -- %
OutColor         = [0,0,0];

% intersect the list of object
[ InObjectData ] = intersection( InScene, InRay );


% -- Check if any object is intersected --
if( InObjectData.mBIsInterseted ~= true )
    return
end

% -- get Color, emission and material type of interseted obj --
point          = InRay.origin + InRay.direction* InObjectData.mSmallestT;


% point          = InRay.mOrigin + InRay.mDirection * InObjectData.mSmallestT;

color          = InScene{ InObjectData.mIndex }.colour;
emission       = InScene{ InObjectData.mIndex }.emission;


% materialType = InScene{ InObjectData{3} }.mMaterialType;

normal       = InObjectData.mNormal;

% Change the direction of Normal if Ray is inside/Outside
% if ( dotp( normal, InRay.mDirection) < 0 )
if ( dotp( normal, InRay.direction) < 0 )
    
    normalFixed = normal;
else
    normalFixed = normal * -1;
end

% max refl

p = max( max(color(1), color(2) ), color(3) );

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


% --- Diffuse Material --- %
% if ( materialType == 0)


r1 = 2 * 3.141593 * rand;

r2  = rand;
r2s = sqrt(rand);

w = normalFixed;
u = [0,0,0];

if ( abs( w(1) ) > 0.1 )
    u = unit ( crossP( [0,1,0], w) );
else
    u = unit ( crossP( [1,0,0], w) );
end

v         = crossP(w, u);

direction =  unit(  u * cos(r1) * r2s +  v * sin(r1) * r2s + w * sqrt( 1 - r2 ) );

%  direction = InSamplerClass.getSamplesToHemisphere() + normalFixed;
% --- recall the loop -- %

InRay.origin = point;
InRay.direction = direction;


[ InColour]  = radiance(  InRay,  InScene, InDepth, InSamplerClass ) ;

OutColor = emission + ( color.*InColour );


end

function  [ OutObjectData ] = intersection( InScene, InRay )
% -- Get the total Object size --

inf         = 1e20;

OutObjectData.mSmallestT     = 1e20;    % closest T
OutObjectData.mIndex         = 0;       % object Index
OutObjectData.mNormal        = [0,0,0]; % object Normal
OutObjectData.mBIsInterseted = false;

[~,totalObject]   = size(InScene);
% % -- Loop through total object -- %
for i = 1:totalObject
    % --  Try to intersect the object with the Ray --
    [ InIntersectionData ] = InScene{i}.intersection( InRay );
    
    if ( InIntersectionData{1} &&  ( InIntersectionData{1} < OutObjectData.mSmallestT ) )
        OutObjectData.mSmallestT  = InIntersectionData{1};
        OutObjectData.mIndex      = i;
        OutObjectData.mNormal     = InIntersectionData{2};
    end
    
end

% Is object intersected?
OutObjectData.mBIsInterseted = OutObjectData.mSmallestT<inf;

end
