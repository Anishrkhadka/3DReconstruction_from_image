
function  [ OutHeight ] = Integ_MultiLelelIntegration(InNormalX, InNormalY, InNormalZ)

[height, width] = size( InNormalX );

p = zeros(height, width);
q = zeros(height, width);

for i=1:height
    for j=1:width
        if ( InNormalZ(i,j) ~= 0 )
            p(i,j) = InNormalX(i,j) / InNormalZ(i,j);%x/z
            q(i,j) = InNormalY(i,j) / InNormalZ(i,j);%y/z
        end
    end
end

% -- Need to go to folder to run mg.exe file -- % 


    savepfmraw('1.pfm', p);
    savepfmraw('2.pfm',-q);

    % !mg.bat >> t.txt

    % -- Only for MACOS -- adding system path % 
    path1 = getenv('PATH');
    path1 = [path1 ':/usr/local/bin'];
    setenv('PATH', path1);
    
    % -- Run Command using WINE-- % 
    !wine mg.exe 1.pfm 2.pfm >> t.txt
    % --- End -- % 



    OutHeight = getpfmraw('r.pfm');
    OutHeight = -OutHeight;
    delete 1.pfm 2.pfm r.pfm t.txt



end


