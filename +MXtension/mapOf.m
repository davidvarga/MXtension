function map = mapOf(varargin)
% map: MXtension.Collections.Map = mapOf(varargin) : Returns a read-only map initialized with the input elements.
%
% Parameters:
%   varargin - every input argument must be an instance of 
%       - MXtension.Collections.Entry or
%       - MXtension.Pair
map = MXtension.Collections.ImmutableMap.ofEntries(varargin{:});
end