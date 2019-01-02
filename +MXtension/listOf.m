function list = listOf(varargin)
% list: MXtension.Collections.List = listOf(varargin) : Returns a read-only list initialized with the elements in the arguments.
%
% Parameters:
%   varargin - every element in the variable number input list will be used to initialize the list.
list = MXtension.Collections.ImmutableList.ofElements(varargin{:});
end