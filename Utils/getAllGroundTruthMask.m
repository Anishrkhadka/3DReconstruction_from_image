function [OutList] =  getAllGroundTruthMask (InImageMaskList)
[~, totalImageMask]           = size(InImageMaskList.list);

OutList.list            = cell(1,totalImageMask);
OutList.maskName          = InImageMaskList.names;

WhiteColourInScene        = 0.75;



for imageMaskIndex = 1:totalImageMask
    
    albedoGroundTruthMask( :,:,1 ) = ( double(InImageMaskList.list {imageMaskIndex} )./255 ) * WhiteColourInScene;
    albedoGroundTruthMask( :,:,2 ) = ( double(InImageMaskList.list {imageMaskIndex} )./255 ) * WhiteColourInScene;
    albedoGroundTruthMask( :,:,3 ) = ( double(InImageMaskList.list {imageMaskIndex} )./255 ) * WhiteColourInScene;
    
    OutList.list{imageMaskIndex} = albedoGroundTruthMask;
end

end