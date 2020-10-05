function [ OutallRenderedImages ] = loadAllRenderedImages()
% -- Import different Image with different lighting --  %
% ===================================================== %

fprintf('Loading rendered image files from ./InternalData..\n');
totalImages = 4;
totalScene  = 3;
nameOfImages = [];
nameOfImages{end+1} = 'Sphere';
nameOfImages{end+1} = 'cat';
nameOfImages{end+1} = 'FemaleHumanFace_With_CoveredHair';


% -- Memory allocation -- %
OutallRenderedImages.list = cell(totalImages,totalScene);
OutallRenderedImages.names = [];
OutallRenderedImages.SphereIndex                           = 1;
OutallRenderedImages.catIndex                              = 2;
OutallRenderedImages.FemaleHumanFace_With_CoveredHairIndex = 3;

for sceneIndex = 1:totalScene
    for imageIndex = 1:totalImages
        
        fileName = nameOfImages{ sceneIndex };
        
        % -- Import 4 Image with different light  -- %
        % -- ppm, jpg any MatLab supported format -- %
        
        imagePath = strcat(fileName,num2str( imageIndex ),'.ppm');
        imageMat  = importdata( imagePath );
        
        OutallRenderedImages.list{imageIndex,sceneIndex} = uint8(imageMat);
        
    end
    
    OutallRenderedImages.names{ end+1 } = nameOfImages{ sceneIndex } ;

end

end