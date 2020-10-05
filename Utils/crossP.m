function [output] = crossP(a,b)
ax = a(1);
ay = a(2);
az = a(3);
bx = b(1);
by = b(2);
bz = b(3);


output = [  ay*bz - az*by,...
    az*bx - ax*bz, ...
    ax*by - ay*bx ];
return
end