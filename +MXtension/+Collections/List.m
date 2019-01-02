classdef (Abstract) List < MXtension.Collections.Collection
    methods(Abstract)
        
        % element: Any = list.get(index: double): Returns the element at the specified index in the list.
        % Throws MXtension:IndexOutOfBoundsException if the specified index is out ouf the list's boundaries.
        item = get(obj, index)
        
        % TODO: sortWith, sortBy
    end
    
    methods(Access = protected)
        function verifySuppliedIndexToRetrieve(obj, index)
            if ~isnumeric(index) || index < 1 || index > obj.size()
                throw(MException('MXtension:IndexOutOfBoundsException', 'The collection does not contain any element at the specified index.'));
            end
        end
        
        function verifySuppliedIndexToInsert(obj, index)
            if ~isnumeric(index) || index < 1 || index > obj.size() + 1
                throw(MException('MXtension:IndexOutOfBoundsException', 'Cannot insert on the specified index.'));
            end
        end
    end
    
    methods
        
        function iterator = iterator(obj)
            iterator = MXtension.Collections.Iterators.IteratorOfList(obj);
        end
        
        function iterator = listIterator(obj, varargin)
            % iterator: MXtension.Collections.Iterators.ListIterator = listIterator() : Returns a list iterator over the elements in this list (in proper sequence).
            %
            % iterator: MXtension.Collections.Iterators.ListIterator = listIterator(index: double) : Returns a list iterator over the elements in this list (in proper sequence), starting at the specified index.
            % Throws MXtension:IndexOutOfBoundsException if the specified index is over the the iterator boundaries: [0, size+1].
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
            % acc: Any = foldRight(initialValue: Any, operation: (accumulator: Any, element: Any) -> Any) : Accumulates value starting with initial value and applying operation from right to left to each element and current accumulator value.
            
            acc = initialValue;
            iterator = obj.listIterator(obj.size()+1);
            while iterator.hasPrevious()
                acc = operation(acc, iterator.previous());
            end
        end
        
        function acc = foldRightIndexed(obj, initialValue, operation)
            % acc: Any = foldRightIndexed(initialValue: Any, operation: (index: double, accumulator: Any, element: Any) -> Any) : Accumulates value starting with initial value and applying operation from right to left to each element with its index in the original list and current accumulator value.
            
            acc = initialValue;
            iterator = obj.listIterator(obj.size()+1);
            while iterator.hasPrevious()
                ind = iterator.previousIndex();
                acc = operation(ind, acc, iterator.previous());
            end
        end
        
        function list = dropLast(obj, n)
            % list: MXtension.Collections.List = dropLast(n: double) : Returns a list containing all elements except last n elements.
            
            if ~isnumeric(n) || n < 0
                throw(MException('MXtension:IllegalArgumentException', 'The requested element count is less than zero.'));
            end
            
            count = obj.count();
            if n > count
                list = MXtension.Collections.ImmutableList.fromCollection({});
            else
                list = MXtension.Collections.ImmutableList.fromCollection(obj.take(count-n));
            end
            
        end
        
        function list = takeLast(obj, n)
            % list: MXtension.Collections.List = takeLast(n: double) : Returns a list containing last n elements.
            
            if ~isnumeric(n) || n < 0
                throw(MException('MXtension:IllegalArgumentException', 'The requested element count is less than zero.'));
            end
            
            if n == 0
                list = MXtension.emptyList();
                return
            end
            
            count = obj.count();
            
            if n >= count
                list = MXtension.listFrom(obj);
                return
            end
            
            if n == 1
                list = MXtension.listFrom({obj.get(count)});
                return
            end
            
            outSize = min(n, count);
            
            list = MXtension.mutableListFrom(cell(1, outSize));
            
            index = 1;
            for i = count - outSize + 1:count
                list.set(index, obj.get(i));
                index = index + 1;
            end
            
            list = list.toList();
        end
        
        function list = takeLastWhile(obj, predicate)
            % list: MXtension.Collections.List = takeLastWhile(predicate: (Any) -> logical) : Returns a list containing last elements satisfying the given predicate.
            
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
            
            list = MXtension.listFrom(result).reversed();
        end
        
        function list = dropLastWhile(obj, predicate)
            % list: MXtension.Collections.List = dropLastWhile(predicate: (Any) -> logical) : Returns a list containing all elements except last elements that satisfy the given predicate.
            
            for i = obj.count():-1:1
                if ~predicate(obj.get(i))
                    list = obj.take(i);
                    return
                end
            end
            list = MXtension.emptyList();
            
        end
    end
    
    
end