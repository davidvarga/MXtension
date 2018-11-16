classdef (Abstract) Collection < handle
    
    % TODO: associateByTo
    % TODO: associateTo
    % TODO: associateWithTo
    % TODO: chunked
    % TODO: distinctBy
    % TODO: filterIndexedTo
    % TODO: filterIsTypeOfTo
    % TODO: filterTo
    % TODO: filterNotNullTo
    % TODO: filterNotEmptyTo
    % TODO: flatMapTo
    % TODO: groupByTo
    % TODO: mapNotNullTo
    % TODO: mapTo
    % TODO: mapIndexedTo
    % TODO: mapIndexedNotNull
    % TODO: mapIndexedNotNullTo
    % TODO: maxBy
    % TODO: maxWith
    % TODO: minBy
    % TODO: minWith
    % TODO: minus
    % TODO: minusElement
    
    % Not implementable: average
    
    
    methods(Abstract)
        iterator = iterator(obj)
    end
    
    methods(Static, Abstract)
        collection = fromCollection(collection)
        collection = ofElements(varargin)
    end
    
    methods(Access = protected)
        function defValue = handleDefaultValue(obj, default, index)
            if isa(default, 'function_handle')
                defValue = default(index);
            else
                defValue = default;
            end
        end
    end
    
    methods
        function indexingIterable = withIndex(obj)
            indexingIterable = MXtension.Collections.IndexedCollection(obj.iterator());
        end
        
        function forEach(obj, action)
            % forEach(action: (Any) -> Unit): Performs the given action on each element.
            %
            %   Parameters:
            %       action: Function that takes the element itself and performs the desired action on the element.
            
            iterator = obj.iterator();
            while iterator.hasNext()
                action(iterator.next());
            end
        end
        
        function forEachIndexed(obj, action)
            % forEachIndexed(action: (int, Any) -> Unit): Performs the given action on each element, providing sequential index with the element.
            %
            %   Parameters:
            %       action: Function that takes the index of an element and the element itself and performs the desired action on the element.
            
            index = 1;
            iterator = obj.iterator();
            while iterator.hasNext()
                action(index, iterator.next());
                index = index + 1;
            end
        end
        
        function contains = contains(obj, element)
            % contains: logical = contains(elem: Any): Checks if the specified element is contained in this collection.
            
            contains = true;
            iterator = obj.iterator();
            while iterator.hasNext()
                if isequal(iterator.next(), element)
                    return
                end
            end
            contains = false;
        end
        
        function contains = containsAll(obj, collection)
            % contains: logical = list.containsAll(collection: <See input argument of fromCollection factory>): Checks if all elements in the
            % specified collection are contained in this collection.
            
            MXtensionCollection = obj.fromCollection(collection);
            iterator = MXtensionCollection.iterator();
            while iterator.hasNext()
                if ~obj.contains(iterator.next())
                    contains = false;
                    return
                end
            end
            contains = true;
        end
        
        function size = size(obj)
            % size: double = size() : Returns the size of the collection.
            
            size = 0;
            iterator = obj.iterator();
            while iterator.hasNext()
                iterator.next();
                size = size + 1;
            end
        end
        
        function count = count(obj, varargin)
            % count: double = count() : Returns the number of elements in this collection.
            %
            % count: double = count(predicate: (Any) -> logical) : Returns the number of elements matching the given predicate.
            %   Parameters:
            %       predicate: Function to match the given element.
            
            if nargin == 1
                count = obj.size();
            else
                predicate = varargin{1};
                count = 0;
                iterator = obj.iterator();
                while iterator.hasNext()
                    if predicate(iterator.next())
                        count = count + 1;
                    end
                end
            end
        end
        
        function any = any(obj, varargin)
            % any: logical = any() : Returns true if collection has at least one element.
            %
            % any: logical = any(predicate: (Any) -> logical) : Returns true if at least one element matches the given predicate.
            %   Parameters:
            %       predicate: Function to match the given element.
            
            if nargin == 1
                any = obj.isNotEmpty();
                return;
            end
            any = false;
            iterator = obj.iterator();
            predicate = varargin{1};
            while iterator.hasNext()
                if predicate(iterator.next())
                    any = true;
                    return
                end
            end
        end
        
        function all = all(obj, predicate)
            % all: logical = all(predicate: (Any) -> logical) : Returns true if all elements match the given predicate.
            %   Parameters:
            %       predicate: Function to match the given element.
            
            all = true;
            iterator = obj.iterator();
            while iterator.hasNext()
                if ~predicate(iterator.next())
                    all = false;
                    return
                end
            end
        end
        
        function none = none(obj, varargin)
            % none: logical = none() : Returns true if collection has no elements.
            %
            % none: logical = none(predicate: (Any) -> logical) : Returns true if no element matches the given predicate.
            %   Parameters:
            %       predicate: Function to match the given element.
            
            if nargin == 1
                none = obj.isEmpty();
                return
            end
            predicate = varargin{1};
            none = obj.all(@(elem) ~predicate(elem));
        end
        
        function isEmpty = isEmpty(obj)
            % isEmpty: logical = isEmpty(): Returns true if this collection has no elements, false otherwise.
            
            isEmpty = obj.size() == 0;
        end
        
        function isNotEmpty = isNotEmpty(obj)
            % isNotEmpty: logical = isNotEmpty(): Returns true if this collection has at least one element, false otherwise.
            
            isNotEmpty = ~obj.isEmpty();
        end
        
        
        function elem = first(obj, varargin)
            % elem: Any = first() : Returns first element.
            %
            % Throws:
            %   MXtension:NoSuchElementException - if the collection is empty.
            %
            % elem: Any = first(predicate: (Any) -> logical) : Returns the first element matching the given predicate.
            %
            % Throws:
            %   MXtension:NoSuchElementException - if no such element is found.
            
            if nargin > 1
                predicate = varargin{1};
            else
                predicate = [];
            end
            
            iterator = obj.iterator();
            if ~iterator.hasNext()
                throw(MException('MXtension:NoSuchElementException', 'The collection is empty.'))
            end
            
            if isempty(predicate)
                elem = iterator.next();
                return;
            else
                
                while iterator.hasNext()
                    elem = iterator.next();
                    if predicate(elem)
                        return
                    end
                end
            end
            
            throw(MException('MXtension:NoSuchElementException', 'No element matches the given predicate.'))
        end
        
        function elem = firstOrNull(obj, varargin)
            % elem: Any = firstOrNull() : Returns the first element, or null ([]) if the list is empty.
            %
            % elem: Any = firstOrNull(predicate: (Any) -> logical) : Returns the first element matching the given predicate, or null ([]) if element was not found.
            
            try
                elem = obj.first(varargin{:});
            catch
                elem = [];
            end
        end
        
        function elem = last(obj, varargin)
            % elem: Any = last() : Returns the last element.
            %
            % Throws:
            %   MXtension:NoSuchElementException - if the collection is empty.
            %
            % elem: Any = last(predicate: (Any) -> logical) : Returns the last element matching the given predicate.
            %
            % Throws:
            %   MXtension:NoSuchElementException - if no such element is found.
            
            if nargin > 1
                predicate = varargin{1};
            else
                predicate = [];
            end
            iterator = obj.iterator();
            if ~iterator.hasNext()
                throw(MException('MXtension:NoSuchElementException', 'The collection is empty.'))
            end
            
            if isempty(predicate)
                
                elem = iterator.next();
                while iterator.hasNext()
                    elem = iterator.next();
                end
            else
                elem = [];
                found = false;
                while iterator.hasNext()
                    temp = iterator.next();
                    if predicate(temp)
                        found = true;
                        elem = temp;
                    end
                end
                
                if ~found
                    throw(MException('MXtension:NoSuchElementException', 'No element matches the given predicate.'))
                end
            end
        end
        
        function elem = lastOrNull(obj, varargin)
            % elem: Any = lastOrNull() : Returns the last element, or null ([]) if the list is empty.
            %
            % elem: Any = lastOrNull(predicate: (Any) -> logical) : Returns the last element matching the given predicate, or null ([]) if element was not found.
            try
                elem = obj.last(varargin{:});
            catch
                elem = [];
            end
            
        end
        
        
        function elem = find(obj, predicate)
            elem = obj.firstOrNull(predicate);
            
        end
        
        function elem = findLast(obj, predicate)
            elem = obj.lastOrNull(predicate);
            
        end
        
        function index = indexOfFirst(obj, predicate)
            
            
            iterator = obj.iterator();
            index = 1;
            while iterator.hasNext()
                if predicate(iterator.next())
                    return
                end
                index = index + 1;
            end
            
            index = -1;
        end
        
        function lastIndex = indexOfLast(obj, predicate)
            iterator = obj.iterator();
            lastIndex = -1;
            index = 1;
            while iterator.hasNext()
                if predicate(iterator.next())
                    lastIndex = index;
                    
                end
                index = index + 1;
            end
            
            
        end
        
        function index = indexOf(obj, element)
            % index: double = list.indexOf(elem: Any): Returns the index of the first occurrence of the specified element in the list, or -1 if the specified element is not contained in the list.
            
            iterator = obj.iterator();
            index = 1;
            while iterator.hasNext()
                
                if isequal(iterator.next(), element)
                    return
                end
                index = index + 1;
            end
            
            index = -1;
        end
        
        function lastIndex = lastIndexOf(obj, element)
            % index: double = list.indexOf(elem: Any): Returns the index of the first occurrence of the specified element in the list, or -1 if the specified element is not contained in the list.
            
            iterator = obj.iterator();
            lastIndex = -1;
            index = 1;
            while iterator.hasNext()
                if isequal(iterator.next(), element)
                    lastIndex = index;
                    
                end
                index = index + 1;
            end
            
        end
        
        
        function elem = elementAt(obj, index)
            iterator = obj.iterator();
            count = 1;
            while (iterator.hasNext())
                next = iterator.next();
                if count == index
                    elem = next;
                    return
                end
                count = count + 1;
            end
            
            error('TODO: IndexOutOfBounds')
        end
        
        function elem = elementAtOrElse(obj, index, defaultValue)
            try
                elem = obj.elementAt(index);
            catch
                elem = obj.handleDefaultValue(defaultValue, index);
            end
        end
        
        function elem = elementAtOrNull(obj, index)
            elem = obj.elementAtOrElse(index, []);
        end
        
        
        function list = filter(obj, predicate)
            result = cell(1, obj.count());
            index = 0;
            
            function addIf(elem)
                if predicate(elem)
                    index = index + 1;
                    result{index} = elem;
                end
            end
            
            obj.forEach(@(it) addIf(it));
            
            list = MXtension.Collections.ArrayList.fromCollection(result(1:index));
        end
        
        function list = filterNot(obj, predicate)
            list = obj.filter(@(elem) ~predicate(elem));
        end
        
        function list = filterNotNull(obj)
            list = obj.filter(@(elem) ~(isnumeric(elem) && isequal(elem, [])));
        end
        
        function list = filterNotEmpty(obj)
            list = obj.filter(@(elem) ~isempty(elem));
        end
        
        function list = filterIsTypeOf(obj, type)
            list = obj.filter(@(elem) isa(elem, type));
        end
        
        function list = filterIndexed(obj, predicate)
            result = cell(1, obj.count());
            index = 0;
            
            function addIf(elem, ind)
                if predicate(elem, ind)
                    index = index + 1;
                    result{index} = elem;
                end
            end
            
            obj.forEachIndexed(@(it, ind) addIf(it, ind));
            
            list = MXtension.Collections.ArrayList.fromCollection(result(1:index));
        end
        
        %%%%%% TODO %%%%%%%%%%
        function list = take(obj, n)
            % TODO: Require n >= 0
            if n == 0
                list = MXtension.Collections.ArrayList.ofSize(0);
                return
            end
            
            count = obj.count();
            
            if n >= count
                list = obj.toList();
                return
            end
            
            if n == 1
                list = MXtension.Collections.ArrayList.fromCollection({obj.first()});
                return
            end
            
            outSize = min(n, count);
            if outSize == 0
                list = MXtension.Collections.ArrayList.ofSize(0);
                return;
            else
                list = MXtension.Collections.ArrayList.ofSize(outSize);
                iterator = obj.iterator();
                outCount = 0;
                while iterator.hasNext()
                    if outCount == n
                        break
                    end
                    outCount = outCount + 1;
                    
                    list.set(outCount, iterator.next());
                end
            end
        end
        
        function list = takeWhile(obj, predicate)
            
            iterator = obj.iterator();
            index = 1;
            result = cell(1, obj.count());
            while iterator.hasNext()
                elem = iterator.next();
                if ~predicate(elem)
                    break
                end
                result{index} = elem;
                index = index + 1;
            end
            
            list = MXtension.Collections.ImmutableList.fromCollection(result);
        end
        
        function list = drop(obj, n)
            count = obj.count();
            if n > count
                list = MXtension.Collections.ImmutableList.fromCollection({});
            else
                iterator = obj.iterator();
                index = 1;
                counter = 1;
                result = cell(1, obj.count()-n);
                while iterator.hasNext()
                    elem = iterator.next();
                    if counter <= n
                        counter = counter + 1;
                    else
                        result{index} = elem;
                        index = index + 1;
                    end
                    
                    
                end
                
                list = MXtension.Collections.ImmutableList.fromCollection(result);
            end
            
        end
        
        function list = dropWhile(obj, predicate)
            yielding = false;
            
            
            iterator = obj.iterator();
            
            objIndex = 1;
            index = 1;
            while iterator.hasNext()
                elem = iterator.next();
                if yielding
                    result{index} = elem;
                    index = index + 1;
                elseif ~predicate(elem)
                    result = cell(1, obj.count()-objIndex+1);
                    result{index} = elem;
                    
                    yielding = true;
                    index = index + 1;
                end
                
                objIndex = objIndex + 1;
                
            end
            list = MXtension.Collections.ImmutableList.fromCollection(result);
        end
        
        
        function acc = fold(obj, initialValue, operation)
            
            acc = initialValue;
            iterator = obj.iterator();
            while iterator.hasNext()
                acc = operation(acc, iterator.next());
            end
        end
        
        function acc = foldIndexed(obj, initialValue, operation)
            
            acc = initialValue;
            iterator = obj.iterator();
            index = 1;
            while iterator.hasNext()
                acc = operation(acc, index, iterator.next());
                index = index + 1;
            end
        end
        
        function list = map(obj, handle)
            
            result = cell(1, obj.count());
            iterator = obj.iterator();
            index = 1;
            while iterator.hasNext()
                result{index} = handle(iterator.next());
                index = index + 1;
            end
            
            
            list = MXtension.Collections.ArrayList.fromCollection(result);
            
        end
        
        function list = mapNotNull(obj, handle)
            
            list = MXtension.mutableListOf();
            
            
            result = cell(1, obj.count());
            iterator = obj.iterator();
            
            while iterator.hasNext()
                next = handle(iterator.next());
                if ~isequal(next, [])
                    list.add(next);
                end
                
            end
            
        end
        
        function mutableSet = intersect(obj, iterable)
            mutableSet = obj.toMutableSet();
            mutableSet.retainAll(iterable);
            
        end
        
        function pairOfLists = partition(obj, predicate)
            
            first = cell(1, obj.size());
            firstIndex = 0;
            second = cell(1, obj.size());
            secondIndex = 0;
            
            iterator = obj.iterator();
            while iterator.hasNext()
                elem = iterator.next();
                if predicate(elem)
                    firstIndex = firstIndex + 1;
                    first{firstIndex} = elem;
                else
                    secondIndex = secondIndex + 1;
                    second{secondIndex} = elem;
                end
            end
            
            pairOfLists = MXtension.Pair(MXtension.listFromCollection(first(1:firstIndex)), ...
                MXtension.listFromCollection(second(1:secondIndex)));
        end
        
        function list = mapIndexed(obj, transform)
            
            result = cell(1, obj.count());
            iterator = obj.iterator();
            index = 1;
            while iterator.hasNext()
                result{index} = transform(iterator.next(), index);
                index = index + 1;
            end
            
            list = MXtension.Collections.ArrayList.fromCollection(result);
        end
        
        function list = flatMap(obj, transform)
            iterator = obj.iterator();
            list = MXtension.mutableListOf();
            while iterator.hasNext()
                list.addAll(transform(iterator.next()));
            end
            
            
            list = list.toList();
        end
        
        function list = flatten(obj)
            iterator = obj.iterator();
            list = MXtension.mutableListOf();
            while iterator.hasNext()
                list.addAll(iterator.next());
            end
            
            
            list = list.toList();
        end
        
        
        function map = associate(obj, transformer)
            innerMap = containers.Map();
            iterator = obj.iterator();
            keyType = '';
            while iterator.hasNext()
                
                entry = transformer(iterator.next());
                if isempty(keyType)
                    keyType = class(entry.Key);
                    innerMap = containers.Map('KeyType', keyType, 'ValueType', 'any');
                end
                innerMap(entry.Key) = entry.Value;
            end
            map = MXtension.Collections.ImmutableMap.fromMap(innerMap);
        end
        
        function map = associateWith(obj, valueSelector)
            map = obj.associate(@(it) MXtension.Collections.Entry(it, valueSelector(it)));
            
        end
        
        
        function map = associateBy(obj, selector, varargin)
            % Always takes the last
            mapInited = false;
            innerMap = [];
            iterator = obj.iterator();
            while iterator.hasNext()
                element = iterator.next();
                if nargin > 2
                    valueTransform = varargin{1};
                    value = valueTransform(element);
                else
                    value = element;
                end
                
                key = selector(element);
                
                if ~mapInited
                    innerMap = containers.Map('KeyType', class(key), 'ValueType', 'any');
                    mapInited = true;
                end
                innerMap(key) = value;
            end
            if ~mapInited
                innerMap = containers.Map();
            end
            
            map = MXtension.Collections.ImmutableMap.fromMap(innerMap);
        end
        
        function map = groupBy(obj, keySelector)
            % Always takes the last
            mapInited = false;
            innerMap = [];
            iterator = obj.iterator();
            while iterator.hasNext()
                value = iterator.next();
                key = keySelector(value);
                
                if ~mapInited
                    innerMap = containers.Map('KeyType', class(key), 'ValueType', 'any');
                    mapInited = true;
                end
                if ~innerMap.isKey(key)
                    innerMap(key) = MXtension.Collections.listOf();
                end
                innerMap(key).add(value);
            end
            if ~mapInited
                innerMap = containers.Map();
            end
            
            map = MXtension.Collections.ImmutableMap.fromMap(innerMap);
        end
        
        function list = distinct(obj)
            list = obj.toSet().toList();
        end
        % TODO!
        %         function list = distinctBy(obj, selector)
        %
        %
        %             list = obj.toSet().toList();
        %         end
        
        function listOfPairs = zip(obj, otherIterable, varargin)
            if nargin < 3
                transform = @(first, second) MXtension.Pair(first, second);
            else
                transform = varargin{1};
            end
            
            firstIterator = obj.iterator();
            otherIterator = otherIterable.iterator();
            
            result = cell(1, min(obj.count(), otherIterable.count()));
            index = 1;
            while firstIterator.hasNext() && otherIterator.hasNext()
                result{index} = transform(firstIterator.next(), otherIterator.next());
                index = index + 1;
            end
            
            listOfPairs = MXtension.Collections.ImmutableList.fromCollection(result);
            
        end
        
        function str = joinToChar(obj, varargin)
            prefix = '';
            postfix = '';
            fcn = @(elem) elem;
            separator = '';
            if nargin == 2 && isa(varargin{1}, 'function_handle')
                fcn = varargin{1};
            elseif nargin == 2 && isa(varargin{1}, 'char')
                separator = varargin{1};
            elseif nargin == 3
                if isa(varargin{2}, 'function_handle')
                    fcn = varargin{2};
                else
                    prefix = varargin{2};
                end
                
                separator = varargin{1};
            elseif nargin == 4
                if isa(varargin{2}, 'function_handle')
                    fcn = varargin{2};
                else
                    prefix = varargin{2};
                end
                if isa(varargin{3}, 'function_handle')
                    fcn = varargin{3};
                else
                    postfix = varargin{3};
                end
                separator = varargin{1};
            elseif nargin == 5
                prefix = varargin{2};
                postfix = varargin{3};
                fcn = varargin{4};
                separator = varargin{1};
            else
                error('asdasd')
            end
            
            str = obj.fold('', @(acc, e) [acc, fcn(e), separator]);
            
            
            if numel(separator) && numel(str) >= numel(separator)
                str = str(1:end-numel(separator));
            end
            
            str = [prefix, str, postfix];
            
        end
        
        function list = reversed(obj)
            
            list = obj.toList();
            list.reverse();
            
            
        end
        
        function list = toList(obj)
            list = MXtension.Collections.ImmutableList.fromCollection(obj);
        end
        
        function list = toMutableList(obj)
            list = MXtension.Collections.ArrayList.fromCollection(obj);
        end
        
        function set = toSet(obj)
            set = MXtension.Collections.ImmutableSet.fromCollection(obj);
        end
        
        function set = toMutableSet(obj)
            set = MXtension.Collections.ArraySet.fromCollection(obj);
        end
        
        function cellArray = toCellArray(obj)
            cellArray = obj.toList().toCellArray();
        end
        
        
    end
    
    
end
