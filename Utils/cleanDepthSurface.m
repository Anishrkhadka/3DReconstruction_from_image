function [OutHeightmap] = cleanDepthSurface( InDepthSurface )

depthSurface = InDepthSurface;

% for i = 1:64
%     for j = 1:64
%         if (depthSurface(i,j) == 0)
%             depthSurface(i,j) = 0;
%         end
%         depthSurface(i,j) = depthSurface(i,j);
%     end
% end

% -- Clean boarder -- % 
for i = 62:64
    depthSurface(:,i) = 0;
    depthSurface(i,:) = 0;
end

% -- Change the direction of the sphere -- % 
depthSurface = -depthSurface;
% -- Remove the unnecessary surface -- % 
depthSurface (depthSurface(:,:)==0) = NaN;

% -- Move the object above the ground -- % 
m = min(min(depthSurface));
depthSurface = depthSurface-m;

% -- Change empty space to flat ground -- % 
depthSurface(isnan(depthSurface)) = 0;


% -- Create the image mask -- % 
mask         = depthSurface;
mask(mask>0) = 1;
imshow(mask);

% -- Display rought surface  --%
figure;surf(depthSurface);

% -- Smooth the surface / mask-- % 
for smoothTimes = 1:2
    
    a = depthSurface;
    b = mask;
    
    depthSurface  = zeros(64,64);
    
    for i = 2:64-1
        for j = 2:64-1
            depthSurface(i,j)  = (  a(i-1,j-1) +  a(i-1,j-1) + a(i+1, j-1) + ...
                a(i-1,j  ) +  a(i,  j)     + a(i+1, j)  + ...
                a(i+1,j+1) +  a(i+1,j+1) + a(i+1, j+1) )/9;
            
            mask(i,j)  =     (  b(i-1,j-1) +  b(i-1,j-1) + b(i+1, j-1) + ...
                b(i-1,j  ) +  b(i,  j)     + b(i+1, j)  + ...
                b(i+1,j+1) +  b(i+1,j+1) + b(i+1, j+1) )/9;
            
        end
    end
end


% -- Show the mask --- %
figure;imshow(mask)

% -- Remove unecessary surface with mask -- % 
OutHeightmap = depthSurface;
OutHeightmap(mask==0) = 0;

% --- Companseate the smooth effect by adding 3 -- % 
OutHeightmap = OutHeightmap+3;

% -- Save the mask as SphereMask.ppm -- % 
imwrite(mask,'SphereMask.ppm');
% -- Save the new surface -- % 
save('heightmap.mat','heightmap');

% -- Display the new surface -- % 
figure;surf(OutHeightmap);


end