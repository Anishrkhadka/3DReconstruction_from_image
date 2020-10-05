function [output]  = clamp (x)
if (x<0)
    output = 0;
elseif (x>1)
    output = 1;
else
    output = x;
end
end
