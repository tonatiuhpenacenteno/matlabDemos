function [lda, Sb, Sw, qda]  = smithFigure(dataset);
% This function produces the `classic' plot of the Normal-Psychotic
% data of C.B. Smith's paper "Some examples of discrimination"
%
% Syntax:  [lda, Sb, Sw, qda]  = smithFigure(dataset);
%
% Inputs: 
%   dataset      : string with the name of a dataset to be used,
%                  in this case it should be 'psychotic'
% Outputs: 
%   lda          : structure with information about linear
%                  discriminant.
%   Sb           : between covariance matrix
%   Sw           : within covariance matrix
%   qda          : structure with information about quadratic
%                  discriminant. 
%
% Reference:
% Cedric A.B. Smith. "Some examples of discrimination". Annals of 
% eugenics", vol. 18, pp 272-282.
%
% Created: 06-Mar-06

%%%
%%% LINEAR DISCRIMINANT
%%%
% Loading data
[X,y] = loadData(dataset, 'train', 1);
lda.X = X(:,[1,2]);
lda.Y = y;

lda.lambda = 1e-3;
% Computing within covariance matrix
[Sw, m1, m] = withinCov(lda);
% Between class covariance
Sb = betweenCov(lda); 
% We solve the eigenproblem to find the best features
% evecs = eigenvectors      evacs = eigenvalues
[eigVecs, eigVals] = eig(inv(Sw)*Sb);
eigVals = real(diag(eigVals));
% $$$ % Normalising eigenvectors
% $$$ for it = 1:length(eigVals)
% $$$   eigVecs(:,it) = eigVecs(:,it)./sqrt(eigVals(it));
% $$$ end
lda.eigVecs = eigVecs; lda.eigVals = eigVals;
lda.W = eigVecs;  
ldaPlot(lda);


%%%
%%% QUADRATIC DISCRIMINANT
%%%


% Splitting data according to each class
qda.idx1 = find(lda.Y==1);
qda.idx0 = find(lda.Y==0);
qda.n1 = length(qda.idx1);
qda.n0 = length(qda.idx0);
qda.X1 = lda.X(qda.idx1,:);
qda.X0 = lda.X(qda.idx0,:);
qda.m0 = mean(qda.X0)';
qda.m1 = mean(qda.X1)';

% Covariances
cov1 = cov(qda.X1);
cov1(1,2) = 0; cov1(2,1) = 0; % Taking out correlations
cov0 = cov(qda.X0);
cov0(1,2) = 0; cov0(2,1) = 0; % Taking out correlations
qda.cov1 = cov1; qda.cov0 = cov0;
qda.invSig0 = inv(cov0);
qda.invSig1 = inv(cov1);
qda.invSigT = qda.invSig1 - qda.invSig0;
qda.vecProd = 2*(qda.invSig1*qda.m1 - qda.invSig0*qda.m0);
qda.bias = -0.5*(qda.m0'*qda.invSig0*qda.m0 + qda.m1'*qda.invSig1*qda.m1) ... 
       -0.5*log(det(cov1)/det(cov0));
qdaPlot(qda)
title('N-P test by C.A.B. Smith')


%%%
%%% Auxiliary functions
%%%

function [Sw, m1, m0] = withinCov(lda)
% Computes the generalization of the within-class scatter

% We compute the generalised WITHIN-class covariance matrix

% Splitting data according to each class
idx1 = find(lda.Y==1);
idx0 = find(lda.Y==0);
n1 = length(lda.X(idx1));
n0 = length(lda.X(idx0));
m1 = repmat(mean(lda.X(idx1,:)), n1, 1);
m0 = repmat(mean(lda.X(idx0,:)), n0, 1);
X1 = lda.X(idx1,:);
X0 = lda.X(idx0,:);
% Within covariance matrix
Sw = (X1-m1)'*(X1-m1) + (X0-m0)'*(X0-m0);
Sw = Sw + lda.lambda*eye(size(Sw));
% $$$ % These are the values used in the paper 
% $$$ Sw = [21.83, 4.33; 4.33, 164.40];

function Sb = betweenCov(lda)
% Computes the generalization of the within-class scatter

% We compute the generalised BETWEEN-class covariance matrix

% Splitting data according to each class
idx1 = find(lda.Y==1);
idx0 = find(lda.Y==0);
n1 = length(lda.X(idx1));
n0 = length(lda.X(idx0));
m1 = mean(lda.X(idx1,:));
m0 = mean(lda.X(idx0,:));
m = mean(lda.X);
% Between covariance 
Sb = n1*(m1-m)'*(m1-m) + n0*(m0-m)'*(m0-m);


function ldaPlot(lda)
%
% Plots linear discriminant

% Parameters to format the plot 
markerSize = 10;
fontName = 'times';
fontSize = 16;
lineWidth = 2;
figure(1);  

% Plotting the data
set(gca, 'box', 'on');
Xplus = lda.X(find(lda.Y==1),:); 
p1 = plot(Xplus(:,1), Xplus(:,2), 'ro'); hold on;
set(p1, 'markersize', markerSize, 'linewidth', lineWidth);
X0 = lda.X(find(lda.Y==0),:);
p2 = plot(X0(:,1), X0(:,2), 'b^'); hold on;
set(p2, 'markersize', markerSize, 'linewidth', lineWidth);
% Formatting the axes
set(gca, 'box', 'on')
set(gca, 'fontname', fontName, 'fontSize', fontSize)

% Projecting test data
w = lda.W;
ntest = 20;
xtest = linspace(6.5, 28, ntest)';
ytest = (-w(1,2)/w(2,2)).*xtest(:,1);
N1 = length(Xplus); N0 = length(X0);
m1 = mean(Xplus); m0 = mean(X0);
% Setting the bias is rather arbitrary ...
bias = (N1-N0-(N1*m1+N0*m0)*w(:,2))/(N1+N0);
bias = -bias*(w(1,2)/w(2,2));
linD = plot(xtest, ytest+bias, 'g');
set(linD, 'linewidth', lineWidth);

%%%
%%% Uncomment the following lines if you want to see the 
%%% discriminant obtained according to Smith's derivations
%%%
% $$$ % Plotting the true solution
% $$$ [xp, yp] = fplot('0.5*(5.07*x-36.4)', [3 28]);
% $$$ plot(xp, yp, 'k', 'linewidth', lineWidth);

% Adjusting the plot's limits
set(gca, 'xlim', [0 30]);
set(gca, 'ylim', [0 65]);



function qdaPlot(qda)
%
% Plots the quadratic discriminant
% Note:We show the isocritic line nearest to the null value

ntest = 25;
xtest = linspace(0,30,ntest);
ytest = linspace(0,65,ntest);
[XX, YY] = meshgrid(xtest, ytest);
Xt = [XX(:), YY(:)];
D = -diag(Xt*qda.invSigT*Xt') + Xt*qda.vecProd + qda.bias;
isoLevel = 18;
[c,h] = contour(XX, YY, reshape(D, ntest, ntest), [18 18], 'g');
lineWidth = 2;
set(h, 'linewidth', lineWidth);

%%%
%%% Uncomment these lines if you want to see the discriminant
%obtained according to Smith's derivations
%%%
% $$$ D2 = diag(Xt*[0.25, 0; 0, 0.04]*Xt') - Xt*[11.5; 0.64] + 118.81;
% $$$ isoLevel2 = 1e-6;
% $$$ [c2,h2] = contour(XX, YY, reshape(D2, ntest, ntest), [isoLevel2], 'k');
% $$$ set(h2, 'linewidth', lineWidth);
