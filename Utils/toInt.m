function [output] = toInt(x)
output = floor( clamp(x) ^ (1.0/2.2) * 255 + 0.5 ) ;
end