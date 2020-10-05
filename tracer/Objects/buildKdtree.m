function [OutNode] = buildKdtree( triangleList, depth)
        
        
        
OutNode             = KDNode;
OutNode.leaf        = false;
OutNode.leftNode    = KDNode;
OutNode.rightNode   = KDNode;
OutNode.aabox       = AABBox ([0,0,0], [0,0,0]);

[ ~, noOfTriangles ]= size(triangleList);


if(noOfTriangles == 0)
    fprintf('No Triangle found!');
    return
end

if ( depth > 20 || noOfTriangles <=20 )
    OutNode.leaf 			= true;
    OutNode.trianglesList 	= triangleList;
    OutNode.aabox 			= triangleList{1}.getBoundingBox;
    

   for i = 2:1:noOfTriangles
        OutNode.aabox = OutNode.aabox.expand( triangleList{i}.getBoundingBox );     
    end
    
    OutNode.leftNode  = KDNode;
    OutNode.rightNode = KDNode;
    OutNode.leftNode.trianglesList = [];
    OutNode.rightNode.trianglesList = [];
    
    return
end

midpt     = [0,0,0];
triRecp   = 1/noOfTriangles;

OutNode.aabox    = triangleList{1}.getBoundingBox;

for i = 2:1:noOfTriangles
    OutNode.aabox = OutNode.aabox.expand( triangleList{i}.getBoundingBox );
    midpt     = midpt + ( triangleList{i}.getMidPoint * triRecp );
    
end

%
leftTris =[];
rightTris =[];

axis = OutNode.aabox.getLongestAxis;


for i = 1:1:noOfTriangles
    mpoint = triangleList{i}.getMidPoint;
    
    switch axis
        case 0
            if (midpt(1) >=  mpoint(1) )
                % push back the triangleList;
                rightTris{end+1} = triangleList{i} ;
            else
                leftTris{end+1}  = triangleList{i};
            end
            
            
        case 1
            if (midpt(2) >= mpoint(2) )
                % push back the triangleList;
                rightTris{end+1} = triangleList{i} ;
            else
                leftTris{end+1} = triangleList{i};
            end
            
            
        case 2
            if (midpt(3) >= mpoint(3)  )
                % push back the triangleList;
                rightTris{end+1} = triangleList{i} ;
            else
                leftTris{end+1} = triangleList{i};
            end
            
    end
    
end


[~, leftTriSize] = size(leftTris);
% leftTriSize = leftTriSize(1,2);

[~,rightTriSize ] = size(rightTris);
% rightTriSize = rightTriSize(1,2);

if ( noOfTriangles == leftTriSize || noOfTriangles == rightTriSize )
    OutNode.leaf                 = true;
    OutNode.trianglesList         = triangleList;
    OutNode.aabox                  = triangleList{1}.getBoundingBox;
    
    
    for i = 2:1:noOfTriangles
       OutNode.aabox =  OutNode.aabox.expand( triangleList{i}.getBoundingBox );
    end
    
    OutNode.leftNode                  = KDNode;
    OutNode.rightNode                 = KDNode;
    
    OutNode.leftNode.trianglesList       = [];
    OutNode.rightNode.trianglesList      = [];
    
    return
end

OutNode.leftNode                      = buildKdtree(leftTris,  depth + 1);
OutNode.rightNode                     = buildKdtree(rightTris, depth + 1);

return

end