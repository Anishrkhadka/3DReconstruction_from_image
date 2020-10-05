function [ OutLightList ] = loadLightDirection( InPathToLightDirectionFile )

    fprintf('Loading light dirction..\n');
    % -- Read the files -- %
    fileID 		= fopen(InPathToLightDirectionFile, 'r');
        lightSource = textscan(fileID, '%f %f %f', 'HeaderLines', 1, 'Delimiter', ' ');
    fclose(fileID);

    % -- Store the light direction -- %
    OutLightList = [ lightSource{1} lightSource{2} lightSource{3} ];

end