function set = setOf(varargin)
% set: MXtension.Collections.Set = mutableSetOf(varargin) : Returns a read-only set initialized with the elements in the arguments.
%
% Parameters:
%   varargin - every element in the variable number input list will be used to initialize the set.
set = MXtension.Collections.ImmutableSet.ofElements(varargin{:});
end

