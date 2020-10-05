% -- Main  -- %

% addpath('./tracer');
addpath('./Utils');
% addpath('./InternalData');
% addpath('./photometricStereo');
% addpath('./environmentTracer');

% totalScene = 3;
% === At the Start x 1 === %
% -- Render Original Image (Raytraceing )-- %
%   tracer()
% -- End -- %

for i = 1:2
% -- Save the new photometric surface which has lowest height error -- % 
getAllSurfaceWithLowestHeightErrorAndSave();

% -- render new environment image with new surface -- % 
renderAndReplaceEnvironmentColour();

end





