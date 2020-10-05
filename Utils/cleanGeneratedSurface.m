function [OutMeshSurface] = cleanGeneratedSurface(InMeshSurface, IsVisualise)

% -- find the smallest Value in Mesh and use it to move mesh -- %
smallestValueInMesh = min( min(InMeshSurface) );
groundLevel         = 0;

if ( smallestValueInMesh <= groundLevel )
    InMeshSurface = InMeshSurface - smallestValueInMesh;
    
end




% -- remove any point below 0 -- % 
InMeshSurface(InMeshSurface < 0) = NaN;
% % -- scale the surface in Z direction (7) = scale value -- % 
% InMeshSurface = InMeshSurface;
% -- Part 1(B): Move the Mesh above the ground i.e +Z value -- %
% meshInSurfMode             = InMeshSurface;
[totalRows,totalColumns,~] = size(InMeshSurface);


% figure;surf(meshInSurfMode);
InMeshSurface = InMeshSurface * 7 ;
% -- recreate empty space as surface -- % 
InMeshSurface( isnan(InMeshSurface) ) = 0;

% -- Clean boarder -- % 
for i = 1:1
    InMeshSurface(:,i) = 0;
    InMeshSurface(:,65-i) = 0;
    InMeshSurface(i,:) = 0;
    InMeshSurface(65-i,:) = 0;
end

% -- end boarder -- % 

    if ( IsVisualise )
        [ NewMeshObj ] = surf2patch( InMeshSurface,'triangles' );
        visualise( NewMeshObj, [0.8 0.8 0.8],1,0 )
    end
    
    
OutMeshSurface = InMeshSurface;
end 