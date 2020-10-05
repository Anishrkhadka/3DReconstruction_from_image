function [OutMeshSurface] = cleanPhotoMetricSurface(InMeshSurface, IsVisualise, InImageMask, InMultiplier, InIsMoveSuface)

% -- find the smallest Value in Mesh and use it to move mesh above the ground Level (0)-- %
smallestValueInMesh = min( min(InMeshSurface) );
groundLevel         = 0;

if ( smallestValueInMesh <= groundLevel )
    InMeshSurface = InMeshSurface - smallestValueInMesh;
    
end


% -- remove any point below 0 -- % 
InMeshSurface(InMeshSurface < 0) = NaN;

% -- recreate empty space as surface -- % 
InMeshSurface( isnan(InMeshSurface) ) = 0;

% -- Clean the boarder -- % 
for i = 1:1
    InMeshSurface(:,i)    = NaN;
    InMeshSurface(:,65-i) = NaN;
    InMeshSurface(i,:)    = NaN;
    InMeshSurface(65-i,:) = NaN;
end



% -- Use ImageMask -- % 
InMeshSurface(InImageMask<=0) = NaN;

if(InIsMoveSuface)
    smallestValueInMesh = min( min(InMeshSurface) );
    InMeshSurface = InMeshSurface - smallestValueInMesh;
    InMeshSurface( isnan(InMeshSurface) ) = 0;
end

% -- replace NaN back to 0 for smoothing purpose -- % 
InMeshSurface(InImageMask<=0) = 0;
% -- Smooth the surface / mask-- % 
for smoothTimes = 1:2
    
    a = InMeshSurface;

    InMeshSurface  = zeros(64,64);
    
    for i = 2:64-1
        for j = 2:64-1
            InMeshSurface(i,j)  = ( a(i-1,j-1)  +  a(i-1,j) + a(i-1, j+1) + ...
                                    a(i  ,j-1)  +  a(i,  j) + a(i,   j+1)  + ...
                                    a(i+1,j-1)  +  a(i+1,j) + a(i+1, j+1) )/9;
            
        end
    end
    
%     InMeshSurface = InMeshSurface;

end

% -- Remove anything ourside image mask -- % 
% InMeshSurface(InImageMask<=0) = NaN;
compansiateSmoothEffectValue  = 1.5;

    if ( IsVisualise )
   
        [ NewMeshObj ] = surf2patch( InMeshSurface,'triangles' );
             visual = Visualise([],[]);
             visual.appendMesh (NewMeshObj);
             visual.show();
    end
    
    
OutMeshSurface = InMeshSurface * compansiateSmoothEffectValue;
% OutMeshSurface = InMeshSurface;
% -- Match the hight of the new surface with original sphere height -- % 
if (InMultiplier)
    OutMeshSurface = OutMeshSurface * InMultiplier;
end
end 