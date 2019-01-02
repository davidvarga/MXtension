function map = mutableMapOf(varargin)
% map: MXtension.Collections.MutableMap = mapOf(varargin) : Returns a mutable map initialized with the input elements.
%
% Parameters:
%   varargin - every input argument must be an instance of 
%       - MXtension.Collections.Entry or
%       - MXtension.Pair
map = MXtension.Collections.HashMap.ofEntries(varargin{:});
end
