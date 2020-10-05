classdef Evaluation<handle
 % -- 1 class = 1 scene -- % 
    properties
        % -- 4 x ImagesWithDifferentLight -- % 
        imageList = cell(1,4);
        sceneIndex = 0;
        lightDirectionMatrix = 0;
        
        heightError = [];
        albedoError = [];
        normalError = [];
        angularNormalError = [];
        
        
        normal               = 0;
        normalForEachChannel = cell(1,3);
        height               = 0;

        heightMultiplierForEachChannel     = 0;
        heightMultiplierToMatchGroundTruth = 1;
        albedo               = 0;
        
        storeNormal          = [];
        storeHeight          = [];
        storeAlbedo          = [];
        % -- 3 x scene -- % 
        imageMask            = 0;
        
        groundTruthHeight     = 0;
        groundTruthAlbedoMask = 0;
        
        environmentImagesList = [];
        imageWithRay1 = [];
        imageWithRay2 = [];
        imageWithRay3 = [];
        
        differenceImage = [];
        count = 1;
        
        IsflipSurface = false;
        IsMoveSurfaceTowardGround =  false;

    end
    
    methods
        function [obj] = Evaluation( InImageList,InSceneIndex, InImageMask, ...
                                     InLightDirectionMatrix, InGroundTruthAlbedoMask, InGroundTruthHeight,...
                                     InEnvironmentImages)
            
            obj.imageList            = InImageList;
            obj.sceneIndex           = InSceneIndex;
            obj.lightDirectionMatrix = InLightDirectionMatrix;
            
            obj.groundTruthAlbedoMask= InGroundTruthAlbedoMask{ InSceneIndex };
            
            obj.imageMask            = InImageMask{ InSceneIndex };
            
            
            obj.groundTruthHeight    = InGroundTruthHeight{InSceneIndex};
            
         
            obj.environmentImagesList = InEnvironmentImages{InSceneIndex};
            
        end
        
        function [obj] = setheightMultiplierForEachChannel(obj,InValue)
            obj.heightMultiplierForEachChannel = InValue;
        end
        
        function [obj]  = setHeightMultiplierToMatchGroundTruth(obj, InValue)
            
            obj.heightMultiplierToMatchGroundTruth = InValue;
            
        end
        
        
        function [obj] = init(obj)
            
            imgList = [];
            for listIndex = 1:4
                imgList{listIndex} =  obj.imageList{listIndex,  obj.sceneIndex};
            end
            obj.imageList = imgList;
            
            for i = 1:3:12
                obj.imageWithRay1{end+1} = (obj.environmentImagesList{i});
            end
            
            for i = 2:3:12
                obj.imageWithRay2{end+1} = (obj.environmentImagesList{i});
            end
            
            for i = 3:3:12
                obj.imageWithRay3{end+1} = (obj.environmentImagesList{i});
            end
            
            
            % -- populate the difference image list -- % 
            obj.UpdateDifferenceImageList();
            
            if(obj.IsflipSurface)
                obj.imageMask   = flipud(obj.imageMask);
            end
            
        
            % -- Calculate the error for original -- % 
           obj.calculateErrorForOrigin();
           
           
        end
        
        
        function [obj] = get_Normal_Height_Albedo(obj, InImageList)
              
            % -- Create Normal -- %
            [ obj.normal, obj.normalForEachChannel ] = calculateNormalForEachChannel (InImageList, obj.lightDirectionMatrix);
            % -- Create Depth -- %
            [ obj.height ]                           = calculateHeightForEachChannel (obj.normalForEachChannel, obj.heightMultiplierForEachChannel);
            
            if(obj.IsflipSurface)
                obj.height      = flipud(obj.height);
            end
            
                       
            % ======================= CLEAN UP PROCESSS ===================== % 
            obj.height =  cleanPhotoMetricSurface(obj.height, 0,...
                                                  obj.imageMask,  ...
                                                  obj.heightMultiplierToMatchGroundTruth, ...
                                                  obj.IsMoveSurfaceTowardGround);

