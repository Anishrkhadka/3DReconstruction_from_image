function savePPM( InFileName, InImageMatrix, InImageType, InWidth, InHeight, InIsBoxSize )

FinalImageMatrix = cell(64,64);

if( InIsBoxSize )
    [row,~]   = size(InImageMatrix);
    [~,col ]  = size(InImageMatrix{1,1});
    
    for heightIndex = 1:row
        for widthIndex = 1:col

            pixelYPosition = InImageMatrix{heightIndex,1}{1,widthIndex}(4);
            pixelXPosition = InImageMatrix{heightIndex,1}{1,widthIndex}(5);
            
            r = InImageMatrix{heightIndex,1}{1,widthIndex}(1);
            g = InImageMatrix{heightIndex,1}{1,widthIndex}(2);
            b = InImageMatrix{heightIndex,1}{1,widthIndex}(3);
            
            FinalImageMatrix{ pixelYPosition, pixelXPosition } = [r,g,b];


        end
    end

%  Write Colour in ppm fileformate
outputFormat        = strcat(InImageType,'\n%d %d\n%d\n');
imageFileID         = fopen(InFileName, 'w');
fprintf(imageFileID, outputFormat, InWidth, InHeight, 255);


    for y =InHeight:-1:1
        for x =1:InWidth
            fprintf(imageFileID,'%1u %1u %1u ',...
                toInt( FinalImageMatrix{y,x}(1) ),... %r
                toInt( FinalImageMatrix{y,x}(2) ),... %g
                toInt( FinalImageMatrix{y,x}(3) ) );   %b
        end
    end

else

    outputFormat        = strcat(InImageType,'\n%d %d\n%d\n');
    imageFileID         = fopen(InFileName, 'w');

    fprintf(imageFileID, outputFormat, InWidth, InHeight, 255);

    for i =1:( InWidth * InHeight )

        fprintf(imageFileID,'%1u %1u %1u ',...
            toInt(InImageMatrix{i}(1)),... %r
            toInt(InImageMatrix{i}(2)),... %g
            toInt(InImageMatrix{i}(3)));   %b

    end

end


fclose(imageFileID);


end

function [output] = toInt(x)
output = floor( clamp(x) ^ (1/2.2) * 255 + 0.5 ) ;
end


