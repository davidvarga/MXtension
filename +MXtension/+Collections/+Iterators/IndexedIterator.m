classdef IndexedIterator < MXtension.Collections.Iterators.Iterator
    
    properties(Access = private)
        Iterator;
        Index = 1;
    end
    
    methods
        function obj = IndexedIterator(iterator)
            obj.Iterator = iterator;
        end
        
        function hasNext = hasNext(obj)
            hasNext = obj.Iterator.hasNext();
        end
        function nextElement = next(obj)
            nextElement = MXtension.Collections.Iterators.IndexedValue(obj.Index, obj.Iterator.next());
            obj.Index = obj.Index + 1;
        end
    end
    
end
