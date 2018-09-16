classdef ArrayList < MXtension.Collections.ImmutableList & MXtension.Collections.MutableList
    % An untyped list implementation backed by a cell array.
    
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
        
        function list = ofSize(size)
            % Returns a new List with the size of the input argument. All elements are null ([]) by default.
            
            list = MXtension.Collections.ArrayList('size', size);
        end
    end
    
    methods(Access = protected)
        function obj = ArrayList(sourceType, source)
            obj@MXtension.Collections.ImmutableList(sourceType, source)
        end
        
    end
    
    %% List interface
    methods
        
        function changed = add(obj, element)
            % changed: logical = add(element: Any): Adds the specified element to the collection.
            % Return if the list was changed as the result of the operation.
            % TODO: throws indexoutofbounds
            
            
            obj.CellArray{end+1} = element;
            changed = true;
            
        end
        
        function changed = insert(obj, index, element)
            % changed: logical = insert(index: double, element: Any): Inserts an element into the list at the specified index.
            % Return if the list was changed as the result of the operation.
            % TODO: throws indexoutofbounds
            
            changed = true;
            obj.CellArray = [obj.take(index-1).toCellArray(), element, obj.takeLast(obj.size-index+1).toCellArray()];
        end
        
        
        function changed = addAll(obj, collection)
            % wasAdded: logical = addAll(collection: <Collection type valid for fromCollection factory>): Adds all of the elements in the specified collection elements into the end of this list.
            % Return if the list was changed as the result of the operation.
            % TODO: throws indexoutofbounds
            
            index = obj.size() + 1;
            changed = obj.insertAll(index, collection);
            
        end
        
        function changed = insertAll(obj, index, collection)
            % changed: logical = insertAll(index: double, collection: <Collection type valid for fromCollection factory>): Inserts all of the elements in the specified collection elements into this list at the specified index.
            % Returns if the list was changed as the result of the operation.
            % TODO: throws indexoutofbounds
            
            
            listToAdd = MXtension.Collections.ArrayList.fromCollection(collection);
            if listToAdd.isEmpty()
                changed = false;
                return
            end
            
            obj.CellArray = [obj.take(index-1).toCellArray(), listToAdd.toCellArray(), obj.takeLast(obj.size-index+1).toCellArray()];
            changed = true;
        end
        
        function previous = set(obj, index, element)
            % previous: Any = list.set(index: double, element: Any): Replaces the element at the specified index in this list with the specified
            % element and returns the replaced element.
            % TODO: throws IndexOutOfBoundsException
            
            % TODO: require index in bounds
            previous = obj.get(index);
            obj.CellArray{index} = element;
        end
        
        
        function removedElement = removeAt(obj, index)
            % removedElement: Any = list.removeAt(index: double): Removes an element at the specified index from the list and returns the removed
            % element.
            % TODO: throws IndexOutOfBoundsEcxeption
            
            % TODO: Require index <= size
            removedElement = obj.get(index);
            obj.CellArray(index) = [];
        end
        
        function isRemoved = remove(obj, element)
            % isRemoved: logical = list.remove(element: Any): Removes the first occurence of the specified element if found. Returns if a matching element was removed.
            
            index = obj.indexOfFirst(@(it) isequal(it, element));
            if index < 0
                isRemoved = false;
            else
                obj.removeAt(index);
                isRemoved = true;
            end
        end
        
        % TODO: removeRange
        
        function clear(obj)
            % list.clear(): Removes all elements from this list.
            
            obj.CellArray = {};
        end
        
    end
    
    %% List extension functionalities
    methods
        
        
        function obj = reverse(obj)
            % list.reverse(): Reverses elements in this list in place.
            
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