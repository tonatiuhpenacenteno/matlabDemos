function kern = ardKernParamInit(kern)
%
% This function initialises the parameters of the kernel function.
%
% Syntax: kern = ardKernParamInit(kern);
% 
% Inputs: 
%   KERN        : cell structure containing the parameters of the
%                 kernel matrix, as well as the matrix K itself.
% Outputs:
%   KERN        : modified cell structure. The fields that are
%                 modified are those related to the parameters of
%                 the kernel matrix, obviously.
%
% This code is based on old code written by Neil D. Lawrence. You
% can check his KERN toolbox to have further reference. 
% Website: http://www.dcs.shef.ac.uk/~neil

% Initialising all parameters of ARD kernel to 1.
kern.inverseWidth = 1;
kern.rbfVariance = 1;
kern.whiteVariance = 1; 
kern.biasVariance = 1;
kern.linearVariance = 1;
kern.inputScales = 0.999*ones(1, kern.inputDimension);
kern.nParams = 5 + kern.inputDimension;

% Transforming parameter space 
kern.transforms(1).index = [1 2 3 4 5];
kern.transforms(1).type = 'negLogLogit';
kern.transforms(2).index = [6:kern.nParams];
kern.transforms(2).type = 'sigmoid';
