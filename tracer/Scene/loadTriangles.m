function [OutTrianglesList ] = loadTriangles( InTriMesh, InPosition, InScale )
% -- init --
OutTrianglesList = [];

% fprintf('Loading reconstructed surface.. \n');

triVertexIndex    = InTriMesh.faces;
triVerticesCoord  = InTriMesh.vertices;

% -- Get total face --
[totalFace,~] = size( triVertexIndex );

% -- This creates the back plane mesh -- %
% triVerticesCoord( isnan( triVerticesCoord ) ) = -15;

% -- Transform the Vertices --
[row,~] = size( triVerticesCoord );

for i = 1:row
    triVerticesCoord(i,:) = transform( [ triVerticesCoord(i,1),...
        triVerticesCoord(i,2),...
        triVerticesCoord(i,3), 1],InPosition, InScale  );
end


% -- Load Mesh for Matlab formate --
forPlotSurface ( triVerticesCoord, triVertexIndex );


% fprintf('Total Triangles : %d\n', totalFace);

noProgressBar= false;
if (totalFace <= 2)
    noProgressBar = true;
end

if( ~noProgressBar )
    parfor_progress( totalFace );
end
for i = 1:1:totalFace
    
    vertex0= [  triVerticesCoord( triVertexIndex(i,1),1 ),...
        triVerticesCoord( triVertexIndex(i,1),2 ),...
        triVerticesCoord( triVertexIndex(i,1),3 ) ];
    vertex1= [  triVerticesCoord(triVertexIndex(i,2),1),...
        triVerticesCoord(triVertexIndex(i,2),2 ),...
        triVerticesCoord(triVertexIndex(i,2),3) ];
    vertex2= [  triVerticesCoord(triVertexIndex(i,3),1),...
        triVerticesCoord(triVertexIndex(i,3),2),...
        triVerticesCoord(triVertexIndex(i,3),3) ];
    
    u       = vertex1 - vertex0;
    v       = vertex2 - vertex0;
    normal  = unit( crossP(u,v) );
    
    OutTrianglesList{end+1} = Triangle( vertex0,vertex1,vertex2, normal );
    
    if( ~noProgressBar )
        parfor_progress;
    end
end
if( ~noProgressBar )
    parfor_progress(0);
end
end


% -- for Mesh visualisation -- % ( plotMesh function )
function forPlotSurface ( InVertex,InFace )

load('./box.mat');
% [x,~] = size( InMesh.vertices);
% for i = 1:x
%     FV.vertices(i,:) = transform( [ InMesh.vertices(i,1),InMesh.vertices(i,2),InMesh.vertices(i,3),1],InPosition,InScale  );
% end

% FV.vertices(:,:) = [InVertex(:,1),InVertex(:,2),InVertex(:,3) ];

FV.vertices = InVertex;
FV.faces = InFace;
box{end+1} = FV;
save('./box.mat','box');


end
