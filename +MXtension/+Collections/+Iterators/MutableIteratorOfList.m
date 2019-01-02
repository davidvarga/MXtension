classdef MutableIteratorOfList < MXtension.Collections.Iterators.IteratorOfList & MXtension.Collections.Iterators.MutableIterator
    
    properties(Access = protected)
        LastIndex = [];
    end
    
    methods
        function obj = MutableIteratorOfList(list)
            obj@MXtension.Collections.Iterators.IteratorOfList(list);
        end
        
        % Override
        function nextElement = next(obj)
            obj.LastIndex = obj.Index;
            nextElement = obj.next@MXtension.Collections.Iterators.IteratorOfList;
        end
        
        function obj = remove(obj)
            if isempty(obj.LastIndex)
                throw(MException('MXtension:IllegalStateException', 'The last index of the iterator is empty.'));
            end
            try
                obj.List.removeAt(obj.LastIndex);
                
                if obj.Index > obj.LastIndex
                    obj.Index = obj.Index - 1;
                end
                obj.LastIndex = [];
                
            catch
                throw(MException('MXtension:NoSuchElementException', ['The element on index ', num2str(obj.Index-1), ' does not exist.']));
            end
        end
    end
    
end
