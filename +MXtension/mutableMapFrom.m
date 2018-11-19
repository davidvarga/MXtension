function map = mutableMapFrom(map)
% map: MXtension.Collections.MutableMap = mapFrom(collection) : Returns a mutable map initialized with the given input map.
%
% Parameters:
%   map - The input collection with the type of:
%       - java.util.Map or
%       - containers.Map or
%       - MXtension.Collections.Map
map = MXtension.Collections.HashMap.fromMap(map);
end

