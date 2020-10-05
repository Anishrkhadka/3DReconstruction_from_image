function [rr] = angularError(xC,yC,zC, xE,yE,zE)
	%double aa, bb, axR, ayR, a1, bxE, byE, b1, zz1, azz1;

	aa  = 1.0./sqrt( 1.0+xC.*xC+yC.*yC+zC.*zC );
	bb  = 1.0./sqrt( 1.0+xE.*xE+yE.*yE+zE.*zE );

	axC = aa.*xC;
	ayC = aa.*yC;
    azC = aa.*zC;
	a1  = aa.*1.0;

	bxE = bb.*xE;
	byE = bb.*yE;
    bzE = bb.*zE;
	b1  = bb.*1.0;

    zz1 = axC.*bxE+ayC.*byE+azC.*bzE+a1.*b1;     
	rr  = acos(zz1);
end