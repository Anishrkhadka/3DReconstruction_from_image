%COMP 256 Assignment 1
%Adrian Ilie



% savepfmraw.m 
% -----------
%
% function savepfmraw(filename,pic)
%
%
%  AUTHOR: Adrian Ilie
%    DATE: Sept 17, 2003
% PURPOSE:
%         Writes gray scale PFM (raw) images.
%
% ARGUMENTS: 
%         pic: The gray scale image in an array.
%         filename: A string containing the name of the image file to be saved.
%
  
function savepgmraw(filename,pic)



%% Open file.
%
 filename(findstr(filename,' '))=[];
 fid=fopen(filename,'w');
 imsize = size(pic);
 fprintf(fid,'PF\n%d %d\n%f\n',imsize(2),imsize(1),-1.0);
 pic2=pic';
 pic2 = [pic2(:) pic2(:) pic2(:)]';
 fwrite(fid,pic2,'float');
 
 fclose(fid);


%%%%

