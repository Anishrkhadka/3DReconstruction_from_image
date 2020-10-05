function [output] = unit(x)
if (x == [0,0,0])
    output = x;
    return
end

output = x/norm(x);
end

