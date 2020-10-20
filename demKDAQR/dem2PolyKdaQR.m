% This script implements NLDA algorithm via QR decomposition. 
% Give a read to the README file for more information about the
% demos. Give a read to the paper by Tao Xiong, et al. for further
% details about the algorithm.
% This demo classifies multi-class data. 
%
% Syntax: demKdaQR
%
% See also: demKdaQR, README file
% 
% Note: 
% This code requires the function PDINV available in the KERN
% toolbox written by Neil D. Lawrence. You can have further
% information about it at his website:
%                http://www.dcs.shef.ac.uk/~neil



% Creating 3 class data
randn('seed', 1e5); rand('seed', 1e4);
Ns = 100;
X = [-0.5+0.1*randn(Ns,1), -0.5+0.1*randn(Ns,1); ...
     0.5+0.1*randn(Ns,1), 0.5+0.1*randn(Ns,1); ...
     0.1*randn(Ns,1), -0.1*randn(Ns,1)];
X = normal(X);
y = [ones(Ns,1); 2*ones(Ns,1); 3*ones(Ns,1)];

% Specifying data parameters
c = 3;  %% Number of classes
n1 = sum(y==1);
n2 = sum(y==2);
n3 = sum(y==3);
n = length(y);
d = size(X,2);

% Some other definitions
e = ones(n,1);
E = eye(n) - e*e'/n;

% Regularisation coefficient
lambda = 1e-3;

%%%
%%% Stage 1
%%%

% Computing kernel 
kernelType = 'poly';
kern = kernCreate(X, kernelType);
K = kernCompute(kern, X);


% Computing matrices "N" and "M"
[N,M] = createMatrices(n, y, c);

% Computing (Cf)'*Cf = M'*K*M
MKM = M'*K*M;
% Computing R
R = chol(MKM);
invR = pdinv(R);

%%%
%%% Stage 2
%%%

% Computing Y, Z, B and T
Y = N*MKM*invR;
Z = E'*K*M*invR;
B = Y'*Y;
T = Z'*Z;

% Computing eigenvectors of T and 
% sorting them according to decreasing
% eigenvalues
lambda = 1e-3;
invT = pdinv(T + lambda*eye(c));
[evecs, evals] = eig(invT*B);
evals = real(diag(evals));
[w, isort] = sort(evals, 'descend');
evecs = evecs(:,isort);

% Product ViRM (See algorithm 2)
ViRM = evecs'*invR*M';

% Projecting test data
plotKda(kern, X, y, ViRM);
