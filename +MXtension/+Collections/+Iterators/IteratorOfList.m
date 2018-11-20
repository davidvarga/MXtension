classdef IteratorOfList < MXtension.Collections.Iterators.Iterator
    
    properties(Access = protected)
        List = [];
        Index = 1;
        
    end
    
    methods
        function obj = IteratorOfList(list)
            % TODO: throw error if class is worng
            obj.List = list;
            
        end
        
        function hasNext = hasNext(obj)
            try
                obj.List.get(obj.Index);
                hasNext = true;
            catch
                hasNext = false;
                
            end
        end
        function nextElement = next(obj)
            try
                nextElement = obj.List.get(obj.Index);
                obj.Index = obj.Index + 1;
            catch
               throw(MException('MXtension:NoSuchElementException', 'The requested element cannot be found.'));
            end
        end
        
        
    end
end
