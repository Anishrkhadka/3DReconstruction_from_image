
function [OutFixedImage]=FixedImg( InImage )

ImageInGrayMode=rgb2gray( im2double(InImage) );
allTheBlackPixelInImage = find( ImageInGrayMode==0 );

% -- Extract RGB -- % 
imageWithRedChannel     = double(InImage(:,:,1))./255;
imageWithGreenChannel   = double(InImage(:,:,2))./255;
imageWithBlueChannel    = double(InImage(:,:,3))./255;

% -- remove black pixel -- % 
imageWithRedChannel  ( allTheBlackPixelInImage ) = NaN;
imageWithGreenChannel( allTheBlackPixelInImage ) = NaN;
imageWithBlueChannel ( allTheBlackPixelInImage ) = NaN;

% cd('inpaint_nans');
fixedImageWithOnlyRedChannel   = inpaint_nans(imageWithRedChannel,3);
fixedImageWithOnlyGreenChannel = inpaint_nans(imageWithGreenChannel,3);
fixedImageWithOnlyBlueChannel  = inpaint_nans(imageWithBlueChannel,3);
% cd ..
fixedImageWithOnlyRedChannel   = medfilt2(fixedImageWithOnlyRedChannel);
fixedImageWithOnlyGreenChannel = medfilt2(fixedImageWithOnlyGreenChannel);
fixedImageWithOnlyBlueChannel  = medfilt2(fixedImageWithOnlyBlueChannel);

OutFixedImage(:,:,1)=fixedImageWithOnlyRedChannel;
OutFixedImage(:,:,2)=fixedImageWithOnlyGreenChannel;
OutFixedImage(:,:,3)=fixedImageWithOnlyBlueChannel;
end

% dd1=(double(OI_1)./255)-z;
% figure;imshow(z);
% figure;imshow(double(OI_1)./255);
% figure;imshow(dd1);