classdef ArraySet < MXtension.Collections.MutableSet
    
    properties(Access = protected)
        BackingList;
    end
    
    %% Factories
    methods(Static)
        function set = fromCollection(collection)
            set = MXtension.Collections.ArraySet('collection', collection);
        end
        
        function set = ofElements(varargin)
            
            
            set = MXtension.Collections.ArraySet('elements', varargin);
        end
        
        
    end
    
    methods(Access = protected)
        function obj = ArraySet(sourceType, source)
            
            if strcmp(sourceType, 'elements')
                obj.BackingList = MXtension.Collections.ArrayList.ofElements(source{:});
            elseif strcmp(sourceType, 'collection')
                obj.BackingList = MXtension.Collections.ArrayList.fromCollection(source);
            else
                % TODO: IllegalArgument (commandType)
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
    
    %% List interface
    methods
        
        function changed = add(obj, element)
            % changed: logical = add(element: Any): Adds the specified element to the collection.
            % Return if the list was changed as the result of the operation.
            % TODO: throws indexoutofbounds
            changed = false;
            if obj.BackingList.indexOf(element) < 0
                changed = true;
                obj.BackingList.add(element);
            end
        end
        
        
        function changed = addAll(obj, collection)
            % wasAdded: logical = addAll(collection: <Collection type valid for fromCollection factory>): Adds all of the elements in the specified collection elements into the end of this list.
            % Return if the list was changed as the result of the operation.
            % TODO: throws indexoutofbounds
            
            listToAdd = MXtension.Collections.ArrayList.fromCollection(collection);
            changed = false;
            for i = 1:listToAdd.size()
                addChanged = obj.add(listToAdd.get(i));
                changed = changed || addChanged;
            end
            
            
        end
        
        
        function isRemoved = remove(obj, element)
            % isRemoved: logical = list.remove(element: Any): Removes the first occurence of the specified element if found. Returns if a matching element was removed.
            
            index = obj.BackingList.indexOfFirst(@(it) isequal(it, element));
            if index < 0
                isRemoved = false;
            else
                obj.BackingList.removeAt(index);
                isRemoved = true;
            end
        end
        
        % TODO: removeRange
        
        function clear(obj)
            % list.clear(): Removes all elements from this list.
            
            obj.BackingList.clear();
        end
        
        % TODO: SetIterator!
        function mutableIterator = iterator(obj)
            mutableIterator = obj.BackingList.iterator();
        end
        
        % Override
        function size = size(obj)
            size = obj.BackingList.size();
        end
        
        
        
    end
    
    
end
