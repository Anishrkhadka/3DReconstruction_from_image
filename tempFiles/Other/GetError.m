
function [errHM, errAM, errNormal, errRM]=GetError( InImage1,InImage2,InImage3,InImage4,...
                                                InlightList,InImageMask,Inheights,InAlbedoMask )

% -- What is hhm?? -- % 
hhm = 74;

[heightR, normalR, albedoR] = GetPSEstim( InImage1,InImage2,InImage3,InImage4,InlightList,1,hhm );
[heightG, normalG, albedoG] = GetPSEstim( InImage1,InImage2,InImage3,InImage4,InlightList,2,hhm );
[heightB, normalB, albedoB] = GetPSEstim( InImage1,InImage2,InImage3,InImage4,InlightList,3,hhm );

hhE  = ( heightR  + heightG  + heightB  )./3;

% albE = ( albE1 + albE2 + albE3 )./3;
% -- Modified to MxNx3 -- %
albedo(:,:,1) = albedoR;
albedo(:,:,2) = albedoG;
albedo(:,:,3) = albedoB;


normalFromPhotometric       = ( normalR + normalG + normalB )./3;
imageMaskInDouble           = double( InImageMask )./255;
%figure;surf(heights);

[Nx,Ny,Nz]  = surfnorm( Inheights );
normalFromGroundTruth(:,:,1) = Nx;
normalFromGroundTruth(:,:,2) = Ny;
normalFromGroundTruth(:,:,3) = Nz;

errH        = abs( Inheights - hhE );
% -- Just the value with in the Mask -- % 
errHM       = mean( errH( imageMaskInDouble > 0 ) );

% --- PROBLEM PART -- different dimension -- % 
errA = abs( InAlbedoMask - albedo );

errA1=errA(:,:,1); 
errA2=errA(:,:,2);
errA3=errA(:,:,3);



errAM1=mean(errA1(imageMaskInDouble>0));
errAM2=mean(errA2(imageMaskInDouble>0));
errAM3=mean(errA3(imageMaskInDouble>0));

errAM=(errAM1+errAM2+errAM3)./3;

errN  = abs( normalFromGroundTruth - normalFromPhotometric );
errN1 = errN(:,:,1);errN2=errN(:,:,2);errN3=errN(:,:,3);

errNM1= mean(errN1(imageMaskInDouble>0));
errNM2= mean(errN2(imageMaskInDouble>0));
errNM3= mean(errN3(imageMaskInDouble>0));

errNormal=(errNM1+errNM2+errNM3)./3;

xCt=normalFromGroundTruth(:,:,1);xC=xCt(imageMaskInDouble>0);
yCt=normalFromGroundTruth(:,:,2);yC=yCt(imageMaskInDouble>0);
zCt=normalFromGroundTruth(:,:,3);zC=zCt(imageMaskInDouble>0);

xEt=normalFromGroundTruth(:,:,1);xE=xEt(imageMaskInDouble>0);
yEt=normalFromGroundTruth(:,:,2);yE=yEt(imageMaskInDouble>0);
zEt=normalFromGroundTruth(:,:,3);zE=zEt(imageMaskInDouble>0);

errR = angularError(xC,yC,zC, xE,yE,zE);
errRM= mean(errR);

% errHM
% errAM 
% errNM

