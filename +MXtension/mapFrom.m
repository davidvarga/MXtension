function map = mapFrom(map)
% map: MXtension.Collections.Map = mapFrom(collection) : Returns a read-only map initialized with the given input map.
%
% Parameters:
%   map - The input collection with the type of:
%       - java.util.Map or
%       - containers.Map or
%       - MXtension.Collections.Map
map = MXtension.Collections.ImmutableMap.fromMap(map);
end

