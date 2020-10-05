function  getAllSurfaceWithLowestHeightErrorAndSave
% -- Enter the folder -- % 
cd Evaluation
% -- run the main progjram -- % 
Main

minError = inf;
IndexOfLowestHeightErrorForSphere      = 0;
IndexOfLowestHeightErrorForCat         = 0;
IndexOfLowestHeightErrorForFemaleHead  = 0;

for i = 1:4
    minHeightErrorSphere = sphereError.heightError{i};
    minHeightErrorCat    = cat.heightError{i};
    minHeightErrorHeight = femaleHead.heightError{i};
    
    if (minHeightErrorSphere< minError)
        minError = minHeightErrorSphere;
        IndexOfLowestHeightErrorForSphere= i;
    end
    
    if (minHeightErrorCat< minError)
        minError = minHeightErrorCat;
        IndexOfLowestHeightErrorForCat= i;
    end
    
    if (minHeightErrorHeight< minError)
        minError = minHeightErrorHeight;
        IndexOfLowestHeightErrorForFemaleHead= i;
    end
    
    
end


sphereSurface     = sphereError.storeHeight{IndexOfLowestHeightErrorForSphere};
catSurface        = sphereError.storeHeight{IndexOfLowestHeightErrorForCat};
femaleHeadSurface = sphereError.storeHeight{IndexOfLowestHeightErrorForFemaleHead};

% -- Save new surface -- % 
save('../InternalData/photometricSphere.mat'    ,'sphereSurface');
save('../InternalData/photometricCat.mat'       ,'catSurface' );
save('../InternalData/photometricFemaleHead.mat','femaleHeadSurface');

cd ..
end