function [ OutallEnvironmentImages ] = loadAllEnvironmentImages()
fprintf('Loading mask image files from ./InternalData \n');

totalScene   = 3;
nameOfImages = [];

nameOfImages{end+1} = 'Sphere';
nameOfImages{end+1} = 'cat';
nameOfImages{end+1} = 'FemaleHumanFace_With_CoveredHair';

OutallEnvironmentImages.list  = [];
OutallEnvironmentImages.names = [];

    % -- Loop for 3 different scenes -- % 
    for sceneIndex = 1:totalScene
        scene = [];
       % -- Loop for 4 different Light -- % 
        for imageWithDifferentLightPosition = 1:4
            % -- Loop for 3 different ray reflection number -- % 
            
            for imageWithDifferentRayRelectionNo = 1:3
                 % -- Cat1_env_3.ppm   %            
                 fileName = strcat ( nameOfImages{sceneIndex}, ...
                                     num2str(imageWithDifferentLightPosition), ...
                                     '_env_',...
                                     num2str(imageWithDifferentRayRelectionNo) ) ;

                % -- Import 4 Image with different light  -- %
                % -- ppm, jpg any MatLab supported format -- %

                imagePath      = strcat( fileName,'.ppm' );
                imageMat       = importdata( imagePath );
                convertedImage = uint8(imageMat);
                
                scene{end+1} = convertedImage;
                
                
                OutallEnvironmentImages.names{ end+1 } = imagePath ;
            end
            
        end
        
        OutallEnvironmentImages.list { end+1 } = scene;
    end
    

end