classdef IndexingIterable < MXtension.Collections.Iterable
    
    
    properties(Access = private)
        Iterator;
    end
    
    methods
        function obj = IndexingIterable(iterator)
            obj.Iterator = iterator;
        end
        
        function iterator = iterator(obj)
            iterator = MXtension.Collections.IndexingIterator(obj.Iterator);
        end
    end
end
