classdef MutableIteratorOfList < MXtension.Collections.Iterators.IteratorOfList & MXtension.Collections.Iterators.MutableIterator
    
    methods
        function obj = MutableIteratorOfList(list)
            obj@MXtension.Collections.Iterators.IteratorOfList(list);
            
        end
        
        function obj = remove(obj)
            try
                obj.List.removeAt(obj.Index-1);
                obj.Index = obj.Index - 1;
            catch
                throw(MException('MXtension:NoSuchElementException', ['The element on index ', num2str(obj.Index-1), ' does not exist.']));
            end
        end
    end
    
end
