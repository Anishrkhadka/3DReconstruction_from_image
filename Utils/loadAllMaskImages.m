function [ OutallMaskImages ] = loadAllMaskImages()
fprintf('Loading mask image files from ./InternalData \n');

totalScene   = 3;
nameOfImages = [];

nameOfImages{end+1} = 'SphereMask';
nameOfImages{end+1} = 'catMask';
nameOfImages{end+1} = 'FemaleHumanFace_With_CoveredHairMask';

OutallMaskImages.list  = [];
OutallMaskImages.names = [];

    for sceneIndex = 1:totalScene

        fileName = nameOfImages{ sceneIndex };

        % -- Import 4 Image with different light  -- %
        % -- ppm, jpg any MatLab supported format -- %

        imagePath      = strcat(fileName,'.ppm');
        imageMat       = importdata( imagePath );
        convertedImage = uint8(imageMat);
        
        OutallMaskImages.list { end+1 } = convertedImage(:,:,1); 
        OutallMaskImages.names{ end+1 } = nameOfImages{ sceneIndex } ;
    end
    

end