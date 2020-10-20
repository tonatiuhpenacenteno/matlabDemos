function plotKda(kern, X, y, ViRM)
% 
% Plots the projection of test points over the direction of
% discrimination.
% 
% Syntax: plotKda(kern, X, y, ViRM);
%
% Inputs:
%   KERN        : cell structure containing the parameters of the
%                 kernel matrix, as well as the matrix K itself.
%   X           : [n,d] matrix with data.
%   y           : [n,1] vector with indicator variables.
%   ViRM        : matrix with the product of the matrices
%                 R^{\phi}\timesM^{T}. See Algorithm 2 (KDAQR) for
%                 further reference.
% 
% See also: README file.

% Setting font type, size and other parameters for plotting
markerSize = 10;
fontName = 'times';
fontSize = 16;

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

% Plotting figures
figure(1)
idx1 = find(y==1);
idx2 = find(y==2);
hold on;
a = plot(X(idx1,1), X(idx1,2), 'r+');
set(a, 'markersize', markerSize, 'lineWidth', 2);
a = plot( X(idx2,1), X(idx2,2), 'bo');
set(a, 'markersize', markerSize, 'lineWidth', 2);
set(gca, 'fontname', fontName, 'fontSize', fontSize);
% Considering three classes.
idx3 = find(y==3);
if ~isempty(idx3)
  a = plot( X(idx3,1), X(idx3,2), 'g^');
  set(a, 'markersize', markerSize, 'lineWidth', 2);
end

% Adjusting the plot's limits
xlim = get(gca, 'xlim');
xlim = xlim*1.2;
set(gca, 'xlim', xlim);
ylim = get(gca, 'ylim');
ylim = ylim*1.2;
set(gca, 'ylim', ylim);

hold on;
[void, c1] = contour(x1, y1, reshape(yt(:,1), nt, nt), 2, 'm'); hold on
set(c1, 'linewidth', 2, 'linestyle', '--');
[void, c2] = contour(x1, y1, reshape(yt(:,2), nt, nt), 2, 'k');
set(c2, 'linewidth', 2);
if ~isempty(idx3)
  [void, c2] = contour(x1, y1, reshape(yt(:,3), nt, nt), 2, 'c');
  set(c2, 'linewidth', 3, 'linestyle', ':');
end