%             
         
             
            
            % -- Create albeo  -- %
            [ obj.albedo ]                         = calculateAlbedo ( InImageList, obj.lightDirectionMatrix  );
            
                % -- store height information for each ori + ray(1-3) -- %
             tempHeight = obj.height;
             tempHeight(isnan(tempHeight)) = 0;
             obj.storeHeight{end+1} = tempHeight;
             obj.storeNormal{end+1} = obj.normal;
             obj.storeAlbedo{end+1} = obj.albedo;

        end
        
        function [obj] = UpdateDifferenceImageList(obj)
            value = 0.2;
            obj.differenceImage{end+1} = getDifferenceImage(obj.imageList,obj.imageWithRay1,value);
            obj.differenceImage{end+1} = getDifferenceImage(obj.imageList,obj.imageWithRay2,value);
            obj.differenceImage{end+1} = getDifferenceImage(obj.imageList,obj.imageWithRay3,value);
            
            
        end
        
        function [obj] = update(obj)
            
            obj.count = obj.count+1;
            
            % --- Load Environment Colour (Ray 1 - 3) in sequence -- % 
            if (obj.count>1 &&obj.count<=4 )
                obj.get_Normal_Height_Albedo( obj.differenceImage{obj.count-1} );
            end
            
        end
      
        
        function [obj] = calculateError(obj)
          
        
            imageMaskInDouble  = double(  obj.imageMask  )./255;
            imageMaskInDouble( imageMaskInDouble>0 ) = 1;
            [groundTruthNormalX,groundTruthNormalY,groundTruthNormalZ]  = surfnorm( obj.groundTruthHeight );
            
            groundTruthNormalX( isnan(groundTruthNormalX) ) = 0;
            groundTruthNormalY( isnan(groundTruthNormalY) ) = 0;
            groundTruthNormalZ( isnan(groundTruthNormalZ) ) = 0;
            
            normalFromGroundTruth(:,:,1) = groundTruthNormalX;
            normalFromGroundTruth(:,:,2) = groundTruthNormalY;
            normalFromGroundTruth(:,:,3) = groundTruthNormalZ;
            
            % -- Calculate the Height Error -- % 
            ErrorHeight      = abs(obj.groundTruthHeight - obj.height);
            % -- temp fix for heighError = NaN problem -- % 
            tempMean =  ErrorHeight( imageMaskInDouble > 0 );
            tempMean(isnan(tempMean)) = 0;
            
            obj.heightError{end+1}  = mean( tempMean );
            
            
            % -- Calculate the Albedo Error -- % 
            ErrorAlbedo = abs( obj.groundTruthAlbedoMask - obj.albedo );
            % -- Extract the RGB channel -- % 
            ErrorAlbedoForR = ErrorAlbedo(:,:,1);
            ErrorAlbedoForG = ErrorAlbedo(:,:,2);
            ErrorAlbedoForB = ErrorAlbedo(:,:,3);

            ErrorAlbedoForR = mean(ErrorAlbedoForR( imageMaskInDouble>0 ));
            ErrorAlbedoForG = mean(ErrorAlbedoForG( imageMaskInDouble>0 ));
            ErrorAlbedoForB = mean(ErrorAlbedoForB( imageMaskInDouble>0 ));
            
            obj.albedoError{end+1} = ( ErrorAlbedoForR + ErrorAlbedoForG + ErrorAlbedoForB )./3;
            
            % -- Calcuate the Normal Error -- % 
            ErrorNormal  = abs( normalFromGroundTruth - obj.normal );
            
            ErrorNormalX = ErrorNormal(:,:,1);
            ErrorNormalY = ErrorNormal(:,:,2);
            ErrorNormalZ = ErrorNormal(:,:,3);
            
            ErrorNormalX= mean( ErrorNormalX( imageMaskInDouble>0 ) );
            ErrorNormalY= mean( ErrorNormalY( imageMaskInDouble>0 ) );
            ErrorNormalZ= mean( ErrorNormalZ( imageMaskInDouble>0 ) );
            
            obj.normalError{end+1}=( ErrorNormalX + ErrorNormalY + ErrorNormalZ )./3;
            
            
            % -- Calcuate the angularError -- % 
            
            xCt=normalFromGroundTruth(:,:,1);xC=xCt(imageMaskInDouble>0);
            yCt=normalFromGroundTruth(:,:,2);yC=yCt(imageMaskInDouble>0);
            zCt=normalFromGroundTruth(:,:,3);zC=zCt(imageMaskInDouble>0);
            
            xEt=normalFromGroundTruth(:,:,1);xE=xEt(imageMaskInDouble>0);
            yEt=normalFromGroundTruth(:,:,2);yE=yEt(imageMaskInDouble>0);
            zEt=normalFromGroundTruth(:,:,3);zE=zEt(imageMaskInDouble>0);
            
            ErrorAngular = angularError(xC,yC,zC, xE,yE,zE);
            obj.angularNormalError{end+1} = mean(ErrorAngular);
            
            
        end
        
        
        
        % -- Function to calculate the first Error -- %
        % -- GT vs Raytraced Image >> Photometric Stereo -- % 
        function [obj] = calculateErrorForOrigin(obj)
        
            obj.get_Normal_Height_Albedo( obj.imageList );
            obj.calculateError();
        end
    
       
        function [obj ] = setFlipSurface(obj, IsValue)
               obj.IsflipSurface = IsValue;
            
        end
        
         
        function [obj]   = setMoveSurfaceTowardGround (obj, InValue)
            obj.IsMoveSurfaceTowardGround = InValue;
        end
        
     
        
    end
    
    
end