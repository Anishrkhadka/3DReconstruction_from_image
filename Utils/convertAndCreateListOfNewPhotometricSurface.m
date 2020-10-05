% -- Load external Mat file -- %
function [ OutList ] = convertAndCreateListOfNewPhotometricSurface ( InIsVisualise )
fprintf('\n Converting and Creating List Of Internal Data (new photometric surface )\n');
% -- Load the external data -- %
InternalData = loadAllNewGeneratedSurfaceFromPhotometric();
OutList      = cell(InternalData.totalNoOfData, 1);



for index = 1:InternalData.totalNoOfData
    
    
    meshInTriangleMode = surf2patch(InternalData.meshInSurfModeList{index},'triangles');
    
    
    object.name = InternalData.nameList{index,1};
    object.mesh = meshInTriangleMode;
    object.meshInSurfaceMode = InternalData.meshInSurfModeList{index};
    
    
    OutList{index,1} = object;
    
    visual = Visualise([],[]);
    
    if( InIsVisualise )
        visual.appendMesh(meshInTriangleMode);
        visual.show();
    end

end

end

