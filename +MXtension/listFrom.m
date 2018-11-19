function list = listFrom(collection)
% list: MXtension.Collections.List = listFrom(collection) : Returns a read-only list initialized with the given collection.
%
% Parameters:
%   collection - The input collection with the type of:
%       - java.util.Collection or
%       - cell array or
%       - MXtension.Collections.Collection
list = MXtension.Collections.ImmutableList.fromCollection(collection);
end
