function set = setFrom(collection)
% set: MXtension.Collections.Set = setFrom(collection) : Returns a read-only set initialized with the given collection.
%
% Parameters:
%   collection - The input collection with the type of:
%       - java.util.Collection or
%       - cell array or
%       - MXtension.Collections.Collection
set = MXtension.Collections.ImmutableSet.fromCollection(collection);
end
