function [OutGroundTruthHeightList] = getAllGroundTruthHeight(InImageMask)
OutGroundTruthHeightList = [];

IsVisualise = false;
[ externalData ] = convertAndCreateListOfExternalData( IsVisualise );

sphereIndex     = 1;
catIndex        = 2;
FemaleHeadIndex = 3;

% OutGroundTruthHeightList{sphereIndex} = cleanSurfaceWithMask(externalData{sphereIndex}.meshInSurfaceMode,InImageMask.list{sphereIndex}) ;

OutGroundTruthHeightList{sphereIndex} =  externalData{sphereIndex}.meshInSurfaceMode;
% OutGroundTruthHeightList{sphereIndex}     = moveSurfaceTowardGround(externalData{sphereIndex}.meshInSurfaceMode);

OutGroundTruthHeightList{catIndex}        = externalData{catIndex}.meshInSurfaceMode;

OutGroundTruthHeightList{FemaleHeadIndex} = cleanSurfaceWithMask( externalData{FemaleHeadIndex}.meshInSurfaceMode,InImageMask.list{FemaleHeadIndex} );
OutGroundTruthHeightList{FemaleHeadIndex} = moveSurfaceTowardGround(OutGroundTruthHeightList{FemaleHeadIndex});

end
function [OutMesh] = cleanSurfaceWithMask(InMeshSurface, InImageMask)

    InMeshSurface(InImageMask<=0) = NaN;
    OutMesh = InMeshSurface;

end

function [OutMesh] = moveSurfaceTowardGround(InMeshSurface)
    smallestValueInMesh = min( min(InMeshSurface) );
    InMeshSurface = InMeshSurface - smallestValueInMesh;
%     InMeshSurface( isnan(InMeshSurface) ) = 0;

    OutMesh = InMeshSurface;
end

