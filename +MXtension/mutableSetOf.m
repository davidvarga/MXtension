function set = mutableSetOf(varargin)
% set: MXtension.Collections.MutableSet = mutableSetOf(varargin) : Returns a mutable set initialized with the elements in the arguments.
%
% Parameters:
%   varargin - every element in the variable number input list will be used to initialize the set.
set = MXtension.Collections.ArraySet.ofElements(varargin{:});
end
