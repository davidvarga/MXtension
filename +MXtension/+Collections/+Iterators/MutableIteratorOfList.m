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
                % TODO: throw NoSuchElementException
                error('IllegalState')
            end
        end
    end
    
end
