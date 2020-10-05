classdef Visualise <handle
    
    properties
        meshList  = [];
        imageList = [];
        colourList = [];
        totalMesh   = 0;
        totalImage  = 0;
        
    end
    
    methods
        function [obj] = Visualise(InMeshList, InImageList )   
            obj.meshList  = InMeshList;
            obj.imageList = InImageList; 
        end
        
        function [obj] = appendMesh(obj, InMesh)
             obj.meshList{end+1} =InMesh;
        end
        
        function [obj] =  appendImage(obj, InImage)
             obj.imageList{end+1} = InImage;
        end
        
        function [obj] =  appendColour(obj, InColour)
             obj.colourList{end+1} = InColour;
        end
        
        function [obj] = update(obj)
            [ InMeshListrow,InMeshListcol ] = size(obj.meshList);
             obj.totalMesh = max(InMeshListrow,InMeshListcol);
             
             [InImageListrow,InImageListcol] = size(obj.imageList);
             obj.totalImage = max(InImageListrow,InImageListcol);
             
        end
        
        function processMesh(obj)
            if ( obj.totalMesh >=1)
                for meshIndex = 1:obj.totalMesh
%                     colour = [rand,rand,rand];
%                     colour = [0.75,0.75,0.75];
                    patch( obj.meshList{meshIndex},'facecolor', obj.colourList{meshIndex}, 'edgecolor', 'none');
                end
            end
            
        end
        
        function show(obj)
            obj.update();
            
            if ( obj.totalMesh >= 1)
                figure;
                
                    obj.processMesh();
                
                colormap summer
                light
                view(-30,30)
                xlabel('X');
                ylabel('Y');
                zlabel('Z');
                grid on;
%                 axis equal;
                axis manual;

                    axis equal vis3d;                % Set aspect ratio.
%                     camlight left;                   % Add a light over to the left somewhere.
                    lighting gouraud;                % Use decent lighting.

            else
             
             for imageIndex = 1:obj.totalImage
                  figure;
                  imshow(obj.imageList{imageIndex} );
             end
                
                
            end
            
        end
        
        
    end
    
end