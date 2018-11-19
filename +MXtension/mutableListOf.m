function list = mutableListOf(varargin)
% list: MXtension.Collections.MutableList = mutableListOf(varargin) : Returns a mutable list initialized with the elements in the arguments.
%
% Parameters:
%   varargin - every element in the variable number input list will be used to initialize the list.
list = MXtension.Collections.ArrayList.ofElements(varargin{:});
end