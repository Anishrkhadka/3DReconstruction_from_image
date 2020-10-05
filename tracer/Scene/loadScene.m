function [OutScene] = loadScene( InLightPosition , InZsurface )
%Load the obj files and creates the struct of Model
% 0 = diffuseMatuse, 1= Specular, 2 = Dielect, 3  = emission
white       = [0.75,0.75,0.75];
red         = [0.75,0.25,0.25];
blue        = [0.25,0.25,0.75];
emission    = [12,12,12];
black       = [0,0,0];
noEmission  = [0,0,0];

%Material Type
diffuseMat    = 0;


fprintf('Loading Models.. \n');
% -- Cornall Box --
objest3D = [];

switch InLightPosition
    case 1
        objest3D{end+1} = Sphere(32, [205,370,-6],   emission,  black, diffuseMat); %rightTop
    case 2
        objest3D{end+1} = Sphere(32, [-205,370,-6],  emission,  black, diffuseMat); %leftTop
    case 3
        objest3D{end+1} = Sphere(32, [-205,-45,-6],  emission,  black, diffuseMat); %leftBottom
    case 4
        objest3D{end+1} = Sphere(32, [205,-45, -6],  emission,  black, diffuseMat); %rightBottom
end

% -- init box for Mesh visualisation in Matlab -- %
% box = [];
% save('../../mat/box','box');
% 
% objest3D{end+1} = Mesh('../scene/box/back.obj',	 noEmission,white, 	diffuseMat,[0,150,-245], [25,25,1]);
% objest3D{end+1} = Mesh('../scene/box/bottom.obj',noEmission,white, 	diffuseMat,[0,-95,-210], [25,1,25]);
% 
% objest3D{end+1} = Mesh('../scene/box/left.obj',	 noEmission,red, 	diffuseMat,[-250,150,-220], [-1,25,25]);
% objest3D{end+1} = Mesh('../scene/box/right.obj', noEmission,blue, 	diffuseMat,[250,150,-220], [1,25,25]);
% objest3D{end+1} = Mesh('../scene/box/top.obj',	 noEmission,white,diffuseMat,[0,395,-210], [25,1,25]);

% load('../../mat/Height.mat');
% objest3D{end+1} = NewMesh( Zsurface, noEmission,	[0.75,0.75,0.75], diffuseMat, [-257,-102,-248], [7.9,7.75,7.9] );

load(InZsurface);
% 
% % --Cat -- % 
% % -- create plane for nan -- % 
Zsurface.vertices( isnan( Zsurface.vertices ) ) = -15;
objest3D{end+1} = NewMesh(Zsurface,	noEmission,white,diffuseMat,[-115,-15,-195.5], [1.8,1.8,3.3]);

% 

OutScene = objest3D;

end
