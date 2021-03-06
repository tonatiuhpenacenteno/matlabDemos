function demLdaQR()
%
% This scripts implements standard LDA and also Algorithm (1)
% presented in the reference as LDA/QR. 
% 
% Notes:
% As any other linear discriminant, algorithm(1) presents a
% technique to maximise Rayleigh's coefficient. However, it has the
% following characteristics:
%
% a) Uses BETWEEN and TOTAL scatter matrices to compute Rayleigh's
% statistic. Yes, it is valid to use the TOTAL scatter matrix  but
% most of the texts use the so-called WITHIN
% covariance. Nonetheless, results should be equivalent.
%
% b) Computation of these matrices is done via the QR decomposition
% of the matrix of centroids.
%
% The rest of the algorithm is the same as standard LDA.
% 
% HOW TO USE:
% This scripts generates two plots with the projections of test
% points over the direction of discrimination.
% Figure (1) - corresponds to standard LDA
% Figure (2) - corresponds to the paper's procedure
%
% WARNING: 
% I use matlab's function "EIG" to obtain the eigenvectors. This
% procedure is sometimes not the most adequate to solve the
% eigenproblem involved.
%
% Reference: 
% "Efficient kernel discriminant analysis via QR decomposition".
%
% See also: REAME file.


% Creating 3 class data
randn('seed', 1e5); rand('seed', 1e4);
Ns = 100;
X = [-0.5+0.1*randn(Ns,1), -0.5+0.1*randn(Ns,1); ...
     0.5+0.1*randn(Ns,1), 0.5+0.1*randn(Ns,1); ...
     0.1*randn(Ns,1), -0.1*randn(Ns,1)];
X = normal(X);
y = [ones(Ns,1); 2*ones(Ns,1); 3*ones(Ns,1)];

% Regularisation coefficient
lambda = 1e-3;

%%%
%%% Computing some useful parameters
%%%

% Parameters
idx1 = find(y==1);
idx2 = find(y==2);
idx3 = find(y==3);

% Means
m1 = mean(X(idx1,:))';
m2 = mean(X(idx2,:))';
m3 = mean(X(idx3,:))';
m = mean(X)';
d = size(m,1);

% Cardinalities
n = length(y);
n1 = sum(y==1);
n2 = sum(y==2);
n3 = sum(y==3);

% Auxiliary vectors E
e1 = ones(n1,1);
e2 = ones(n2,1);
e3 = ones(n3,1);
e = ones(n,1);

% Data matrix
X1 = X(idx1,:);
X2 = X(idx2,:);
X3 = X(idx3,:);
A = [X1', X2', X3'];

%%%
%%% Computing standard LDA solution
%%%

% Computing base matrices
Hb = [sqrt(n1)*(m1-m), sqrt(n2)*(m2-m), sqrt(n3)*(m3-m)];
Hw = A - [m1*e1', m2*e2', m3*e3'];
Ht = A - m*e';

% Covariances
Sb = Hb*Hb';
Sw = Hw*Hw';
St = Ht*Ht';

% $$$ % Displaying matrices
% $$$ fprintf('Between scatter is \n');
% $$$ disp(Sb);
% $$$ fprintf('Within scatter is \n');
% $$$ disp(Sw);
% $$$ fprintf('Their addition is \n');
% $$$ disp(Sw+Sb);
% $$$ fprintf('Total scatter is \n');
% $$$ disp(St);


% Maximising Rayleigh's coefficient
% by solving a generalised eigenproblem
invSw = pdinv(Sw + lambda*eye(d));
[gvecs, gvals] = eig(invSw*Sb); 

% Plotting discriminant over test data
stringTitle = ['Standard LDA solution'];
plotLDA(X, gvecs, idx1, idx2, idx3, stringTitle);


%%%
%%% Computing LDA-QR
%%%

%%% STAGE 1

% Centroid matrix
C = [m1, m2]; 
% QR decomposition
[Q,R] = qr(C);

%%% STAGE 2
Y = Hb'*Q;
Z = Ht'*Q;
U = Hw'*Q;
W = U'*U;
B = Y'*Y;
T = Z'*Z;

% Soving Reduced eigenproblem
invT = pdinv(T + lambda*eye(d));
[vvecs, vvals] = eig(invT*B);
vvals = diag(vvals);
[w, isort] = sort(vvals, 'descend');
vvecs = vvecs(:,isort);

% Computing G = Q*V
G = Q*vvecs;

% Plotting discriminant over test data
stringTitle = ['LDA solution via QR decomposition'];
plotLDA(X, G, idx1, idx2, idx3, stringTitle);




%%%
%%% Auxiliary function
%%%
function plotLDA(X, vecs, idx1, idx2, idx3, stringTitle)

% Projecting new data points
nt = 20;
x1 = linspace(-2, 2, nt);
y1 = linspace(-2, 2, nt);
[XX, YY] = meshgrid(x1, y1);
xt = [XX(:), YY(:)];
yt = xt*vecs;

% Setting font type, size and other parameters for plotting
markerSize = 10;
fontName = 'times';
fontSize = 16;

% Plotting results
figure
hold on;
b = title(stringTitle);
set(b, 'fontname', fontName, 'fontSize', fontSize);
a = plot(X(idx1,1), X(idx1,2), 'r+');
set(a, 'markersize', markerSize, 'lineWidth', 2);
a = plot(X(idx2,1), X(idx2,2), 'bo');
set(a, 'markersize', markerSize, 'lineWidth', 2);
if ~isempty(idx3)
  a = plot(X(idx3,1), X(idx3,2), 'g^');
  set(a, 'markersize', markerSize, 'lineWidth', 2);
end
set(gca, 'fontname', fontName, 'fontSize', fontSize);

hold on;
[void, c1] = contour(x1, y1, reshape(yt(:,1), nt, nt), 2, 'm'); hold on
set(c1, 'linewidth', 2);
[void, c2] = contour(x1, y1, reshape(yt(:,2), nt, nt), 2, 'k');
set(c2, 'linewidth', 2);


