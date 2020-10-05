function [ OutHeight ] = calculateHeightForEachChannel (InNormalForEachChannel, InMultiPlier)
heightList = cell(1,3);

disp('PS Method: MultiLelelIntegration');
cd './Utils/MultiLelelIntegration/'
for channelIndex = 1:3
    tempNormalX = InNormalForEachChannel{channelIndex}(:,:,1);
    tempNormalY = InNormalForEachChannel{channelIndex}(:,:,2);
    tempNormalZ = InNormalForEachChannel{channelIndex}(:,:,3);
    
    tempHeight        = Integ_MultiLelelIntegration(tempNormalX, tempNormalY, tempNormalZ);
    
    heightList{channelIndex} = InMultiPlier * InMultiPlier * tempHeight;
    
end

cd ../../

OutHeight = ( heightList{1}  + heightList{2}  + heightList{3}  )./3;

end