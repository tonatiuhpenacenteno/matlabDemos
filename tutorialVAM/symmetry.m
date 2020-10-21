function [Q1, Q2, P, Jnew] = symmetry(p);
% This function computes a variational approximation
% for the two binary variable problem described in
% one of the exampes of the reference.
% 
% Syntax: 
% [Q1, Q2, P, Jnew] = symmetry(p);
%
% Where "p" is a user specified parameter, P is a
% table of probabilities and Jnew is the value of the 
% bound.
%
% Reference:
% T. Jaakkola.
% Tutorial on variational approximation methods.
% In Advanced mean field methods: theory and practice. 
% MIT Press, 2000. 
%
% Last modified: TPC on 25-Aug-05

% Defining a value p
if nargin < 1
  p = 0.5;
end

% Specifying probability table 
P(1,:) = [(1-p)/2, p/2];   % x1=0
P(2,:) = [p/2, (1-p)/2];   % x1=1

% Computing true bound
L = log(sum(sum(P)));
fprintf('Marginal likelihood is %2.4f\n', L);


% Initialising Q1, Q2
rand('seed', 1e5); randn('seed', 1e5);
r = rand;
Q1 = [r, 1-r];
%Q2 = [Q1(1)+eps, Q1(2)-eps];
% Updating Q2
Q2 = exp([Q1*log(P(:,1)), Q1*log(P(:,2))]);
Q2 = Q2./sum(Q2);

% Computing bound
Jold = -Inf;
Jnew = ent(Q2) + ent(Q1) + crossEnt(Q1, Q2, P);
Jdiff = Jnew - Jold;
fprintf('The bound is %2.6f. Difference is %2.6f\n', ...
        Jnew, Jdiff);

% Defining tolerance
tol = 1e-8;

% Updating distributions
while Jdiff > tol
  
  % Updating Jold
  Jold = Jnew;
  
  % Updating Q1
  Q1 = exp([Q2*log(P(1,:))', Q2*log(P(2,:))']);
  Q1 = Q1./sum(Q1);
  
  % Updating Q2
  Q2 = exp([Q1*log(P(:,1)), Q1*log(P(:,2))]);
  Q2 = Q2./sum(Q2);
  
  % Updating bound
  Jnew = ent(Q2) + ent(Q1) + crossEnt(Q1, Q2, P);
  Jdiff = Jnew - Jold;
  fprintf('The bound is %2.6f. Difference is %2.6f\n', ...
          Jnew, Jdiff);

end

% Function to compute the entropy of an approx.
% distribution Q
function h = ent(Q)

h = -Q*log(Q)';

% Function to compute the begative of the 
%cross-entropy term  between Q(x1,x2) 
% and P(x1,x2)
function h = crossEnt(Q1, Q2, P)

h = Q1*log(P)*Q2';