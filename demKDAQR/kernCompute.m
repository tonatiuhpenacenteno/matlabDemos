function k = kernCompute(kern, x, x2)
%
% Computes the kernel matrix according to the value KERN and X, X2 
%
% Syntax:  k = kernCompute(kern, x, x2);
% 
% Inputs:
%   KERN        : cell structure containing the parameters of the
%                 kernel matrix, as well as the matrix K itself.
%   X           : [n,d] matrix with data 
%   X2(*)       : optional matrix with extra data, dimensions
%                 [n2,d]
%
% Outputs:
%   K           : [n,n] kernel matrix, composed of RBF+LINEAR... 
%                  +BIAS+NOISE parts
%
% Note: (*) indicates an optional parameter.
%
% This code is based on old code written by Neil D. Lawrence. You
% can check his KERN toolbox to have further reference. 
% Website: http://www.dcs.shef.ac.uk/~neil


% Compute kernel according to the number of available inputs
if nargin < 3
  k = feval([kern.type 'KernCompute'], kern, x);
else
  k = feval([kern.type 'KernCompute'], kern, x, x2);
end
