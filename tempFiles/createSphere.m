
function createSphere (InEnableVisual)

InImageSize = 64;

[x,y,z] = sphere(80); radius = 26;
x = x*radius; y = y*radius; z = z*radius;
z(z<0) = NaN;
x = x+InImageSize/2;
y = y+InImageSize/2;

a = surfnorm(x,y,z );
% heightmap = zeros(64,64);
% for i =3:81-2
%     for j= 3:81-2
%         heightmap( y(i,j),x(i,j) ) = (z(i-1,j-1)+z(i,j)+z(i+1,j+1))/3;
%     end
% end

% a= surf(x,y,z);
% imshow(a)




heightmap      = surf2patch(x,y,z, 'triangles');
% heightmap      = transf (heightmap,[InImageSize/2,InImageSize/2,0], [1,1,1] );
save('heightmap','heightmap') 
InEnableVisual= 1;
if (InEnableVisual)
        load('.././environmentTracer/box.mat');
        box{5} = heightmap;
            visual = Visualise(box, []); 
            visual.show();
    end

end 


function [OutTriStruct] = transf (InTriStruct,InPosition, InScale )

[row,~] = size( InTriStruct.vertices );

for i = 1:row
    InTriStruct.vertices(i,:) =  transform( [ InTriStruct.vertices(i,1), ...
                                              InTriStruct.vertices(i,2), ...
                                              InTriStruct.vertices(i,3), 1],...
                                              InPosition, InScale  ) ;
end

OutTriStruct = InTriStruct;
end
