% This script launches three tests, :
% _ one on the synthetic dataset Canadian Test
% _ one on the real dataset Beethoven
% _ one on the real dataset Buddha
%
% Those datasets must be stored in the Data/ folder
% They can be downloaded on http://ubee.enseeiht.fr/photometricstereo/

clear all
close all


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Test on synthetic dataset										   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Synthetic dataset of a canadian tent : contains p,q and u (ground truth)
load Data/data_CT_512
u_ref = u;

% Define integration parameters
mask = [];		% whole domain
weights = 100;	% integrability-based weighting 1./(1+weights*integ) 
trace = 1;		% to keep some trace of what is going on
method = 'Cholesky';	% for solving the resulting linear system

% Integration 
u = direct_weighted_poisson(p,q,mask,weights,trace,method);

% Least square integration, for comparison
u_ls = direct_weighted_poisson(p,q);

figure(1)
surfl(fliplr(u_ref),[-30,30])
axis equal
axis off
colormap gray
shading flat
view(-30,30)
title('ground truth')

figure(2)
surfl(fliplr(u_ls),[-30,30])
axis equal
axis off
colormap gray
shading flat
view(-30,30)
title('least square')

figure(3)
surfl(fliplr(u),[-30,30])
axis equal
axis off
colormap gray
shading flat
view(-30,30)
title('weighted')




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Test on real dataset											   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load Data/Beethoven

% Define integration parameters
epsilon = 0.01;
b = 3.5;
weights = calculate_weights_ps(I,mask,b,epsilon);	% photometric stereo-based weighting 
trace = 1;		% to keep some trace of what is going on
method = 'Cholesky';	% for solving the resulting linear system

% Integration on the masked domain
u_masked = direct_weighted_poisson(p,q,mask,weights,trace,method);
% Integration on the masked domain
u_whole = direct_weighted_poisson(p,q,[],weights,trace,method);

% Least square integration, for comparison
u_ls = direct_weighted_poisson(p,q);

figure(4)
surfl(fliplr(u_ls),[-30,30])
axis equal
axis off
colormap gray
shading flat
view(-30,30)
title('least square')

figure(5)
surfl(fliplr(u_masked),[-30,30])
axis equal
axis off
colormap gray
shading flat
view(-30,30)
title('weighted (masked)')

figure(6)
surfl(fliplr(u_whole),[-30,30])
axis equal
axis off
colormap gray
shading flat
view(-30,30)
title('weighted (non masked)')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Test on real dataset											   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load Data/Buddha

% Define integration parameters
epsilon = 0.01;
b = 5;
weights = calculate_weights_ps(I,mask,b,epsilon);	% photometric stereo-based weighting 
trace = 1;		% to keep some trace of what is going on
method = 'Cholesky';	% for solving the resulting linear system

% Integration on the masked domain
u_masked = direct_weighted_poisson(p,q,mask,weights,trace,method);
% Integration on the masked domain
u_whole = direct_weighted_poisson(p,q,[],weights,trace,method);

% Least square integration, for comparison
u_ls = direct_weighted_poisson(p,q);

figure(7)
surfl(fliplr(u_ls),[-30,30])
axis equal
axis off
colormap gray
shading flat
view(-30,30)
title('least square')

figure(8)
surfl(fliplr(u_masked),[-30,30])
axis equal
axis off
colormap gray
shading flat
view(-30,30)
title('weighted (masked)')

figure(9)
surfl(fliplr(u_whole),[-30,30])
axis equal
axis off
colormap gray
shading flat
view(-30,30)
title('weighted (non masked)')


