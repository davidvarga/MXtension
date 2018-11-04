classdef IndexedCollection < MXtension.Collections.Collection
    
    
    properties(Access = private)
        Iterator;
    end
    
    methods
        function obj = IndexedCollection(iterator)
            obj.Iterator = iterator;
        end
        
        function iterator = iterator(obj)
            iterator = MXtension.Collections.IndexingIterator(obj.Iterator);
        end
    end
end
