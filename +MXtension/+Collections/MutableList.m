classdef (Abstract) MutableList < MXtension.Collections.MutableCollection & MXtension.Collections.List
    
    methods(Abstract)
        % true = add(element: Any) - Adds the specified element to the end of this list. Returns true as this operation always changes the list.
        modified = add(obj, element)
        
        % changed: logical = insert(index: double, element: Any): Inserts an element into the list at the specified index.
        % Return if the list was changed as the result of the operation.
        % Throws MXtension:IndexOutOfBoundsException if the specified index is out ouf the list's boundaries.
        modified = insert(obj, index, elem)
        
        % changed: logical = insertAll(index: double, collection: <Collection type valid for fromCollection factory>): Inserts all of the elements in the specified collection elements into this list at the specified index.
        % Returns if the list was changed as the result of the operation.
        % Throws MXtension:IndexOutOfBoundsException if the specified index is out ouf the list's boundaries.
        modified = insertAll(obj, index, collection)
        
        % previous: Any = list.set(index: double, element: Any): Replaces the element at the specified index in this list with the specified
        % element and returns the replaced element.
        % Throws MXtension:IndexOutOfBoundsException if the specified index is out ouf the list's boundaries.
        previous = set(obj, index, element)
        
        % removedElement: Any = list.removeAt(index: double): Removes an element at the specified index from the list and returns the removed
        % element.
        % Throws MXtension:IndexOutOfBoundsException if the specified index is out ouf the list's boundaries.
        removedElement = removeAt(obj, index);
        
        mutableListIterator = listIterator(obj, varargin);
        
        % TODO: removeRange
        
        % list.reverse(): Reverses elements in this list in place.
        obj = reverse(obj)
    end
    
    methods
        function obj = fill(obj, value)
            % list.fill(value: Any) :Each element in the list gets replaced with the specified value.
            
            obj.forEachIndexed(@(ind, it) obj.set(ind, value));
        end
    end
end
