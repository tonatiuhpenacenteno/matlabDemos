function kern = kernCreate(X, kernelType)
%
% Initialises kernel structure
%
% Syntax: kern = kernCreate(X, kernelType);
%
% Inputs:
%   X           : [n,d] matrix with data 
%   KERNELTYPE  : string with indicating type of kernel. This
%                 `toolbox' only includes the 'ard' type of
%                 kernel. See the function ardKernCompute to have
%                 an idea on  how to implement a new kernel.
% Outputs:
%   KERN        : cell structure with the parameters and kernel
%                 matrix, among other information.
%
%
% This code is based on old code written by Neil D. Lawrence. You
% can check his KERN toolbox to have further reference. 
% Website: http://www.dcs.shef.ac.uk/~neil

% Create fields to store kernel matrix and its diagonal
kern.Kstore = [];
% Initialise other fields
kern.diagK = [];
if iscell(kernelType)
  % compound kernel type
  kern.type = 'cmpnd';
  for i = 1:length(kernelType)
    kern.comp{i}.type = kernelType{i};
    kern.comp{i}.inputDimension = size(X, 2);
  end
else
  kern.type = kernelType;
  kern.inputDimension = size(X, 2);
end
% Initialise parameters of kernel function
kern = feval([kern.type 'KernParamInit'], kern);
