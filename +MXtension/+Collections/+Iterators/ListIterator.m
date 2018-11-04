classdef ListIterator < MXtension.Collections.Iterators.IteratorOfList
    
    
    methods
        function obj = ListIterator(list, varargin)
            % TODO: throw error if class is worng
            obj@MXtension.Collections.Iterators.IteratorOfList(list);
            if nargin > 1
                obj.Index = varargin{1};
            end
            
        end
        
        
        function hasPrevious = hasPrevious(obj)
            try
                obj.List.get(obj.Index-1);
                hasPrevious = true;
            catch
                hasPrevious = false;
                
            end
        end
        
        function previousElement = previous(obj)
            try
                previousElement = obj.List.get(obj.Index-1);
                obj.Index = obj.Index - 1;
                
            catch
                % TODO: throw NoSuchElementException
                error('NoSuchElementException')
            end
        end
        
        function nextIndex = nextIndex(obj)
            
            if obj.hasNext()
                nextIndex = obj.Index;
            else
                nextIndex = obj.Index - 1;
            end
        end
        
        function previousIndex = previousIndex(obj)
            
            if obj.hasPrevious()
                previousIndex = obj.Index - 1;
            else
                previousIndex = obj.Index;
            end
        end
        
        
    end
end
