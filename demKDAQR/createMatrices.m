function [N,M] = createMatrices(n, y, c)
%
% Creates the matrices N and M required to compute the QR
% approximation proposed by Jieping Ye. 
%
% Syntax: [N,M] = createMatrices(n, y, c);
%
% Inputs:
%   n           : scalar with the length of the data matrix
%                 X, in other words [n,d] = size(X).
%   y           : [n,1] vector with indicator values
%   c           : scalar indicating the number of classes
% Outputs:
%   N           : [n,c] matrix
%   M           : [n,c] matrix
%
% This code is based on code written by Jieping Ye. You
% can check the original code for this paper at:
%
% http://www.public.asu.edu/~jye02/

% Allocating space for both "N" and "M"
M = zeros(n,c);
N = zeros(n,c);


numarray = [];
for i = 1:c
    numarray = [numarray, length(find(y==i))];
end

pos = 0;
% Creating M
for i = 1:c
    M(pos+1:pos+numarray(i),i)= 1/numarray(i);
    pos = pos + numarray(i);
end

pos = 0;
% Creating N
for i = 1:c
     N(pos+1:pos+numarray(i),i)= 1/sqrt(numarray(i));
     N(:,i) = N(:,i) - sqrt(numarray(i))/n;
     pos = pos + numarray(i);   
end
