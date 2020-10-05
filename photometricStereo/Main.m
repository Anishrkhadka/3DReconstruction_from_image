% -- Main -- % 
addpath('../Utils');

% -- Load all Images -- %   
renderedImages          = loadAllRenderedImages();

% -- Load LightDirection -- %
lightDirectionMatrix    = loadLightDirection('lights.txt');

% -- Load Mask -- % 
MaskImages              = loadAllMaskImages();

IsVisiableSurface = false;
% -- Sphere -- % 
sphere                  = Photometric( renderedImages.list, renderedImages.SphereIndex, lightDirectionMatrix );
sphere.init();
sphereSurface           = cleanGeneratedSurface( sphere.extractedSurface, IsVisiableSurface, MaskImages.list{ renderedImages.SphereIndex } );

% -- Cat -- % 
cat                     = Photometric( renderedImages.list, renderedImages.catIndex, lightDirectionMatrix );
cat.init();
catSurface              = cleanGeneratedSurface( cat.extractedSurface, IsVisiableSurface, MaskImages.list{ renderedImages.catIndex } );


% -- FemaleHead -- % 
femaleHead             = Photometric( renderedImages.list, renderedImages.FemaleHumanFace_With_CoveredHairIndex, lightDirectionMatrix );
femaleHead.init();
femaleHeadSurface      = cleanGeneratedSurface( femaleHead.extractedSurface,IsVisiableSurface, MaskImages.list{ renderedImages.FemaleHumanFace_With_CoveredHairIndex } );

% -- Save new surface -- % 
save('../InternalData/photometricSphere.mat'    ,'sphereSurface');
save('../InternalData/photometricCat.mat'       ,'catSurface' );
save('../InternalData/photometricFemaleHead.mat','femaleHeadSurface');

