
function [OutDifImg1, OutDifImg2, OutDifImg3, OutDifImg4] = GetDiffImg( InRayBounceImg1,InRayBounceImg2,InRayBounceImg3,InRayBounceImg4,...
                                                              InOriImage1,InOriImage2,InOriImage3,InOriImage4,aa)

% aa?? 
%aa=0.2;

% -- Interpolation (first image )-- % 
mfixedImage = FixedImg( InRayBounceImg1 );

It          = double( InOriImage1 )./255;
OutDifImg1  = It - aa.*mfixedImage;
% -- Get Mean for Original Image & difference Image -- % 
mmt         = mean( It(:) );
mmd         = mean( OutDifImg1(:) );

OutDifImg1  = OutDifImg1 + ( mmt - mmd );

% -- Interpolation - Second image -- %  
mfixedImage = FixedImg( InRayBounceImg2 );
It          = double( InOriImage2 )./255;
OutDifImg2  = It - aa.*mfixedImage;

mmt         = mean( It(:) );
mmd         = mean( OutDifImg2(:) );

OutDifImg2  = OutDifImg2 +( mmt - mmd );

mfixedImage = FixedImg( InRayBounceImg3 );
It          = double( InOriImage3 )./255;
OutDifImg3  = It - aa.*mfixedImage;
mmt         = mean( It(:) );
mmd         = mean( OutDifImg3(:) );
OutDifImg3  = OutDifImg3 + ( mmt-mmd );

mfixedImage = FixedImg( InRayBounceImg4 );
It          = double( InOriImage4 )./255;
OutDifImg4  = It - aa.*mfixedImage;

mmt         = mean( It(:) );
mmd         = mean( OutDifImg4(:) );

OutDifImg4 = OutDifImg4 + ( mmt-mmd );

OutDifImg1  = OutDifImg1.*255;
OutDifImg2  = OutDifImg2.*255;
OutDifImg3  = OutDifImg3.*255;
OutDifImg4  = OutDifImg4.*255;

% figure;imshow(ddA);
% figure;imshow(It);
% figure;imshow(z);
