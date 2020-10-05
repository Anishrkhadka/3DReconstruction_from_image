function [ OutDirectionMatrix ] = generateDirectionMatrix ( InsubPixelSamples, InImageSize, InCamera, InSampleClass)

subPixelSample = InsubPixelSamples;
imageSize      = InImageSize;
imageWidth     = imageSize;
imageHeight    = imageSize;

camera          = InCamera;

% -- Camera X and Camera Y -- %
cx     = [ imageWidth * 0.5135 / imageHeight, 0, 0];
cy     = unit( crossP( cx, camera.direction ) )  * 0.5135;


sx  = 2;
sy  = 2;
xyz = 3;

OutDirectionMatrix = zeros(1,xyz, subPixelSample, sx,sy, imageWidth, imageHeight);


for y = imageHeight:-1:1
    
%     rng(y, 'twister' );
    for x=1:imageWidth
        
        % -- loop subpixel row --
        for sy=0:1
            
            % -- loop subpixel row --
            for sx=0:1
                
                for s = 0:subPixelSample-1
                    
%                                         r1 = 2 * rand;
%                     
%                                         if ( r1<1 )
%                                             dx = sqrt( r1 ) - 1;
%                                         else
%                                             dx = 1-sqrt( 2 - r1);
%                                         end
%                     
%                                         r2 = 2 * rand;
%                     
%                                         if ( r2<1 )
%                                             dy = sqrt(r2)-1;
%                                         else
%                                             dy = 1-sqrt(2-r2);
%                                         end
                
                    samplePoint = InSampleClass.sampleUnitSquare;
                   
                    OutDirectionMatrix(1,:, s+1,sx+1,sy+1,x,y) = ...
                    unit ( camera.direction + ...
                        cx .* ( ( (sx + 0.5 + samplePoint(1) )/2 + x )/ imageWidth  - 0.5) + ...
                        cy .* ( ( (sy + 0.5 + samplePoint(2) )/2 + y )/ imageHeight - 0.5)        );
                    
                    % -- New -- %
                    %                     OutDirectionMatrix(1,:, s+1,sx+1,sy+1,x+1,y+1) = unit ( camera.direction + ...
                    %                         cx * ( ( (sx + 0.5 + dx)/2 + x )/ imageWidth  - 0.5) + ...
                    %                         cy * ( ( (sy + 0.5 + dy)/2 + y )/ imageHeight - 0.5));
                    
                    %                    RayMat (1,:,s+1,sx+1,sy+1,x,y,1) = InCamera.mOrigin + d;
                    %                    RayMat (1,:,s+1,sx+1,sy+1,x,y,2) = d;
                    
                end
                
            end
            
        end
        
    end
    
end

end

