
function  hh=Integ_MultiLelelIntegration(Nx, Ny, Nz)

[height, width]=size(Nx);
p=zeros(height, width);
q=zeros(height, width);
for ii=1:height
    for jj=1:width
        if (Nz(ii,jj)~=0)
            p(ii,jj) = Nx(ii,jj)/Nz(ii,jj);%x/z
            q(ii,jj) = Ny(ii,jj)/Nz(ii,jj);%y/z
        end
    end
end

%cd mRC
cd MultiLelelIntegration
savepfmraw('1.pfm',p);
savepfmraw('2.pfm',-q);
!mg.bat >> t.txt


hh=getpfmraw('r.pfm');
hh=-hh;
delete 1.pfm 2.pfm r.pfm t.txt
%cd ..
%cd ..


