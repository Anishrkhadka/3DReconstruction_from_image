function [OutScene] = createCornallBoxAndAddMesh( InLightPosition, InImageSize, InMesh )
%Load the obj files and creates the struct of Model
path = './';

white       = [0.75,0.75,0.75];
red         = [0.75,0.25,0.25];
blue        = [0.25,0.25,0.75];
emission    = [12,12,12];
black       = [0,0,0];
noEmission  = [0,0,0];

%-- Material Type  --%
diffuseMat    = 0;


fprintf('Loading Models.. \n');
% -- Cornall Box -- % 
objestList = [];

switch InLightPosition
    case 1
        objestList{end+1} = Sphere(16, [InImageSize,InImageSize,InImageSize*2], emission,  black, diffuseMat); %rightTop
    case 2
        objestList{end+1} = Sphere(16, [0,InImageSize,InImageSize*2],  emission,  black, diffuseMat); %leftTop
    case 3
        objestList{end+1} = Sphere(16, [0,0,InImageSize*2],   emission,  black, diffuseMat); %leftBottom
    case 4
        objestList{end+1} = Sphere(16, [InImageSize,0,InImageSize*2],  emission,  black, diffuseMat); %rightBottom
end




% -- Create wall -- % 
wall      = zeros( InImageSize, InImageSize );
wallToTriangle = surf2patch(wall, 'triangles');

% -- reduce total number of triangles to just 2 triangle -- %
backWall   = reducepatch( wallToTriangle,0.0003 ) ;
leftWall   = reducepatch( wallToTriangle,0.0003 );
rightWall  = reducepatch( wallToTriangle,0.0003 );
topWall    = reducepatch( wallToTriangle,0.0003 );
bottomWall = reducepatch( wallToTriangle,0.0003 );


leftWall   = rotate ( leftWall,'y', deg2rad(-90)  );
rightWall  = rotate ( rightWall,'y', deg2rad(-90) );
topWall    = rotate ( topWall,'x', deg2rad(90)    );
bottomWall = rotate ( bottomWall,'x', deg2rad(90) );

% objest3D{end+1} = Sphere(26, [InImageSize/2,InImageSize/2,0],  noEmission,  white, diffuseMat);

% objest3D{end+1} = NewMesh(backWall,     noEmission,white,diffuseMat,[0,0,0], [1,1,1]);
objestList{end+1} = NewMesh(leftWall,   noEmission,red,diffuseMat,[1,0,-1], [1,1,1]);
objestList{end+1} = NewMesh(rightWall,	noEmission,blue,diffuseMat,[InImageSize,0,-1], [1,1,1]);
objestList{end+1} = NewMesh(topWall,    noEmission,white,diffuseMat,[0,InImageSize,-1], [1,1,1]);
objestList{end+1} = NewMesh(bottomWall,	noEmission,white,diffuseMat,[0,1,-1], [1,1,1]);


% [x,y,z] = sphere(80); r = 26;
% x = x*r; y = y*r; z = z*r;
% GroundTruthSphere = surf2patch(x,y,z, 'triangles');
% GroundTruthSphere = transf (GroundTruthSphere,[InImageSize/2,InImageSize/2,0], [1,1,1] );
% objest3D{end+1} = NewMesh(GroundTruthSphere,noEmission,white,diffuseMat,[0,0,0], [1,1,1]);
% load('../../mat/Height.mat');
% [ Zsurface ] = surf2patch( Z,'triangles' );
% objest3D{end+1} = NewMesh( Zsurface, noEmission,	[0.75,0.75,0.75], diffuseMat, [-257,-102,-248], [7.9,7.75,7.9] );


% --ExternalData -- % 

objestList{end+1} = Mesh(InMesh,noEmission,white,diffuseMat,[0,0,0], [1,1,1]);



OutScene = objestList;

end

function [OutTriStruct] = rotate (InTriStruct,InRotationAxis, InRotationAngle )

[row,~] = size( InTriStruct.vertices );

for i = 1:row
        InTriStruct.vertices(i,:) =   rotation( [ InTriStruct.vertices(i,1), ...
        InTriStruct.vertices(i,2), ...
        InTriStruct.vertices(i,3), 1],...
        InRotationAxis, InRotationAngle   );
end

InTriStruct.vertices = round(InTriStruct.vertices);

OutTriStruct = InTriStruct;
end


function [OutTriStruct] = transf (InTriStruct,InPosition, InScale )

[row,~] = size( InTriStruct.vertices );

for i = 1:row
    InTriStruct.vertices(i,:) =  transform( [ InTriStruct.vertices(i,1), ...
        InTriStruct.vertices(i,2), ...
        InTriStruct.vertices(i,3), 1],...
        InPosition, InScale  ) ;
    
end

OutTriStruct = InTriStruct;
end