% -- Load external Mat file -- %
function [ OutList ] = convertAndCreateListOfExternalData ( InIsVisualise )
fprintf('\n Converting and Creating List Of ExternalData');
% -- Load the external data -- %
externalData = loadExternalData();
OutList      = cell(externalData.totalNoOfData, 1);


% -- Part 1: Get the down sample value for Mesh -- %
% -- variable multipler for converting the different resolution mesh to
% -- 64x64

parfor_progress( externalData.totalNoOfData );
for index = 1:externalData.totalNoOfData
    meshIndex = index;
    convertMeshToResolution = 64;
    
    % -- Part 1(A): get upsample and downsample --
    multiplyer              = externalData.meshExpandValue{ meshIndex,1 };
    valueToUpSampleMesh     = convertMeshToResolution * multiplyer;
    valueToDownsampleMesh   = valueToUpSampleMesh / convertMeshToResolution;
    
    
    % -- Part 1(B): Move the Mesh above the ground i.e +Z value -- %
    meshInSurfMode             = externalData.meshInSurfModeList{meshIndex,1};
    [totalRows,totalColumns,~] = size(meshInSurfMode);
    
    % -- find the smallest Value in Mesh and use it to move mesh -- %
    smallestValueInMesh = min( min(meshInSurfMode) );
    groundLevel         = 0;
    
    if ( smallestValueInMesh <= groundLevel )
        meshInSurfMode = meshInSurfMode - smallestValueInMesh;
   
    end
    
    
    % -- Part 2 : Expand the Mesh and make it square  -- %
    RowsDifference        = valueToUpSampleMesh - totalRows;
    paddingValueForRows   = RowsDifference/2;
    
    ColumnsDifference     = valueToUpSampleMesh - totalColumns;
    paddingValueInColumns = ColumnsDifference/2;
    
    % -- Add zeros to expand the mesh -- %
    meshInSurfMode = padarray( meshInSurfMode,[paddingValueForRows,0 ]   );
    meshInSurfMode = padarray( meshInSurfMode,[0, paddingValueInColumns] );
    
    % -- Part 3: down sample Mesh to 64 x 64 -- %
    meshInSurfModeDownsampled  = meshInSurfMode( 1:valueToDownsampleMesh:end, 1:valueToDownsampleMesh:end );
    meshInSurfModeDownsampled  = meshInSurfModeDownsampled/valueToDownsampleMesh;
    
    
    % -- Convert 0  to space -- %
    meshInSurfModeDownsampled( meshInSurfModeDownsampled == 0 ) = NaN;
    
    % -- Create a Mask -- %
    mask = meshInSurfModeDownsampled;
    mask( isnan(mask) ) = 0;
    mask = flipdim(mask ,1);  %# vertical flip

    

    meshInTriangleModeDownsampled = surf2patch(meshInSurfModeDownsampled,'triangles');
    meshInTriangleModeDownsampled.vertices(isnan(meshInTriangleModeDownsampled.vertices) ) = 0;
    

    
    object.name = externalData.nameList{index,1};
    object.mesh = meshInTriangleModeDownsampled;
    object.mask = mask;
    object.meshInSurfaceMode = meshInSurfModeDownsampled;
    
    
    OutList{index,1} = object;
    
    visual = Visualise([],[]);
    
    if( InIsVisualise )
        visual.appendMesh(meshInTriangleModeDownsampled);
        visual.appendImage(mask)
        visual.show();
    end
    parfor_progress;
end
parfor_progress(0);

end

