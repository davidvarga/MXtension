classdef ListIterator < MXtension.Collections.Iterators.IteratorOfList
    
    
    methods
        function obj = ListIterator(list, varargin)
            obj@MXtension.Collections.Iterators.IteratorOfList(list);
            
            if nargin > 1 && (~isnumeric(varargin{1}) || varargin{1} < 1 || varargin{1} > list.size() + 1)
                throw(MException('MXtension:IndexOutOfBoundsException', 'The collection does not contain any element at the specified index.'));
            end
            
            if nargin > 1
                obj.Index = varargin{1};
            end
        end
        
        function hasPrevious = hasPrevious(obj)
            % Returns true if there are elements in the iteration before the current element.
            
            try
                obj.List.get(obj.Index-1);
                hasPrevious = true;
            catch
                hasPrevious = false;
            end
        end
        
        function previousElement = previous(obj)
            % Returns the previous element in the iteration and moves the cursor position backwards.
            
            try
                previousElement = obj.List.get(obj.Index-1);
                obj.Index = obj.Index - 1;
                
            catch
                throw(MException('MXtension:NoSuchElementException', 'The requested element cannot be found.'));
            end
        end
        
        function nextIndex = nextIndex(obj)
            % Returns the index of the element that would be returned by a subsequent call to next.
            
            nextIndex = obj.Index;
        end
        
        function previousIndex = previousIndex(obj)
            % Returns the index of the element that would be returned by a subsequent call to previous.
            
            previousIndex = obj.Index - 1;
        end
    end
end
