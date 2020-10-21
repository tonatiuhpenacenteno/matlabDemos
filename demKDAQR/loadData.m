function [X, Y] = loadData(name, dataType, Ninst)

% LOADDATA Loads data and labels for a given partition of a dataset
%
% [X, Y] = loadData(name, dataType, Ninst)
%

% Copyright (c) 2006 Tonatiuh Pena Centeno

% loadData.m version 1.17



% 
% Syntax:
% [X, Y] = loadData(name, dataType, Ninst);
%
% Description:
% This function assumes that Training and Test data are stored in a
% format similar to the one used by Gunnar Raetsch, Sebastian Mika
% and others (see README.txt) for their experiments with AdaBoost
% and KFD. 
% More specifically, this function moves to the directory
% ~/datasets/NAME and looks for a couple of ascii files with the names:
% 
% ~/datasets/NAME/NAME_DATATYPE_data_NINST.asc 
% ~/datasets/NAME/NAME_DATATYPE_labels_NINST.asc
%
% where for example we have that
%
% ~/datasets/sloppy/sloppy_train_data_1.asc 
% ~/datasets/sloppy/sloppy_train_labels_1.asc
%
% are the first instances of the input data and labels of the
% dataset called SLOPPY. 
%
% Inputs
%   name      : string with the name of the dataset
%   dataType  : string with either of the values {'train', 'test'}
%   Ninst     : scalar representing the number of partition of the
%               dataset
% Outputs
%   X         : an [N,d] matrix with the measurements or variates
%   Y         : an [N,1] vector of labels in {1,0} format
%
% Other info  : this function sorts the data in a block matrix such
%               that data with a similar label is in the same part
%               of X.
%
% Other info: We consider ~ as the home directory
%

% Checking number of inputs
if nargin ~= 3
  error('LOADDATA: Wrong number of input arguments');
end

% Moving to the data repository
orig_path = pwd;
try 
  cd(['datasets/', name]);
catch
  fprintf('LOADDATA: Directory doesn''t seem to exist\n');
  keyboard;
end


% Verifying that dataType is correct
dataType = lower(dataType);
if ~strcmpi(dataType, 'train') 
  if ~strcmpi(dataType, 'test')
    error('LOADDATA: Only dataTypes allowed are {train,test}');
  end
end


% Constructing names of labels and data files according 
% to specified dataType
dataPrefix = [name, '_', dataType, '_data_']; 
labelPrefix = [name,'_', dataType, '_labels_'];

dataList = dir(['*', dataType, '*data*']);
labelList = dir(['*', dataType, '*labels*']); 
if Ninst > size(dataList,1);
  error(['LODDATA: Number of requested files is bigger than ', ...
         'actual realisations']);
elseif size(dataList,1) ~= size(labelList,1)
  error(['LOADDATA: There''s something fishy with the number ', ...
        'of files']);
end

% Loading data and labels
X = load([dataPrefix, num2str(Ninst), '.asc'], '-ascii');
Y = 0.5*(load([labelPrefix, num2str(Ninst), '.asc'], '-ascii')+1);
[X, Y] = sortData(X, Y);

% Going back to original path
cd(orig_path);


%%%
%%% Auxiliar function to sort the data according to their label values
%%%

function [X, y] = sortData(X, y)

% Fetching class indices.
% We check if negative class is given by {-1} or {0}
idx0 = find(y==0);
if isempty(idx0)
  fprintf('Checking with negative labels {-1}\n');
  idx0 = find(y==-1);
end
idx1 = find(y==1);
X0 = X(idx0,:);
X1 = X(idx1,:);
y0 = y(idx0);
y1 = y(idx1);
 
% Aligning data
X = [X0; X1];
y = [y0; y1];