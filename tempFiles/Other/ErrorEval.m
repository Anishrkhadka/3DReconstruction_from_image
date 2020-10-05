
OriImgPath = '../image/OriginalCat/Cat_';
OriImageList = cell(4,1);
for i = 1:4
    OriImg = strcat(OriImgPath,num2str(i),'.ppm');
    OriImageList{i,1} = imread(OriImg);
end
% -- ImageMask -- % 
ImageMask = imread('../image/OriginalCat/Cat_Mask_64.png');
ImageMask = ImageMask(:,:,1);

% -- Light -- %
% -- Import Light Direction -- %
% ============================ %

fprintf('Loading light dirction..\n');
% -- Read the files -- %
fileID 		= fopen('lights.txt', 'r');
lightSource = textscan(fileID, '%f %f %f', 'HeaderLines', 1, 'Delimiter', ' ');
fclose(fileID);

% -- Store the light direction -- %
LightList = [ lightSource{1} lightSource{2} lightSource{3} ];

% -- GT = Ground Truth
albedoGTMask( :,:,1 )=( double(ImageMask)./255 ) * 0.75;
albedoGTMask( :,:,2 )=( double(ImageMask)./255 ) * 0.75;
albedoGTMask( :,:,3 )=( double(ImageMask)./255 ) * 0.75;

% -- Import the image -- %
RayBounce = cell(3,4);
RayBounceImgPath = '../image/Cat_RayBounce_';
for i = 1:3
    for j = 1:4
        RayBounceImg = strcat(RayBounceImgPath,num2str(i),'_',num2str(j),'.ppm');
        RayBounce{i,j} = imread( RayBounceImg );
    end
end

% -- Used old photometric to get height -- % 
GTheights = load('../GTHeight_Cat.mat');
GTheights = GTheights.Z;

%Get error for the original images
% -- Get error also calculates Photometric Stereo -- %
[ errHMo, errAMo, errNMo, errRMo ] = GetError( OriImageList{1,1},OriImageList{2,1},...
                                                OriImageList{3,1},OriImageList{4,1}, ...
    LightList, ImageMask, GTheights, albedoGTMask );

%Get error for Ray bounce 1
aa = 0.2;
[ difImg1, difImg2, difImg3, difImg4] = GetDiffImg( RayBounce{1,1}, RayBounce{1,2}, RayBounce{1,3}, RayBounce{1,4},...
   OriImageList{1,1},OriImageList{2,1},...
   OriImageList{3,1},OriImageList{4,1},aa );

[ errHMr1, errAMr1, errNMr1, errRMr1] = GetError( difImg1, difImg2, difImg3, difImg4,...
    LightList,ImageMask,GTheights,albedoGTMask );

%Get error for Ray bounce 2
aa=0.2;
[ddB1, ddB2, ddB3, ddB4]=GetDiffImg(RayBounce{2,1}, RayBounce{2,2}, RayBounce{2,3}, RayBounce{2,4},...
                                      OriImageList{1,1},OriImageList{2,1},...
   OriImageList{3,1},OriImageList{4,1},aa);

[errHMr2, errAMr2, errNMr2, errRMr2]=GetError(ddB1, ddB2, ddB3, ddB4,LightList,ImageMask,GTheights,albedoGTMask);

%Get error for Ray bounce 3
aa=0.2;
[ddC1, ddC2, ddC3, ddC4]=GetDiffImg( RayBounce{3,1}, RayBounce{3,2}, RayBounce{3,3}, RayBounce{3,4}, ...
                                        OriImageList{1,1},OriImageList{2,1},...
                                        OriImageList{3,1},OriImageList{4,1},aa );

[errHMr3, errAMr3, errNMr3, errRMr3] = GetError( ddC1, ddC2, ddC3, ddC4,LightList,ImageMask,GTheights,albedoGTMask );

Herr=[errHMo errHMr1 errHMr2 errHMr3];
Aerr=[errAMo errAMr1 errAMr2 errAMr3];
Nerr=[errNMo errNMr1 errNMr2 errNMr3];
Rerr=[errRMo errRMr1 errRMr2 errRMr3];



%rr=Rerr.*180.0./pi

