classdef MutableListIterator < MXtension.Collections.Iterators.ListIterator & MXtension.Collections.Iterators.MutableIteratorOfList
    
    
    properties(Access = private)
        LastIndex = [];
    end
    
    methods
        function obj = MutableListIterator(list, varargin)
            obj@MXtension.Collections.Iterators.MutableIteratorOfList(list);
            obj@MXtension.Collections.Iterators.ListIterator(list, varargin{:});
            
        end
        
        function add(obj, element)
            
            obj.List.insert(obj.Index, element);
            obj.Index = obj.Index + 1;
            
        end
        
        function obj = remove(obj)
            if isempty(obj.LastIndex)
                throw(MException('MXtension:IllegalStateException', 'The last index of the iterator is empty.'));
            end
            try
                obj.List.removeAt(obj.LastIndex);
            catch
                throw(MException('MXtension:NoSuchElementException', ['The element on index ', num2str(obj.LastIndex), ' does not exist.']));
            end
        end
        
        % Override
        function nextElement = next(obj)
            obj.LastIndex = obj.Index;
            nextElement = obj.next@MXtension.Collections.Iterators.ListIterator;
            
            
        end
        
        % Override
        function previous = previous(obj)
            previous = obj.previous@MXtension.Collections.Iterators.ListIterator;
            obj.LastIndex = obj.Index;
        end
        
        
        function set(obj, element)
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
