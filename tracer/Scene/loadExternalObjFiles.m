
function [OutList] = loadExternalObjFiles()
OutList      = cell(1, 1);

index = 1;



object.name = 'Sphere';
object.meshIndex = 1;
object.mesh = loadObj('../ExternalData/objFile/sphereMesh.obj', [64/2,64/2,0], [4,4,4]);

OutList{index,1} = object;

end
