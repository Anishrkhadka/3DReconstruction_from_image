v= Visualise([],[]);
% sp = surf2patch(femaleHead.storeHeight{3}*4,'triangles');
v.appendMesh(box{1})
v.appendMesh(box{2})
v.appendMesh(box{3})
v.appendMesh(box{4})
v.appendMesh(box{5})
% v.appendMesh(box{6})
% v.appendMesh(sp);


v.appendColour([0.75,0.25,0.25])
v.appendColour([0.25,0.25,0.75])
v.appendColour([0.75,0.75,0.75])
v.appendColour([0.75,0.75,0.75])
v.appendColour([0.75,0.75,0.75])
v.appendColour([0.75,0.75,0.75])
v.show();