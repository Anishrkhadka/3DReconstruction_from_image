% LoadObject function reads the obj file and creates the Model struct with
% list of triangles.
function [ OutTrianglesList ] = loadObj( InObjFilePath, InPosition, InScale )
% -- init --
OutTrianglesList = [];

fprintf('Loading %s \n',InObjFilePath);

%-- Read the obj files ---
Mesh3D              = read_wobj( InObjFilePath );

% Extract the face data
triFace         = Mesh3D.objects(4).data;
triNormalCoord  = Mesh3D.vertices_normal;

% --
triVertexIndex    = triFace.vertices;
triNormalIndex    = triFace.normal;

% -- Transform the Vertices --
[row,col] = size( Mesh3D.vertices);
triVerticesCoord = zeros(row,col);
for i = 1:row
    triVerticesCoord(i,:) = transform( [ Mesh3D.vertices(i,1),Mesh3D.vertices(i,2),Mesh3D.vertices(i,3),1],InPosition,InScale  );
end


[totalFace,~] = size( triVertexIndex );



% -- Load Mesh for Matlab formate --
forPlotSurface ( triVertexIndex,triVerticesCoord  );
% ---



fprintf('Total Triangles : %d\n', totalFace);
parfor_progress( totalFace );


% -- Get the list of 3 vertices of the triangle -- % 
vertex0 = [   triVerticesCoord( triVertexIndex(:,1), 1), ...
    triVerticesCoord( triVertexIndex(:,1), 2), ...
    triVerticesCoord( triVertexIndex(:,1), 3) ];

vertex1 = [   triVerticesCoord( triVertexIndex(:,2), 1), ...
    triVerticesCoord( triVertexIndex(:,2), 2), ...
    triVerticesCoord( triVertexIndex(:,2), 3) ];

vertex2 = [   triVerticesCoord( triVertexIndex(:,3), 1), ...
    triVerticesCoord( triVertexIndex(:,3), 2), ...
    triVerticesCoord( triVertexIndex(:,3), 3) ];

% -- Calculate the U & V from the vetices i.e edge of the triangles -- % 
u = vertex1(:,:) - vertex0(:,:) ;
v = vertex2(:,:) - vertex0(:,:) ;


parfor_progress( totalFace );

for i = 1:totalFace
    normal(i,:) = unit( crossP( u(i,:), v(i,:) ) );
    
    OutTrianglesList{end+1} = Triangle( vertex0(i,:),vertex1(i,:),vertex2(i,:), normal(i,:) );
    
    parfor_progress;
end
 parfor_progress(0);
 

end

function forPlotSurface ( InFaces, InVertices  )

load('box.mat');
% [x,~] = size( InMesh.vertices );
%
% % -- Tranform the vertex before adding to FV (face,vertices) -- %
% for i = 1:x
%     FV.vertices(i,:) = transform( [ InMesh.vertices(i,1),InMesh.vertices(i,2),InMesh.vertices(i,3),1], InPosition, InScale  );
% end
FV.vertices = InVertices;
FV.faces = InFaces;
% FV.faces = InMesh.objects.data.vertices;
box{end+1} = FV;

save('box.mat','box');

end
