function [OutColourMatrix] = ParallelTracer ( heightStart, heightEnd, widthStart,widthEnd, ...
                                     InsubSamples, InCamera, InScene, InDirectionsMatrix, InSamplerClass)

ray              = createRay([0,0,0],[0,0,0]);

InObjectData.mSmallestT     = 1e20;    % closest T
InObjectData.mIndex         = 0;       % object Index
InObjectData.mNormal        = [0,0,0]; % object Normal
InObjectData.mBIsInterseted = false;

% -- Loop Row -- %
for y = heightStart:-1:heightEnd
    
    %     rng(y, 'twister' );
    for x=widthStart:widthEnd
        
        OutColourMatrix  = [0,0,0];
        
        % -- loop subpixel row --
        for sy=0:1
            
            % -- loop subpixel row --
            for sx=0:1

                % -- loop subsampling -- % 
                for s=0:InsubSamples-1
               
                    % -- Send the new ray with random direction -- % 
                    rayDirection = InDirectionsMatrix(1,:, s+1, sx+1, sy+1, x, y);
                    
                    ray.origin    = InCamera.origin + rayDirection;
                    ray.direction = rayDirection ;
                    
                    [ InObjectData ] = intersection( InScene, ray );


                end
                
%                 if(InObjectData.mSmallestT<inf)
                    OutColourMatrix = InObjectData.mSmallestT;
%                 else
%                     OutColourMatrix= 0;
%                 end
            end
            
        end
        
    end
    
end

% fprintf('rendering : end\n ');
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
