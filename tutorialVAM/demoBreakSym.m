function demoBreakSym();
% This script calls the function "symmetry" several times and
% obtains plots (a) and (b) from Figure 2 of the following paper:
%
% Syntax: 
% demoBreakSym();
%
% Reference:
% T. Jaakkola.
% Tutorial on variational approximation methods.
% In Advanced mean field methods: theory and practice. 
% MIT Press, 2000. 
%
% Last modified: TPC on 25-Aug-05

% Define a vector of probabilities
P = linspace(0.5+eps,1-eps, 100);


% Store the values of Q distributions after calling symmetry
for it = 1:length(P)
  [Q1(it,:), Q2(it,:), w, Jnew(it)] = symmetry(P(it));
end

% Plots (a)
figure(1)
plot(P, Q1(:,2), 'r', P, Q1(:,1), 'r.-');
axis([0.5, 1, 0, 1]);

% Plots (b)
figure(2)
plot(P, Jnew, 'b');