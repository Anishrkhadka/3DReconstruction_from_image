% clear all;
% close all;
% clc;

load('AnishAll3.mat');
ImageMask = imread('mask.png');
ImageMask = ImageMask(:,:,1);

% -- Light -- % 
LightList = LL;

albedoGroundTruthMask( :,:,1 ) = ( double(ImageMask)./255 ) * 0.75;
albedoGroundTruthMask( :,:,2 ) = ( double(ImageMask)./255 ) * 0.75;
albedoGroundTruthMask( :,:,3 ) = ( double(ImageMask)./255 ) * 0.75;

% -- Get error for the original images
% -- Get error also calculates Photometric Stereo -- % 
[ errHMo, errAMo, errNMo, errRMo ] = GetError( OriImage1,OriImage2,OriImage3,OriImage4, ...
                                               LightList, ImageMask, heights, albedoGroundTruthMask );

% -- Get error for Ray bounce 1 --%
RayBounce1 = EnvironmentImageList{3};


aa = 0.2;
[ difImg1, difImg2, difImg3, difImg4] = GetDiffImg( RayBounce1_1,RayBounce1_2,RayBounce1_3,RayBounce1_4,...
                                                    OriImage1,OriImage2,OriImage3,OriImage4,aa );

[ errHMr1, errAMr1, errNMr1, errRMr1] = GetError( difImg1, difImg2, difImg3, difImg4,...
                                                  LightList,ImageMask,heights,albedoGroundTruthMask );

% -- Get error for Ray bounce 2 -- % 
aa = 0.2;
[ddB1, ddB2, ddB3, ddB4]=GetDiffImg(RayBounce2_1, RayBounce2_2, RayBounce2_3, RayBounce2_4,...
                                    OriImage1,    OriImage2,    OriImage3,    OriImage4,aa);
                                
[errHMr2, errAMr2, errNMr2, errRMr2]=GetError(ddB1, ddB2, ddB3, ddB4,LightList,ImageMask,heights,albedoGroundTruthMask);

% -- Get error for Ray bounce 3 --%
aa = 0.2;
[ddC1, ddC2, ddC3, ddC4] = GetDiffImg( RayBounce3_1,RayBounce3_2,RayBounce3_3,RayBounce3_4, ...
                                       OriImage1,   OriImage2,   OriImage3,   OriImage4, aa );
                                 
[errHMr3, errAMr3, errNMr3, errRMr3] = GetError( ddC1, ddC2, ddC3, ddC4, LightList,ImageMask,heights,albedoGroundTruthMask );

Herr=[errHMo errHMr1 errHMr2 errHMr3];
Aerr=[errAMo errAMr1 errAMr2 errAMr3];
Nerr=[errNMo errNMr1 errNMr2 errNMr3];
Rerr=[errRMo errRMr1 errRMr2 errRMr3];


%rr=Rerr.*180.0./pi

