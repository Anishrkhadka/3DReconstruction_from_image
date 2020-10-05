function [ OutAlbedo ] = calculateAlbedo ( InImagesList, InLightDirectionMatrix )

% ImageList ; 
ImageList = cell(4,1);

for channelIndex = 1:3
    % -- Extract RGB for each image and create image 
    % list with indivisual channel 
    for imageIndex = 1:4
        
        ImageList{imageIndex}   = InImagesList{imageIndex}(:,:,channelIndex);
        ImagesMatrix(:,:,imageIndex)     = double( ImageList{imageIndex} )./255;

    end
    
    LightDirection     =( inv(InLightDirectionMatrix'*InLightDirectionMatrix) )*InLightDirectionMatrix';
    
    [height, width, ~] = size(ImagesMatrix);
    
    tempAlbedo             = zeros( height, width );
    
    for heightIndex=1:height
        for widthIndex=1:width
            
            intensity = ImagesMatrix(heightIndex,widthIndex,:);
            intensity = intensity(:);
            normal    = LightDirection * intensity;
            
            surfaceMat = norm( normal );
            tempAlbedo(heightIndex,widthIndex)= surfaceMat;
            
        end
    end
    
    
    % -- Create single RGB albedo  -- % 
    OutAlbedo(:,:,channelIndex) = tempAlbedo./2 ;
    
end



end