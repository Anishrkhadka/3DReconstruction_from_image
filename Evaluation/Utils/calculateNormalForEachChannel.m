% == function calcuates the normal for each channel (R,G,B) and returns new avarage Normal ==  %
function [ OutNormal, OutNormalForEachChannel ]= calculateNormalForEachChannel (InImagesList, InLightDirectionMatrix)
% -- Channel = RGB -- % 
ImageList  = cell(1,4);
NormalList = cell(1,3);

    for channelIndex = 1:3
    
        % -- Extract RGB for each image and create image
        % list with indivisual channel
        for imageIndex = 1:4

            ImageList{imageIndex}   = InImagesList{imageIndex}(:,:,channelIndex);
            ImagesMatrix(:,:,imageIndex)     = double( ImageList{imageIndex} )./255;

        end

        LightDirection     =( inv(InLightDirectionMatrix'*InLightDirectionMatrix) )*InLightDirectionMatrix';

        [height, width, ~] = size(ImagesMatrix);

        
        tempNormal      = zeros(height, width,3);

        for heightIndex=1:height
            for widthIndex=1:width

                intensity = ImagesMatrix(heightIndex,widthIndex,:);
                % -- dimention reduction -- % 
                intensity = intensity(:);
                
                normal    = LightDirection * intensity;

                surfaceMat = norm( normal );

                if ( surfaceMat ~= 0 )
                    tempNormal(heightIndex,widthIndex,:)=normal./surfaceMat;
                end

            end
        end



        % -- Create single RGB albedo  -- %
        NormalList{channelIndex} = tempNormal ;

    end

    OutNormalForEachChannel = NormalList;
    OutNormal               = ( NormalList{1}+NormalList{2}+NormalList{3} )./3;
end