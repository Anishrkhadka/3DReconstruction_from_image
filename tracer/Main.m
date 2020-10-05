
addpath('./Other/ParallelScript');
addpath('../Utils');
addpath('./Scene');
addpath('./Objects');

renderdImageSize       = 64;
renderdImagePath       ='./';

% -- samples should always be in square -- %
totalPerPixelSamples   = 2;


totalCpuCore         = 2;
renderBlockSize      = 1;
IsStartParpool       = true;


% -- init box for Mesh visualisation in Matlab -- %
box = [];
save(strcat('./box'),'box');

% -- IsVisualise  = true, displays the downsampled version of mesh (both cat and face) - %
IsVisualise     = true;
[ externalData ] = loadExternalObjFiles();


parallelRayTracer = ParallelRayTracer ( totalCpuCore, renderBlockSize, totalPerPixelSamples);

for meshIndex = 1:1
    
    % -- lightIndex 1-4 generates 4 scene with different light position -- %
    for lightIndex = 1:4
        
        fprintf('ExternalData Name: %s \n',externalData{meshIndex,1}.name);
        
        scene = createCornallBoxAndAddMesh ( lightIndex, renderdImageSize, externalData{meshIndex,1}.mesh );
        
        % -- Add the Scene -- %
        parallelRayTracer.setRenderImageAttribute( strcat( externalData{meshIndex,1}.name,num2str(lightIndex),'.ppm' ), ...
                                                   renderdImagePath, renderdImageSize)
        
        parallelRayTracer.appendScene( scene );
        
    end
    
end


% -- Init the tracer -- %
parallelRayTracer.init();
parallelRayTracer.startParpool(IsStartParpool);
parallelRayTracer.startTracer();


