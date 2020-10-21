function y = normal(x)
% NORMAL  Calculate normalisation to unit variance zero mean
%
% Linearly rescale data to have zero mean and unit variance
% in each column (apart from those with zero variance).
% 
% Copyright (c) Ian T Nabney (2000)

%       This code forms part of the Netlab library, available from 
%       http://www.ncrg.aston.ac.uk/ 

%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program; if not, write to the Free Software
%    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


n = size(x, 1);
% Compute mean and variance
mu = mean(x, 1);
sigma = std(x, 1);

% Rescale data, taking care over columns with zero variance to avoid
% division by zero
e = ones(n, 1);
y = (x - e*mu);  % Make y have zero mean
y = y./(e*(sigma+(sigma==0)));


