function n2 = dist2(x, c)
%DIST2	Calculates squared distance between two sets of points.
%
%	Description
%	D = DIST2(X, C) takes two matrices of vectors and calculates the
%	squared Euclidean distance between them.  Both matrices must be of
%	the same column dimension.  If X has M rows and N columns, and C has
%	L rows and N columns, then the result has M rows and L columns.  The
%	I, Jth entry is the  squared distance from the Ith row of X to the
%	Jth row of C.
%
%	See also
%	GMMACTIV, KMEANS, RBFFWD
%

%	Copyright (c) Ian T Nabney (1996-2001)

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


[ndata, dimx] = size(x);
[ncentres, dimc] = size(c);
if dimx ~= dimc
	error('Data dimension does not match dimension of centres')
end

n2 = (ones(ncentres, 1) * sum((x.^2)', 1))' + ...
  ones(ndata, 1) * sum((c.^2)',1) - ...
  2.*(x*(c'));

% Rounding errors occasionally cause negative entries in n2
if any(any(n2<0))
  n2(n2<0) = 0;
end