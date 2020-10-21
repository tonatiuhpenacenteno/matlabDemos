function [k, linearPart] = polyKernCompute(kern, x, x2)
% 
% This function computes an RBF kernel with ARD lenght scales.
%  
% Syntax: [k, rbfPart, ...
%          linearPart, n2] = ardKernCompute(kern, x, x2);
%
% Inputs: 
%   KERN        : cell structure containing the parameters of the
%                 kernel matrix, as well as the matrix K itself.
%   X           : [n,d] matrix with data 
%   X2(*)       : optional matrix with extra data, dimensions
%                 [n2,d]
% Outputs:
%   K           : [n,n] kernel matrix, composed of RBF+LINEAR... 
%                  +BIAS+NOISE parts
%   RBFPART     : [n,n] matrix with RBF part of the kernel matrix
%   LINEARPART  : [n,n] matrix with LINEAR part of the kernel
%                  matrix
%   N2          : [n,n] matrix with the NOISE part of the kernel
%                  matrix
%
% Note: (*) indicates an optional parameter.
%
% This code is based on old code written by Neil D. Lawrence. You
% can check his KERN toolbox to have further reference. 
% Website: http://www.dcs.shef.ac.uk/~neil

% Weighting the value of each dimension of the data with the value
% of its corresponding lenght-scale
scales = diag(sqrt(kern.inputScales));
x = x*scales;
    
% Computing the kernel according to the number of inputs. If only
% one X argument is given, then the NOISE term is added to the main
% diagonal of K.
if nargin < 3
  linearPart = (x*x').^2;
  k = kern.whiteVariance*eye(size(x, 1)) + linearPart;
else
  x2 = x2*scales;
  linearPart = (x*x2').^2;
  k = linearPart;
end
k = k + kern.biasVariance;