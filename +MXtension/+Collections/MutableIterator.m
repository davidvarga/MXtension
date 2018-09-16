classdef MutableIterator < MXtension.Collections.Iterator
    
    methods(Abstract)
        remove(obj);
    end
end
