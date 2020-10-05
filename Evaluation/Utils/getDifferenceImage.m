function [OutDifferenceImage_Ray] = getDifferenceImage(InImageList, InRayBounceImageList, InReduceIntensityOfImage )
OutDifferenceImage_Ray =[];

reduceIntensityOfImage=InReduceIntensityOfImage;

% -- Interpolation (first image )-- %
interpolatedImage          = fixImageWithInPaint_nans( InRayBounceImageList{1} );
renderedImage_1            = double( InImageList{1} )./255;
OutDifferenceImage_1       = renderedImage_1 - reduceIntensityOfImage.*interpolatedImage;
% -- Get Mean for Original Image & difference Image -- %
meanOfRenderedImage_1      = mean( renderedImage_1(:) );
meanOfDifferenceImage_1    = mean( OutDifferenceImage_1(:) );
OutDifferenceImage_1       = OutDifferenceImage_1 + ( meanOfRenderedImage_1 - meanOfDifferenceImage_1 );

% -- Interpolation - Second image -- %
interpolatedImage       = fixImageWithInPaint_nans( InRayBounceImageList{2} );
renderedImage_2         = double( InImageList{2} )./255;
OutDifferenceImage_2    = renderedImage_2 - reduceIntensityOfImage.*interpolatedImage;
meanOfRenderedImage_2   = mean( renderedImage_2(:) );
meanOfDifferenceImage_2 = mean( OutDifferenceImage_2(:) );
OutDifferenceImage_2    = OutDifferenceImage_2 +( meanOfRenderedImage_2 - meanOfDifferenceImage_2 );

% -- Interpolation - Third image -- %
interpolatedImage       = fixImageWithInPaint_nans(  InRayBounceImageList{3} );
renderedImage_3         = double( InImageList{3} )./255;
OutDifferenceImage_3    = renderedImage_3 - reduceIntensityOfImage.*interpolatedImage;
meanOfRenderedImage_3   = mean( renderedImage_3(:) );
meanOfDifferenceImage_3 = mean( OutDifferenceImage_3(:) );
OutDifferenceImage_3    = OutDifferenceImage_3 + ( meanOfRenderedImage_3-meanOfDifferenceImage_3 );

% -- Interpolation - Forth image -- %
interpolatedImage       = fixImageWithInPaint_nans(  InRayBounceImageList{4} );
renderedImage_4         = double( InImageList{4} )./255;
OutDifferenceImage_4    = renderedImage_4 - reduceIntensityOfImage.*interpolatedImage;
meanOfRenderedImage_4   = mean( renderedImage_4(:) );
meanOfDifferenceImage_4 = mean( OutDifferenceImage_4(:) );

OutDifferenceImage_4 = OutDifferenceImage_4 + ( meanOfRenderedImage_4-meanOfDifferenceImage_4 );

% -- [OUT Image x 4 with Different Lights ] -- %

OutDifferenceImage_Ray{end+1} = OutDifferenceImage_1.*255;
OutDifferenceImage_Ray{end+1} = OutDifferenceImage_2.*255;
OutDifferenceImage_Ray{end+1} = OutDifferenceImage_3.*255;
OutDifferenceImage_Ray{end+1} = OutDifferenceImage_4.*255;



end


function [OutFixedImage] = fixImageWithInPaint_nans( InImage )

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