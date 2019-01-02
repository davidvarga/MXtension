classdef ArraySet < MXtension.Collections.MutableSet
    
    properties(Access = protected)
        BackingList;
    end
    
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
        function changed = add(obj, element)
            changed = false;
            if obj.BackingList.indexOf(element) < 0
                changed = true;
                obj.BackingList.add(element);
            end
        end
        
        function changed = addAll(obj, collection)
            listToAdd = MXtension.Collections.ArrayList.fromCollection(collection);
            changed = false;
            for i = 1:listToAdd.size()
                addChanged = obj.add(listToAdd.get(i));
                changed = changed || addChanged;
            end
        end
        
        function isRemoved = remove(obj, element)
            isRemoved = obj.BackingList.remove(element);
        end
        
        function clear(obj)
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
