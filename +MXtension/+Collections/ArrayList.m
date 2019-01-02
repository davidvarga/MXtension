classdef ArrayList < MXtension.Collections.MutableList
    
    properties(Access = protected)
        CellArray;
    end
    
    %% Factories
    methods(Static)
        function list = fromCollection(collection)
            % Returns a new List containing the elements in the input collection while keeping the original order. The input collection must be the
            % type of a cell array, an instance of MXtension.Collections.List or an instance of java.util.Collection.
            
            list = MXtension.Collections.ArrayList('collection', collection);
        end
        
        function list = ofElements(varargin)
            % Returns a new List containing the elements in the input arguments keeping the argument order.
            
            list = MXtension.Collections.ArrayList('elements', varargin);
        end
    end
    
    methods(Access = protected)
        function obj = ArrayList(sourceType, source)
            if strcmp(sourceType, 'elements')
                if isempty(source)
                    obj.CellArray = {};
                else
                    obj.CellArray = source;
                end
            elseif strcmp(sourceType, 'size')
                
                if iscell(source)
                    obj.CellArray = cell(1, source{1});
                    initSelector = source{2};
                    for i = 1:numel(obj.CellArray)
                        obj.CellArray{i} = initSelector(i);
                    end
                else
                    obj.CellArray = cell(1, source);
                end
                
            elseif strcmp(sourceType, 'collection')
                if iscell(source)
                    obj.CellArray = source;
                elseif isa(source, 'MXtension.Collections.List')
                    obj.CellArray = source.toCellArray();
                elseif isa(source, 'MXtension.Collections.Collection')
                    iterator = source.iterator();
                    obj.CellArray = {};
                    while iterator.hasNext()
                        obj.CellArray{end+1} = iterator.next();
                    end
                    
                elseif isa(source, 'java.util.Collection')
                    iterator = source.iterator();
                    obj.CellArray = cell(1, source.size());
                    index = 1;
                    while iterator.hasNext()
                        obj.CellArray{index} = iterator.next();
                        index = index + 1;
                    end
                else
                    throw(MException('MXtension:IllegalArgumentException', 'The passed collection type is not supported.'));
                end
            else
                throw(MException('MXtension:IllegalArgumentException', 'The passed source type argument is invalid.'));
            end
        end
        
    end
    
    methods
        function item = get(obj, index)
            obj.verifySuppliedIndexToRetrieve(index);
            item = obj.CellArray{index};
        end
        
        function size = size(obj)
            size = numel(obj.CellArray);
        end
        
        function changed = add(obj, element)
            obj.CellArray{end+1} = element;
            changed = true;
        end
        
        function changed = insert(obj, index, element)
            obj.verifySuppliedIndexToInsert(index);
            
            obj.CellArray = [obj.take(index-1).toCellArray(), element, obj.takeLast(obj.size-index+1).toCellArray()];
            changed = true;
        end
        
        function changed = addAll(obj, collection)
            index = obj.size() + 1;
            changed = obj.insertAll(index, collection);
        end
        
        function changed = insertAll(obj, index, collection)
            obj.verifySuppliedIndexToInsert(index);
            
            listToAdd = MXtension.Collections.ArrayList.fromCollection(collection);
            if listToAdd.isEmpty()
                changed = false;
                return
            end
            
            obj.CellArray = [obj.take(index-1).toCellArray(), listToAdd.toCellArray(), obj.takeLast(obj.size-index+1).toCellArray()];
            changed = true;
        end
        
        function previous = set(obj, index, element)
            obj.verifySuppliedIndexToRetrieve(index);
            
            previous = obj.get(index);
            obj.CellArray{index} = element;
        end
        
        function removedElement = removeAt(obj, index)
            obj.verifySuppliedIndexToRetrieve(index);
            
            removedElement = obj.get(index);
            obj.CellArray(index) = [];
        end
        
        function isRemoved = remove(obj, element)
            index = obj.indexOfFirst(@(it) MXtension.equals(it, element));
            if index < 0
                isRemoved = false;
            else
                obj.removeAt(index);
                isRemoved = true;
            end
        end
        
        % TODO: removeRange
        
        function clear(obj)
            obj.CellArray = {};
        end
        
        function mutableIterator = iterator(obj)
            mutableIterator = MXtension.Collections.Iterators.MutableIteratorOfList(obj);
        end
        
        function mutableListIterator = listIterator(obj, varargin)
            mutableListIterator = MXtension.Collections.Iterators.MutableListIterator(obj, varargin{:});
        end
        
        function cellArray = toCellArray(obj)
            cellArray = obj.CellArray;
        end
    end
    
    methods
        function obj = reverse(obj)
            if (obj.isEmpty())
                return
            end
            
            ascendingIndex = 1;
            descendingIndex = obj.size();
            
            while ascendingIndex < descendingIndex
                elemAtLowerIndex = obj.get(ascendingIndex);
                obj.set(ascendingIndex, obj.get(descendingIndex));
                obj.set(descendingIndex, elemAtLowerIndex);
                ascendingIndex = ascendingIndex + 1;
                descendingIndex = descendingIndex - 1;
            end
        end
        
        % TODO: sortWith, sortBy
        
    end
    
end