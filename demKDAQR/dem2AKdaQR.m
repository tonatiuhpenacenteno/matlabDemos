% This script implements an approximation to NLDA algorithm via QR
% decomposition. The Algorithm is known as AKDA/QR. Give a read to
% the paper by Tao Xiong et al. for further details about the
% algorithm. 
% This demo classifies multi-class data.
% 
% Syntax: demAKdaQR
%
% See also: dem2AKdaQR, README file
% 
% Note: 
% This code requires the function PDINV available in the KERN
% toolbox written by Neil D. Lawrence. You can have further
% information about it at his website:
%                http://www.dcs.shef.ac.uk/~neil


% Creating 2 class data
randn('seed', 1e5); rand('seed', 1e4);
Ns = 100;
X = [-0.5+0.1*randn(Ns,1), -0.5+0.1*randn(Ns,1); ...
     0.5+0.1*randn(Ns,1), 0.5+0.1*randn(Ns,1); ...
     0.1*randn(Ns,1), -0.1*randn(Ns,1)];
X = normal(X);
y = [ones(Ns,1); 2*ones(Ns,1); 3*ones(Ns,1)];
[n,d] = size(X);

% Specifying data parameters
c = 3;
idx1 = find(y==1);
idx2 = find(y==2);
idx3 = find(y==3);

%%%
%%% Stage 1
%%%

% Computing class centres
xc1 = mean(X(idx1,:));
xc2 = mean(X(idx2,:));
xc3 = mean(X(idx3,:));
xh = [xc1; xc2; xc3];

% Some other vectors and matrices
nh = size(xh,1);
yh = [1;2;3];
e = ones(n,1);
E = eye(n) - e*e'/n;

% Constructing approximate kernels
kernelType = 'ard';
kern = kernCreate(xh, kernelType);
Kh = kernCompute(kern, xh);
kernTc = kernCreate(X, kernelType);
Ktc = kernCompute(kern, X, xh);

% Computing R
R = chol(Kh);
invR = pdinv(R);

% Computing matrices "N" and "M"
[N,M] = createMatrices(n, y, c);


%%%
%%% Stage 2
%%%

% Computing Y, Z, B and T
Y = N*Kh*invR;
Z = E'*Ktc*invR;
B = Y'*Y;
T = Z'*Z;

% Computing and sorting eigenvectort
% according to their eigenvalues
lambda = 1e-3;
invT = pdinv(T + lambda*eye(size(T)));
[aPvecs, aPvals] = eig(invT*B);
aPvals = real(diag(aPvals));
[w, isort] = sort(aPvals, 'descend');
aPvecs = aPvecs(:,isort);

% Product ViRM
ViRM = aPvecs'*invR*M';
%%%
%%% Projecting some test points
%%%
nt = 20;
x1 = linspace(-2, 2, nt);
y1 = linspace(-2, 2, nt);
[XX, YY] = meshgrid(x1, y1);
xt = [XX(:), YY(:)];

Kt = kernCompute(kern, X, xt);
yt = Kt'*ViRM';

% Projecting test data
plotKda(kern, X, y, ViRM);
