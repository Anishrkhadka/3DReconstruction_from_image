function [OutVector] = rotation(InVector, InRotationAxis, InAngle)

if (InRotationAxis == 'x')
%     RotationXMat = ...
%         [ 1*InVector(1), 0*InVector(2)         , 0*InVector(3)          , 0*InVector(4)  ;
%         0*InVector(1), cos(InAngle)*InVector(2), -sin(InAngle)*InVector(3), 0*InVector(4);
%         0*InVector(1), sin(InAngle)*InVector(2), cos(InAngle)*InVector(3) , 0*InVector(4);
%         0*InVector(1), 0*InVector(2)           , 0*InVector(3)            , 1*InVector(4)] ;
%     
%     OutVector = [RotationXMat(1,1), RotationXMat(2,1), RotationXMat(3,1)];
    
    OutVector = [InVector(1), ...
                cos(InAngle)*InVector(2) - sin(InAngle)*InVector(3),...
                sin(InAngle)*InVector(2) + cos(InAngle)*InVector(3)];
    
    
elseif (InRotationAxis == 'y')
%     RotationYMat = ...
%         [ cos(InAngle)*InVector(1),  0*InVector(2) , sin(InAngle)*InVector(3), 0*InVector(4)  ;
%         0*InVector(1),1*InVector(2), 0*InVector(3), 0*InVector(4);
%         -sin(InAngle)*InVector(1), 0*InVector(2), cos(InAngle)*InVector(3) , 0*InVector(4);
%         0*InVector(1), 0*InVector(2)  , 0*InVector(3) , 1*InVector(4)] ;
%     
%   OutVector = [RotationYMat(1,1), RotationYMat(2,1), RotationYMat(3,1)];
%     OutVector = [cos(InAngle)*InVector(1) + sin(InAngle)*InVector(3), ...
%                  InVector(2),...
%                 -sin(InAngle)*InVector(1) + cos(InAngle)*InVector(3) ];
    
    OutVector = [cos(InAngle)*InVector(1) + sin(InAngle)*InVector(3), ...
                 InVector(2),...
                -sin(InAngle)*InVector(1) + cos(InAngle)*InVector(3) ];
    
elseif (InRotationAxis == 'z')
%     RotationZMat = ...
%         [ cos(InAngle)*InVector(1), -sin(InAngle)*InVector(2), 0*InVector(3), 0*InVector(4)  ;
%         sin(InAngle)*InVector(1), cos(InAngle)*InVector(2),  0*InVector(3), 0*InVector(4);
%         0*InVector(1), 0*InVector(2), 1*InVector(3), 0*InVector(4);
%         0*InVector(1), 0*InVector(2)  , 0*InVector(3) , 1*InVector(4)] ;
%     
%     OutVector = [RotationZMat(1,1), RotationZMat(2,1), RotationZMat(3,1)];

    OutVector = [cos(InAngle)*InVector(1) - sin(InAngle)*InVector(2), ...
                 -sin(InAngle)*InVector(1) + cos(InAngle)*InVector(2),...
                InVector(3)];
     
end



end