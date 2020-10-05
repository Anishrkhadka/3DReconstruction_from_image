
addpath('../Utils');
addpath('../tracer/Scene');
addpath('../tracer/Objects');

renderedImageSize = 64;
renderedImagePath = './';
sample = 1;

IsVisualise = false;
[externalData ] = convertAndCreateListOfExternalData( IsVisualise );

raytracer = Raytracer(sample);

for meshIndex = 1:1

    for lightIndex = 1:1
        
        fprintf('ExternalData Name: %s \n',externalData{meshIndex,1}.name);
        
        scene = createCornallBoxAndAddMesh ( lightIndex, renderedImageSize, externalData{meshIndex,1}.mesh );
        
        raytracer.setRenderImageAttribute( strcat( externalData{meshIndex,1}.name,num2str(lightIndex),'.ppm' ), ...
                                                   renderedImagePath, renderedImageSize)
        
        raytracer.appendScene( scene );
    end
    
end
 
raytracer.createTracer();
raytracer.startTracer();