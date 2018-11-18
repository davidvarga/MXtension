classdef (Abstract) List < MXtension.Collections.Collection
    % Typeless list interface.
    
    methods(Static, Abstract)
        list = ofSize(size, varargin)
    end
    
    methods(Abstract)
        item = get(obj, index)

        % TODO: sortWith, sortBy
    end
    
    methods
        
        function iterator = iterator(obj)
            iterator = MXtension.Collections.Iterators.IteratorOfList(obj);
        end
        
        function iterator = listIterator(obj, varargin)
            iterator = MXtension.Collections.Iterators.ListIterator(obj, varargin{:});
        end
        
        
        % Override
        function index = indexOfLast(obj, predicate)
            for index = obj.count():-1:1
                if predicate(obj.get(index))
                    return
                end
            end
            
            index = -1;
        end
        
        
        % Override
        function index = lastIndexOf(obj, element)
            % index: double = list.lastIndexOf(elem: Any): Returns the index of the last occurrence of the specified element in the list, or -1 if the specified element is not contained in the list.
            
            for index = obj.size():-1:1
                cElem = obj.get(index);
                if MXtension.equals(cElem, element)
                    return
                end
            end
            
            index = -1;
        end
        
        % Override
        function elem = elementAt(obj, index)
            elem = obj.get(index);
        end
        
        % Override
        function elem = elementAtOrElse(obj, index, defaultValue)
            if index > 0 && index <= obj.size()
                elem = obj.get(index);
            else
                elem = obj.handleDefaultValue(defaultValue, index);
            end
        end
        
        function acc = foldRight(obj, initialValue, operation)
            acc = obj.foldWithIterator(initialValue, operation, obj.reverseIterator());
        end
        
        function list = dropLast(obj, n)
            count = obj.count();
            if n > count
                list = MXtension.Collections.ImmutableList.fromCollection({});
            else
                list = MXtension.Collections.ImmutableList.fromCollection(obj.take(count-n));
            end
            
        end
        
        
        function list = takeLast(obj, n)
            % TODO: Require n >= 0
            if n == 0
                list = MXtension.Collections.ArrayList.ofElements();
                return
            end
            
            count = obj.count();
            
            if n >= count
                list = MXtension.Collections.ArrayList.fromCollection(obj);
                return
            end
            
            if n == 1
                list = MXtension.Collections.ArrayList.fromCollection({obj.get(count)});
                return
            end
            
            outSize = min(n, count);
            
            list = MXtension.Collections.ArrayList.ofSize(outSize);
            
            index = 1;
            for i = count - outSize + 1:count
                list.set(index, obj.get(i));
                index = index + 1;
                
            end
        end
        
        function list = takeLastWhile(obj, predicate)
            result = {};
            index = 1;
            for i = obj.count():-1:1
                elem = obj.get(i);
                if ~predicate(elem)
                    break
                end
                result{index} = elem;
                index = index + 1;
            end
            
            list = MXtension.Collections.ArrayList(result).reversed();
        end
        
        
        function list = dropLastWhile(obj, predicate)
            
            for i = obj.count():-1:1
                if ~predicate(obj.get(i))
                    list = obj.take(i);
                    return
                end
            end
            list = MXtension.Collections.emptyList();
            
        end        
    end
    
    methods(Access = private, Static)
        function acc = foldWithIterator(initialValue, operation, iterator)
            acc = initialValue;
            
            while iterator.hasNext()
                acc = operation(acc, iterator.next());
            end
        end
    end
    
end