
addpath('./Other/NonParallelScript');
addpath('./Utils');
addpath('./Scene');
addpath('./Objects');

imageName = 'Cat';
imageSize = 64;
imagePath = './';
sample = 2;

IsVisualise = false;
[externalData ] = convertAndCreateListOfExternalData( IsVisualise );

raytracer = Raytracer( imageName,imageSize,imagePath, sample);


for meshIndex = 1:1

    for lightIndex = 1:1
        fprintf('ExternalData Name: %s \n',externalData{meshIndex,1}.name);
        scene = createCornallBoxAndAddMesh ( lightIndex, imageSize, externalData{meshIndex,1}.mesh );
        raytracer.appendScene( scene );
    end
    
end
 
raytracer.createTracer();
raytracer.startTracer();