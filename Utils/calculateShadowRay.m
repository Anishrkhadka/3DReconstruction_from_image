function [IsInShadow] = calculateShadowRay( InScene, InPointOnObjectSurface )
% -- Sphere -- % 
pointOnLightSurface = InScene{1}.getPointOnSurface;

shadowRay.direction = unit( pointOnLightSurface - InPointOnObjectSurface ) ;
shadowRay.origin    = pointOnLightSurface;




end