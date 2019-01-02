classdef MutableListIterator < MXtension.Collections.Iterators.ListIterator & MXtension.Collections.Iterators.MutableIteratorOfList
    
    
    methods
        function obj = MutableListIterator(list, varargin)
            obj@MXtension.Collections.Iterators.MutableIteratorOfList(list);
            obj@MXtension.Collections.Iterators.ListIterator(list, varargin{:});
        end
        
        function add(obj, element)
            % Adds the specified element element into the underlying collection immediately before the element that would be returned by next, if any,
            %and after the element that would be returned by previous, if any.
            % (If the collection contains no elements, the new element becomes the sole element in the collection.)
            % The new element is inserted before the implicit cursor: a subsequent call to next would be unaffected, and a subsequent call to previous would return the new element.
            %(This call increases by one the value that would be returned by a call to nextIndex or previousIndex.)
            
            obj.List.insert(obj.Index, element);
            obj.Index = obj.Index + 1;
            obj.LastIndex = [];
        end
        
        % Override
        function previous = previous(obj)
            previous = obj.previous@MXtension.Collections.Iterators.ListIterator;
            obj.LastIndex = obj.Index;
        end
        
        
        function set(obj, element)
            % Replaces the last element returned by next or previous with the specified element element.
            
            if isempty(obj.LastIndex)
                throw(MException('MXtension:IllegalStateException', 'The last index of the iterator is empty.'));
            end
            try
                obj.List.set(obj.LastIndex, element);
            catch
                throw(MException('MXtension:NoSuchElementException', ['The element on index ', num2str(obj.LastIndex), ' does not exist.']));
            end
        end
    end
end
