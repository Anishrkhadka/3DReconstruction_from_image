function [OutInternalData] = loadAllNewGeneratedSurfaceFromPhotometric()
totalNoOfData      = 3;
OutInternalData.totalNoOfData = totalNoOfData;

OutInternalData.nameList           = cell(totalNoOfData,1);
OutInternalData.meshInSurfModeList = cell(totalNoOfData,1);

% -- Name of Mesh -- % 
OutInternalData.nameList{1,1} = 'Sphere';
OutInternalData.nameList{2,1} = 'Cat';
OutInternalData.nameList{3,1} = 'FemaleHumanFace_With_CoveredHair';

OutInternalData.meshMatList{1,1} = load('../InternalData/photometricSphere.mat'     );
OutInternalData.meshMatList{2,1} = load('../InternalData/photometricCat.mat'     );
OutInternalData.meshMatList{3,1} = load('../InternalData/photometricFemaleHead.mat' );


OutInternalData.meshInSurfModeList{1,1} = OutInternalData.meshMatList{1,1}.sphereSurface; % Sphere
OutInternalData.meshInSurfModeList{2,1} = flipud(OutInternalData.meshMatList{2,1}.catSurface);         % Cat
OutInternalData.meshInSurfModeList{3,1} = OutInternalData.meshMatList{3,1}.femaleHeadSurface; % female head

end