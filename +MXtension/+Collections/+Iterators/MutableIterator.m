classdef (Abstract) MutableIterator < MXtension.Collections.Iterators.Iterator
    
    methods(Abstract)
        % Removes from the underlying collection the last element returned by this iterator.
        remove(obj);
    end
end
