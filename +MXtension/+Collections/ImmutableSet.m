classdef ImmutableSet < MXtension.Collections.Set

    properties(Access = protected)
        BackingList;
    end
    
    methods(Static)
        function set = fromCollection(collection)
            % Returns a new Set containing the elements in the input collection while keeping the original order. The input collection must be the
            % type of a cell array, an instance of MXtension.Collections.List or an instance of java.util.Collection.
            
            set = MXtension.Collections.ImmutableSet('collection', collection);
        end
        
        function set = ofElements(varargin)
            % Returns a new Set containing the elements in the input arguments keeping the argument order.
            
            set = MXtension.Collections.ImmutableSet('elements', varargin);
        end
    end
    
    methods(Access = protected)
        function obj = ImmutableSet(sourceType, source)
            if strcmp(sourceType, 'elements')
                obj.BackingList = MXtension.Collections.ArrayList.ofElements(source{:});
            elseif strcmp(sourceType, 'collection')
                obj.BackingList = MXtension.Collections.ArrayList.fromCollection(source);
            else
                throw(MException('MXtension:IllegalArgumentException', 'The passed source type argument is invalid.'));
            end
            mutableIterator = obj.BackingList.listIterator(obj.BackingList.size()+1);
            index = obj.BackingList.size();
            while mutableIterator.hasPrevious()
                elem = mutableIterator.previous();
                firstIndex = obj.BackingList.indexOf(elem);
                if firstIndex > 0 && index ~= firstIndex
                    mutableIterator.remove();
                    index = index - 1;
                else
                    index = index - 1;
                end
            end
        end
    end
    
    methods
        
        % Override
        function size = size(obj)
            size = obj.BackingList.size();
        end
        
        function iterator = iterator(obj)
            iterator = MXtension.Collections.Iterators.IteratorOfList(obj.BackingList);
        end
    end
    
end
