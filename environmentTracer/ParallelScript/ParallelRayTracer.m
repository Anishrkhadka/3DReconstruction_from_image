classdef ParallelRayTracer <handle
    
    properties
        
        totalSceneList          = [];
        
        totalCpuCore            = 0;
        IsStartParpool          = false;
        
        camera                  = 0;
        totalSubSample          = 0;
        storedSamplersClass     = 0;
        
        rayDirectionsMatrix     = [];
        
        imageName               = [];
        imagePath               = 0;
        imageHeight             = 0;
        imageWidth              = 0;
        renderedImageMatrixList   = [];
        renderedTime = [];
        renderBlockSize         = 1;
        
    end
    
    methods
        
        function [obj] = ParallelRayTracer ( InTotalCpuCore, InRenderBlockSize, InTotalPerPixelSamples)
            
            
            obj.totalCpuCore         = InTotalCpuCore;
            obj.renderBlockSize      = InRenderBlockSize;
           
            obj.totalSubSample       = InTotalPerPixelSamples ^ 2;
            
            
        end
        
        function [obj] = init(obj)
              
            obj.getCamera();
            obj.getSampler();
            obj.getDirections()
            
        end
        
        function [obj] = startParpool(obj,InIsStartParpool)
            
            obj.IsStartParpool       = InIsStartParpool;
            
        end
        
        function [obj] = getSampler(obj)
             obj.storedSamplersClass  = Sampler(obj.totalSubSample);
        end
        
        function [obj]  = getCamera(obj)
            
            CameraZ         = obj.imageHeight * 2;
            
            cameraPosition  = [obj.imageWidth/2, obj.imageHeight/2, CameraZ] ;
            cameraDirection = [0,0,-1];
            
            obj.camera      = createCamera(cameraPosition,cameraDirection);
            fprintf('\n [pass] Camera \n');
        end
        
        function[obj] = getDirections(obj)
            imageSize = obj.imageHeight;
            obj.rayDirectionsMatrix = generateDirectionMatrix(obj.totalSubSample, imageSize, obj.camera, obj.storedSamplersClass);
            fprintf('\n [pass] Generated Random Direction for pixel \n');
        end
        
        
        function [obj]  = appendScene(obj,InScene)
            obj.totalSceneList{end+1} = InScene;
            
            fprintf('\n [pass] Add Scene \n');
        end
        
        function [obj]  = setRenderImageAttribute(obj, InImageName,InImagePath, InImageSize)
            
        obj.imageName{end+1}    = InImageName;
        obj.imagePath           = InImagePath;
        obj.imageHeight         = InImageSize;
        obj.imageWidth          = InImageSize;
            
        end
        
        
        
        function [obj] = startTracer(obj, InTotalReflectionRay )
            
            
            % -- Prepare file for Parallel pool -- %
            if (obj.IsStartParpool)
                myPool = parpool( obj.totalCpuCore );
                addAttachedFiles(myPool, 'ParallelRayTracer.m');
            end
            
            % -- Start timer
            tStart = tic;
            fprintf('Rendering ... \n ');
            
            
            % -- progress bar -- %
            
            width            = obj.imageWidth;
            height           = obj.imageHeight;
            renderBlocksize  = obj.renderBlockSize;
            camera           = obj.camera;
            totalSample      = obj.totalSubSample;
            rayDirectionsMat = obj.rayDirectionsMatrix;
            samplersClass    = obj.storedSamplersClass;
            
            [~,totalNoOfScenes] = size(obj.totalSceneList);
           
            for sceneIndex = 1:totalNoOfScenes
                % -- read the scene -- 
                scene     = obj.totalSceneList{sceneIndex};
                
                % -- all  the pixel colour -- %
                totalPixelColourMat      = cell( height/renderBlocksize,1 );
                
                % -- Progressbar -- %
                parfor_progress(height/renderBlocksize - 1);
             
               
                parfor loopY= 0:( height/renderBlocksize - 1 )
                    
                    pixelColourInColoumn = [];
                    
                    for loopX = 0:( width/renderBlocksize-1 )
                        
                        yStart = height                     - (loopY*renderBlocksize);
                        yEnd   = (height-renderBlocksize+1) - (loopY*renderBlocksize);
                        
                        xStart = 1                + (loopX*renderBlocksize);
                        xEnd   = renderBlocksize  + (loopX*renderBlocksize);
                        
                        [rgb]  = ParallelTracer (yStart,yEnd, xStart,xEnd, totalSample, ...
                            camera, scene, rayDirectionsMat, samplersClass, InTotalReflectionRay );
                        
                        
                        pixelColourInColoumn{loopX+1} = [ [rgb], yStart, xStart ];
                        
                        
                    end
                    
                    totalPixelColourMat{loopY+1,1} = pixelColourInColoumn;
                    
                    parfor_progress;
                    
                end
                parfor_progress(0);
                
                % -- check total time -- %
                tElapsed = toc(tStart);
                time.min = floor(tElapsed/60);
                time.sec = rem(tElapsed,60);
                fprintf('Rendering: Completed\n');
                fprintf('%d minutes and %f seconds\n',time.min,time.sec );
                
                obj.renderedImageMatrixList{end+1} = totalPixelColourMat;
                obj.renderedTime{end+1} = time;
                
                % -- the save the image -- %
                filename = strcat(obj.imageName{sceneIndex}, '_env_', num2str(InTotalReflectionRay), '.ppm' );
                savePPM ( filename, totalPixelColourMat, 'P3', width, height, obj.renderBlockSize );
            end
            
        end
        
        
        
    end
    
    
end
