
function [vardintout, Iintout]=computeSeparationVarianceIntOut(x,l1,l2,sig,int_vec, pixelizeversion, offset)
% [vardintout, Iintout]=computeSeparationVarianceIntOut(x,l1,l2,sig,int_vec, pixelizeversion)
% Computes variance (as a inverse of the Fisher Information) of two points
% separated by a distance d=c1-c2. Integrating out the intensity. 

if ~exist('offset','var')
    offset=0; % background
end

if ndims(x) == 2 %1D vector
    f1=makeGauss(x,l1,sig(1));                  % creates PSF (gauss approx -> !!! Different to simulationtools/makegauss.m !!!)
else 
    f1_2D=makeGauss2D(x,l1,sig(1));
    f1 = reshape(f1_2D,1,numel(f1_2D));          % making 1D vector by concatenating 2D array
end
    
for ind_dist=1:length(l2)                       % distance    
    if ndims(x)==2 %1D vector
        f2=makeGauss(x,l2(ind_dist),sig(2));    % creates PSF (gauss approx) shifted to l2
    else
        f2_2D=makeGauss2D(x,l2(ind_dist),sig(2));
        f2 = reshape(f2_2D,1,numel(f2_2D));     % making 1D vector by concatenating 2D array
    end
    nphot = int_vec(1);    
    Iintout(:,:,ind_dist)=numericalMeanEstimation(x,f1,f2, offset, nphot);
    vardintout(ind_dist)=[1,-1]/Iintout(:,:,ind_dist)*[1,-1]';
end
q=0;