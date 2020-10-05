
function [OutHeight, OutNormal, OutAlbeo]=GetPSEstim( InImg1,InImg2,InImg3,InImg4,InLightList,cc,hhm )

% ---------------------- Step 1 ---------------------- 
% Read the 4 input grayscale images, scale them to 0-1
% and place them in an MxNx4 matrix where MxN is the 
% image size
% cc=1;
% stp=1;
% hhm=74;
% -- Calculate for each channel ( CC =  1,2,3) -- % 
II1=InImg1(:,:,cc);
II2=InImg2(:,:,cc);
II3=InImg3(:,:,cc);
II4=InImg4(:,:,cc);

ImagesList(:,:,1)=double(II1)./255;
ImagesList(:,:,2)=double(II2)./255;
ImagesList(:,:,3)=double(II3)./255;
ImagesList(:,:,4)=double(II4)./255;


% ---------------------- Step 2 ---------------------- 
% Load the 4x3 matrix with the light directions
Lights=InLightList;  
    
    
% ---------------------- Step 3 ---------------------- 
% Calculate the surface normals Nx, Ny, Nz and the 
% albedo assuming a Lambertian model I = k N.L
% The size of the normals Nx, Ny, Nz and the albedo is
% equal to the size of the input images MxN

LL=( inv( Lights'* Lights ) )* Lights';
        
[height, width, ~] = size(ImagesList);

albedo         = zeros(height, width );
OutNormal      = zeros(height, width,3);

for ii=1:height
    for jj=1:width
        
        intensity = ImagesList(ii,jj,:);
        intensity = intensity(:);
        normal    = LL*intensity;  
        
        surfaceMat = norm( normal );
        albedo(ii,jj)=surfaceMat;
        
        if ( surfaceMat ~= 0 )
            OutNormal(ii,jj,:)=normal./surfaceMat;
        end
    end
end
Nx=OutNormal(:,:,1);
Ny=OutNormal(:,:,2);
Nz=OutNormal(:,:,3);  
    
% ---------------------- Step 4 ---------------------- 
% Integration
% PartA: Calculate p=-dx/dz and q=-dy/dz
% p      = -Nx./Nz;
% q      = -Ny./Nz;
% imsize = size(p);
% r      = zeros( imsize );
% p( isnan( p ) ) = 0;
% q( isnan( q ) ) = 0;

% for i=2:imsize(1)
%     r(i,1)=r(i-1,1)+q(i,1);
% end
% 
% for i=2:imsize(1)
%     for j=2:imsize(2)
%         r(i,j)=r(i,j-1)+p(i,j);
%     end
% end
% 
% % ---------------------- Step 5 ---------------------- 
% % Visualise the integrated surface
% figure;surf(r(1:stp:end,1:stp:end));
% figure;imshow(r,[]);
% plooot(r(1:stp:end,1:stp:end),[],0.5,0.5)

% ---------------------- Step 6 ---------------------- 
% An advanced integration method
disp('PS Method: MultiLelelIntegration');
% cd './MultiLelelIntegration'
hh = Integ_MultiLelelIntegration(Nx, Ny, Nz);
% cd ..

% ---------------------- Step 7 ---------------------- 
% Visualise the new integrated surface
% figure;surf(hh(1:stp:end,1:stp:end));  
% plooot(hhm*hhm*hh,[],0.5,0.5)
OutHeight= hhm * hhm * hh;
OutAlbeo = albedo./2 ;
% ---------------------- Step 8 ---------------------- 
% Save to .obj file
% [nx ny nz]=surfnorm(hh);
% [u,v]=meshgrid(1:4:width,1:4:height);
% x=u; y=v; z=hh(1:4:end,1:4:end);
% saveobjmesh('alexFace.obj',x,y,576*720*z,nx(1:4:end,1:4:end), ny(1:4:end,1:4:end), nz(1:4:end,1:4:end))

