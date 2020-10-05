%Adrian Ilie

% getpfmraw.m 
% -----------
%
% function  pic=getpfmraw(filename)
%
% PURPOSE:
%         Reads gray scale PFM (raw) images.
%
% ARGUMENTS: 
%         filename: A string containing the name of the image file to be read.
%
% RETURNS:
%         pic: The gray scale image in an array.
  
function [ pic ] = getpfmraw( filename )

%% Open file.
 filename( strfind (filename,' ') ) = [];
 fid = fopen(filename);


%% If not PGM then exit with an error message

 code = fscanf( fid,'%s',1 );
 
 % -- Compare two string -- %
 if ( strcmp(code,'P7') )
     error('Not a PFM (raw) image');
 end
 
%  if (code ~= 'P7')
% 	error('Not a PFM (raw) image');
%  end


%% Get width.
%
 width = [];
 while ( isempty(width) )
   [ width, cnt ] = fscanf( fid,'%d',1 );
   if (cnt==0)
     fgetl(fid);
   end
 end

%% Get height.
%
 height = fscanf(fid,'%d',1);

%% Get max gray value.
 maxgray = fscanf(fid,'%f',1);


%% Read actual data.
%
 cnt = fread(fid,1);		
 pic = fread(fid,'float')';

 pic = reshape( pic, 3, width * height  ); %has values repeated 3 times
 pic = reshape( pic(1,:),width,height )'; %first line, reshaped


%% Close file.
%
 fclose(fid);



