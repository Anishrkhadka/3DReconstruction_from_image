% -- calculate Error -- %
function [OutErrors]  = calculateErrors(InImagesList, InImageIndex, InLightDirectionMatrix, InImageMask, Inheights, InAlbedoGroundTruthMask)

OutErrors.heightError = 0;
OutErrors.albedoError = 0;
OutErrors.angularNormalerror = 0;

% -- extract ImageList for given ImageIndex-- % 
imageList = cell(4,1);
for listIndex = 1:4
    imageList{listIndex} = InImagesList.list{listIndex, InImageIndex};
end


% -- Create Normal -- %
[ InNormal, InNormalForEachChannel ] = calculateNormalForEachChannel (imageList, InLightDirectionMatrix);
% -- Create Depth -- %
MultiPlier = 74;
[ InHeight ]                         = calculateHeightForEachChannel (InNormalForEachChannel, MultiPlier);
% -- Create albeo  -- %
[ InAlbedo ]                         = calculateAlbedo ( imageList, InLightDirectionMatrix  );



end
