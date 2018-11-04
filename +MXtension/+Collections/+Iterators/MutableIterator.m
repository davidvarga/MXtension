classdef (Abstract) MutableIterator < MXtension.Collections.Iterators.Iterator
    
    methods(Abstract)
        remove(obj);
    end
end
