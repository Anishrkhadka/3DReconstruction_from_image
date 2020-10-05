function [ OutExternalDataSet ] = loadExternalData ()

totalNoOfData      = 3;
% path          = '../ExternalData/';

externalData.totalNoOfData = totalNoOfData;

externalData.nameList           = cell(totalNoOfData,1);
externalData.meshList           = cell(totalNoOfData,1);
externalData.meshExpandValue    = cell(totalNoOfData,1);
externalData.meshInSurfModeList = cell(totalNoOfData,1);

% -- Name of Mesh -- % 
externalData.nameList{1,1} = 'Sphere';
externalData.nameList{2,1} = 'Cat';
externalData.nameList{3,1} = 'FemaleHumanFace_With_CoveredHair';
% externalData.nameList{2,1} = 'frog';
% externalData.nameList{3,1} = 'hippo';
% externalData.nameList{4,1} = 'lizard';
% externalData.nameList{5,1} = 'pig';
% externalData.nameList{6,1} = 'scholar';
% externalData.nameList{7,1} = 'turtle';


% -- Lood and Store of Mesh Data -- % 
externalData.meshMatList{1,1} = load('../ExternalData/Sphere/heightmap.mat'     );
externalData.meshMatList{2,1} = load('../ExternalData/PSData/cat/result.mat'     );
% externalData.meshMatList{2,1} = load( '../ExternalData/PSData/frog/result.mat'   );
% externalData.meshMatList{3,1} = load( '../ExternalData/PSData/hippo/result.mat'  );
% externalData.meshMatList{4,1} = load( '../ExternalData/PSData/lizard/result.mat' );
% externalData.meshMatList{5,1} = load( '../ExternalData/PSData/pig/result.mat'    );
% externalData.meshMatList{6,1} = load( '../ExternalData/PSData/scholar/result.mat');
% externalData.meshMatList{7,1} = load('../ExternalData/PSData/turtle/result.mat'  );

externalData.meshMatList{3,1} = load('../ExternalData/faces/face_1.mat' );

% -- custome multipler for different sets of mesh -- % 
externalData.meshExpandValue{1,1} = 1;
externalData.meshExpandValue{2,1} = 10;
% externalData.meshExpandValue{2,1} = 11;
% externalData.meshExpandValue{3,1} = 10;
% externalData.meshExpandValue{4,1} = 12;
% externalData.meshExpandValue{5,1} = 13;
% externalData.meshExpandValue{6,1} = 17;
% externalData.meshExpandValue{7,1} = 14;

externalData.meshExpandValue{3,1} = 3;

externalData.meshInSurfModeList{1,1} = externalData.meshMatList{1,1}.heightmap; % Sphere
externalData.meshInSurfModeList{2,1} = externalData.meshMatList{2,1}.Z;         % Cat
externalData.meshInSurfModeList{3,1} = flipud(externalData.meshMatList{3,1}.heightmap); % female head


OutExternalDataSet = externalData;

end