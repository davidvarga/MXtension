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
            try
                obj.List.removeAt(obj.LastIndex);
                %    obj.Index = obj.Index - 1;
            catch
                % TODO: throw NoSuchElementException
                error('IllegalState')
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
                error('IllegalState')
            end
            obj.List.set(obj.LastIndex, element);
        end
    end
end
