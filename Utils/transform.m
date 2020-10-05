function [output] = transform ( vector,position,scale )

temp = [    scale(1)*vector(1)+ 0*vector(2) + 0*vector(3)+ position(1)*vector(4);
            0*vector(1)+ scale(2)*vector(2) + 0*vector(3)+ position(2)*vector(4);
            0*vector(1)+ 0*vector(2) + scale(3)*vector(3)+ position(3)*vector(4);
            0*vector(1)+ 0*vector(2) + 0*vector(3)       +  1         *vector(4);       ];
   
output = [temp(1,1), temp(2,1), temp(3,1)];

return
end