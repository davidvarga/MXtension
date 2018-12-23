classdef (Abstract) MutableList < MXtension.Collections.MutableCollection & MXtension.Collections.List

    methods(Abstract)
        % true = add(element: Any) - Adds the specified element to the end of this list. Returns true as this operation always changes the list.
        modified = add(obj, element)

        modified = insert(obj, index, elem)
        modified = insertAll(obj, index, collection)
        previous = set(obj, index, element)
        removedElement = removeAt(obj, index)
        mutableListIterator = listIterator(obj, varargin);
        % TODO: removeRange
        
        obj = reverse(obj)
    end
    
    methods
        

        
        function obj = fill(obj, value)
            % list.fill(value: Any) :Each element in the list gets replaced with the specified value.
            
            obj.forEachIndexed(@(ind, it) obj.set(ind, value));
        end
        
        
    end
end
