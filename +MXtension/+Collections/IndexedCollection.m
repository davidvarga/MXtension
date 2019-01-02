classdef IndexedCollection < MXtension.Collections.Collection
    
    properties(Access = private)
        IteratorFactory;
    end
    
        %% Factories
    methods(Static)
        function list = fromCollection(collection)
            throw(MException('MXtension:UnsupportedOperationException', 'This collection type does not support this factory.'));
        end
        
        function list = ofElements(varargin)
            throw(MException('MXtension:UnsupportedOperationException', 'This collection type does not support this factory.'));
        end

    end
    
    methods
        function obj = IndexedCollection(iteratorFactory)
            obj.IteratorFactory = iteratorFactory;
        end
        
        function iterator = iterator(obj)
            iterator = MXtension.Collections.Iterators.IndexedIterator(obj.IteratorFactory());
        end
    end
end
