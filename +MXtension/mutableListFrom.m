function list = mutableListFrom(collection)
% list: MXtension.Collections.MutableList = listFrom(collection) : Returns a mutable list initialized with the given collection.
%
% Parameters:
%   collection - The input collection with the type of:
%       - java.util.Collection or
%       - cell array or
%       - MXtension.Collections.Collection
list = MXtension.Collections.ArrayList.fromCollection(collection);

end
