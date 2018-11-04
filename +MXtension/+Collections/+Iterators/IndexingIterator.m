classdef IndexingIterator < MXtension.Collections.Iterators.Iterator
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    
    properties(Access = private)
        Iterator;
        Index = 1;
    end
    
    
    methods
        function obj = IndexingIterator(iterator)
            % TODO: throw error if class is worng
            obj.Iterator = iterator;
            
        end
        
        function hasNext = hasNext(obj)
            hasNext = obj.Iterator.hasNext();
        end
        function nextElement = next(obj)
            nextElement = MXtension.Collections.Iterators.IndexedValue(obj.Index, obj.Iterator.next());
            obj.Index = obj.Index + 1;
        end
        
        function obj = remove(obj)
            obj.Iterator.remove();
        end
    end
    
end
