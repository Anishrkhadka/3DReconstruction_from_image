classdef Photometric<handle
    
    properties
        extractedSurface = [];
        normal           = [];
        intensityMatrix  = [];
        imageList        = [];
        lightDirectionMatrix=0;
        sceneIndex = 0;
        
    end
    
    
    methods
        
        function [obj] = Photometric(InImageList,InSceneIndex, InLightDirectionMatrix)
            
            obj.imageList = InImageList;
            
            obj.lightDirectionMatrix = InLightDirectionMatrix;
            obj.sceneIndex = InSceneIndex;
        end
        
        function [obj] = calculateNormalFromImages(obj)
            
            totalLight = 4;
            totalImage = 4;
            
            % -- Get Image dimension (Height x Width)-- %
            image = obj.imageList{1};
            [imageHeight, imageWidth, ~] = size(image);
            
            % -- h X w x noLight --
            obj.intensityMatrix = zeros(imageHeight, imageWidth, totalLight);
            
            for index = 1:totalImage
                % -- get a single image at a time -- %
                image = obj.imageList{index};
                obj.intensityMatrix(:,:,index)= rgb2gray( image );
                
            end
            
            
            obj.normal = zeros( imageHeight, imageWidth, 3 );
            
            LL=( inv(obj.lightDirectionMatrix'*obj.lightDirectionMatrix) )*obj.lightDirectionMatrix';
            

            for height = 1:imageHeight
                for width = 1:imageWidth
                    % -- Extract normal and create Nx1 Matrix --
                    intensity = reshape(  obj.intensityMatrix (height, width, : ), [totalImage,1] );
                    
                    %-- Calculate the surface Matrix --
                    surfaceMat = LL*intensity;
                    
                    %-- if sufaceMatrix is not equal to zero then calcaulate normal --
                    if ( norm(surfaceMat) ~= 0 )
                        tempNormal = (surfaceMat./norm(surfaceMat));
                    else
                        tempNormal = [0;0;0];
                    end
                    
                    obj.normal(height, width, :) = tempNormal;
                end
                
            end
            
            
        end
        
        function [obj] = calculatedHeightFromNormal(obj)
            
            % -- Get Normal -- %
            normalx= obj.normal(:,:,1);
            normaly= obj.normal(:,:,2);
            normalz= obj.normal(:,:,3);
            
            
            p = -obj.normal(:,:,2)./( obj.normal(:,:,3) + eps );
            q =  obj.normal(:,:,1)./( obj.normal(:,:,3) + eps );
            
%             if ( InMethod==1 )
                disp('PS Method: MultiLelelIntegration');
                
                cd './Utils/MultiLelelIntegration';
                
                obj.extractedSurface = Integ_MultiLelelIntegration( normalx, normaly, normalz );
                obj.extractedSurface = obj.extractedSurface * size( normalx, 1 ) * size( normalx, 2 );
                
                cd '../..';
                
%             elseif (InMethod==2)
%                 % Least square integration, for comparison
%                 %     cd './Utils/weighted_poisson'
%                 obj.extractedSurface = -direct_weighted_poisson(p,q);
%                 %     cd '../..'
%             elseif (InMethod==3)
%                 %   cd './Utils/weighted_poisson'
%                 epsilon = 0.01;
%                 b = 3.5;
%                 
%                 for index = 1:size(obj.intensityMatrix,3)
%                     II = obj.intensityMatrix(:,:,index);
%                     I(:,index) = II(:);
%                 end
%                 
%                 mask      = q.*0+1;
%                 weights   = calculate_weights_ps(I,mask,b,epsilon);	% photometric stereo-based weighting
%                 trace     = 1;              % to keep some trace of what is going on
%                 methodSolv = 'Cholesky';	% for solving the resulting linear system
%                 % Integration on the masked domain
%                 obj.extractedSurface = -direct_weighted_poisson(p,q,[],weights,trace,methodSolv);
%                 %     cd '../..'
%             end

            
        end
       
        function [obj] = init(obj)
            
            tempImageList = [];
            for listIndex = 1:4
                tempImageList{listIndex} =  obj.imageList{listIndex,  obj.sceneIndex};
            end
            obj.imageList = tempImageList;
            
            
            obj.calculateNormalFromImages();
            obj.calculatedHeightFromNormal();
            
        end
        
        function [obj] = displayMesh(obj)
            
         figure;surf(obj.extractedSurface);
        end
    end
    
end