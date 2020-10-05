% -- Main for Evaluation -- %
addpath('../Utils');
addpath('../InternalData');
addpath('./Utils');
% -- External function -- % 
addpath('./Utils/Inpaint_nans');


% -- Load LightDirection -- %
lightDirectionMatrix    = loadLightDirection('lights.txt');

% -- Rendered Image -- %
RenderedImages         = loadAllRenderedImages();

% -- Mask -- %
MaskImages             = loadAllMaskImages();

% -- Environment Image -- %
EnvironmentImageList   = loadAllEnvironmentImages();

% -- Create groundTruthMask -- %
groundTruthMask        = getAllGroundTruthMask(MaskImages);

groundTruthHeight      = getAllGroundTruthHeight(MaskImages);


multiplierToFixHeight = 1;
sphereError = Evaluation(   RenderedImages.list,...
                            RenderedImages.SphereIndex, ...
                            MaskImages.list, ...
                            lightDirectionMatrix, ...
                            groundTruthMask.list, ...
                            groundTruthHeight, ...
                            EnvironmentImageList.list);

sphereError.setheightMultiplierForEachChannel(75);
% sphereError.setHeightMultiplierToMatchGroundTruth(multiplierToFixHeight);
% sphereError.setMoveSurfaceTowardGround(true);
sphereError.init();
for i = 1:3
    sphereError.update();
    sphereError.calculateError();
end


cat = Evaluation(   RenderedImages.list, RenderedImages.catIndex, ...
                    MaskImages.list, ...
                    lightDirectionMatrix, ...
                    groundTruthMask.list, ...
                    groundTruthHeight,...
                    EnvironmentImageList.list...
                    );

cat.setheightMultiplierForEachChannel(75);
% cat.setHeightMultiplierToMatchGroundTruth(multiplierToFixHeight);
cat.setFlipSurface(true);
cat.init();
for i = 1:3
    cat.update();
    cat.calculateError();
end

femaleHead = Evaluation(    RenderedImages.list, RenderedImages.FemaleHumanFace_With_CoveredHairIndex, ...
                            MaskImages.list, ...
                            lightDirectionMatrix, ...
                            groundTruthMask.list, ...
                            groundTruthHeight,...
                            EnvironmentImageList.list );
                        
femaleHead.setheightMultiplierForEachChannel(75);
% femaleHead.setHeightMultiplierToMatchGroundTruth(multiplierToFixHeight);
% -- 
femaleHead.init();
for i = 1:3
    femaleHead.update();
    femaleHead.calculateError();
end
