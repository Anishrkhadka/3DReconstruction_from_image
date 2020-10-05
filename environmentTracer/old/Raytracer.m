classdef Raytracer < handle
    
    properties
        imageName = [];
        imagePath = 0;
        totalSubSample  = 0;
        camera    = [];
        sceneList = [];
        tracer    = 0;
        directionMatrix = 0;
        
        imageWidth = 0;
        imageHeight = 0;
        
        imageRenderList = [];
    end
    
    
    methods
        function [obj] = Raytracer( InSample )
            obj.totalSubSample   = InSample^2;
            obj.getCamera();

            
        end
        
        function [obj]  = setRenderImageAttribute(obj, InImageName,InImagePath, InImageSize)
            
            obj.imageName{end+1}    = InImageName;
            obj.imagePath           = InImagePath;
            obj.imageHeight         = InImageSize;
            obj.imageWidth          = InImageSize;
            
        end
        
        
        function [obj]  = getCamera(obj)
            
            CameraZ = obj.imageHeight * 2;
            
            cameraPosition  = [obj.imageWidth/2, obj.imageHeight/2, CameraZ] ;
            cameraDirection = [0,0,-1];
            
            obj.camera      = createCamera(cameraPosition,cameraDirection);
            fprintf('\n [pass] Camera \n');
        end
        
        function [obj]  = appendScene(obj, InScene)
            obj.sceneList{end+1} = InScene;
            fprintf('\n [pass] Add Scene \n');
        end
        
        function [obj] = createTracer(obj)
            % -- store Render class as tracer -- % 
            obj.tracer = Tracer( obj.imageWidth, obj.imageHeight, obj.totalSubSample );
            fprintf('\n [pass] Create Tracer Engine \n');
        end
        
        function[obj] = getDirections(obj)
            
            imageSize = obj.imageHeight;
            obj.directionMatrix = generateDirectionMatrix(obj.totalSubSample, imageSize, obj.camera);
            fprintf('\n [pass] Generated Random Direction for pixel \n');
        end
        
        
        
        function [obj] = startTracer(obj)
            fprintf('\n [  - ] Render Started \n');
            totalSceneList = obj.sceneList;
            [~,totalNoOfScene] = size(totalSceneList);
            
            % -- render all the scene -- %
            for i = 1:totalNoOfScene
                
                % -- Start timer -- %
                tStart = tic;
                
                % -- Start Rendering -- %
                [IsBRenderStart, InColourMatrix] =  obj.tracer.render( obj.camera, totalSceneList{i}, obj.directionMatrix );
                % -- Finish Rendering -- %
                
                if ( IsBRenderStart ~= true)
                    fprintf('Render failed!\n');
                    return
                end
                
                % -- End total time -- %
                tElapsed = toc(tStart);
                fprintf('\n [pass] Render Started \n');
                fprintf('%d minutes and %f seconds\n',floor(tElapsed/60),rem(tElapsed,60));
                
                obj.imageRenderList{end+1} = InColourMatrix;
                
                
                fileName = strcat(obj.imagePath{totalNoOfScene},obj.imageName,num2str( i ),'.ppm');
                savePPM ( fileName, InColourMatrix, 'P3', obj.imageWidth, obj.imageHeight );
                
            end
        end
        
        
        
        
        
    end
    
end