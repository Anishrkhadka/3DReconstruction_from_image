% -- Mask -- %
addpath('../mat');
CAT = load('./PSData/cat/result.mat');
catSurf = CAT.Z;
[row,col,~] = size(catSurf);

% -- move the value above the zero -- %
minPoint = min(catSurf);
minPoint = min(minPoint);
if (minPoint <=0 )
    catSurf = catSurf - minPoint;
end


% - Reduce the number of face -- %
nextStep= max(row,col);
for i = 1:nextStep
    if (nextStep/i <=64)
        nextStep = i;
        break;
    end
end
catSurf1 = catSurf(1:nextStep:end, 1:nextStep:end);
[row, col,~] = size(catSurf1);
paddingNo = max(row,col)- min(row,col);
paddingNo = paddingNo/2;
if (row>col)
    catSurf1 =  padarray(catSurf1,[0, paddingNo],0);
else
    catSurf1 =  padarray(catSurf1,[paddingNo,0 ],0);
end
% -- Change Zero back to NaN -- % 
catSurf1(catSurf1==0) = NaN;

% -- Create a Mask -- %
mask = catSurf1;
mask(isnan(mask)) = 0;
mask = flipdim(mask ,1);           %# vertical flip

figure;imshow(mask);
figure;surf(catSurf1);

catMesh = catSurf1;
catMask = mask;
save('catMesh', 'catMesh');
save('catMask', 'catMask');




% I3 = flipdim(I ,1);           %# vertical flip
% I2 = flipdim(mask ,2);        %# horizontal flip
% I4 = flipdim(I3,2);    %# horizontal+vertical flip



