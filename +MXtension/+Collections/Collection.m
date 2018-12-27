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
        function indexedCollection = withIndex(obj)
            % indexedCollection. MXtension.IndexedCollection = withIndex() : Returns a Collection of IndexedValue for each element of the original collection.
            
            indexedCollection = MXtension.Collections.IndexedCollection(@() obj.iterator());
        end
        
        function forEach(obj, action)
            % forEach(action: (Any) -> Unit): Performs the given action on each element.
            %
            % Parameters:
            %   action: Function that takes the element itself and performs the desired action on the element.
            
            iterator = obj.iterator();
            while iterator.hasNext()
                action(iterator.next());
            end
        end
        
        function forEachIndexed(obj, action)
            % forEachIndexed(action: (int, Any) -> Unit): Performs the given action on each element, providing sequential index with the element.
            %
            % Parameters:
            % 	action: Function that takes the index of an element and the element itself and performs the desired action on the element.
            
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
                if MXtension.equals(iterator.next(), element)
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
            %
            % Parameters:
            % 	predicate: Function to match the given element.
            
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
            %
            % Parameters:
            % 	predicate: Function to match the given element.
            
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
            % elem: Any = find(predicate: (Any) -> logical) : Returns the first element matching the given predicate, or null ([]) if element was not found.
            
            elem = obj.firstOrNull(predicate);
        end
        
        function elem = findLast(obj, predicate)
            % elem: Any = findLast(predicate: (Any) -> logical) : Returns the last element matching the given predicate, or null ([]) if element was not found.
            
            elem = obj.lastOrNull(predicate);
            
        end
        
        function index = indexOfFirst(obj, predicate)
            % index: double = indexOfFirst(predicate: (Any) -> logical) : Returns index of the first element matching the given predicate,
            % or -1 if the list does not contain such element.
            
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
            % lastIndex: double = indexOfLast(predicate: (Any) -> logical) : Returns index of the last element matching the given predicate, or -1 if
            % the list does not contain such element.
            
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
                
                if MXtension.equals(iterator.next(), element)
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
                if MXtension.equals(iterator.next(), element)
                    lastIndex = index;
                    
                end
                index = index + 1;
            end
            
        end
        
        
        function elem = elementAt(obj, index)
            % elem: Any = elementAt(index: double) : Returns an element at the given index or throws an MException with the id of
            % MXtension:IndexOutOfBoundsException if the index is out of bounds of this collection.
            
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
            throw(MException('MXtension:IndexOutOfBoundsException', ['The collection does not contain any element at index ', num2str(index)]));
        end
        
        function elem = elementAtOrElse(obj, index, defaultValue)
            % elem: Any = elementAtOrElse(index: double, defaultValue: (double) -> Any) : Returns an element at the given index or the result of
            % calling the defaultValue function if the index is out of bounds of this collection.
            %
            % elem: Any = elementAtOrElse(index: double, defaultValue: Any) : Returns an element at the given index or the value defined in the
            % defaultValue parameter.
            
            try
                elem = obj.elementAt(index);
            catch
                elem = obj.handleDefaultValue(defaultValue, index);
            end
        end
        
        function elem = elementAtOrNull(obj, index)
            % elem: Any = elementAtOrNull(index: double) : Returns an element at the given index or null ([]) if the index is out of bounds of this
            % collection.
            
            elem = obj.elementAtOrElse(index, []);
        end
        
        
        function list = filter(obj, predicate)
            % list: MXtension.Collections.List = filter(predicate: (Any) -> boolean) : Returns a list containing only elements matching the given predicate.
            
            result = cell(1, obj.count());
            index = 0;
            
            function addIf(elem)
                if predicate(elem)
                    index = index + 1;
                    result{index} = elem;
                end
            end
            
            obj.forEach(@(it) addIf(it));
            
            list = MXtension.listFrom(result(1:index));
        end
        
        function list = filterNot(obj, predicate)
            % list: MXtension.Collections.List = filterNot(predicate: (Any) -> boolean) : Returns a list containing only elements not matching the given predicate.
            
            list = obj.filter(@(elem) ~predicate(elem));
        end
        
        function list = filterNotNull(obj)
            % list: MXtension.Collections.List = filterNotNull() : Returns a list containing all elements that are not null ([]).
            
            list = obj.filter(@(elem) ~(MXtension.equals(elem, [])));
        end
        
        function list = filterNotEmpty(obj)
            % list: MXtension.Collections.List = filterNotEmpty() : Returns a list containing all elements that are not empty (isempty(elem) == false).
            
            list = obj.filter(@(elem) ~isempty(elem));
        end
        
        function list = filterIsInstanceOf(obj, type)
            % list: MXtension.Collections.List = filterIsInstanceOf(type: char) : Returns a list containing all elements that are istances of the given type.
            
            list = obj.filter(@(elem) isa(elem, type));
        end
        
        function list = filterIndexed(obj, predicate)
            % list: MXtension.Collections.List = filterIndexed(predicate: (double, Any) -> boolean) : Returns a list containing only elements matching the given predicate.
            %
            % Parameters:
            % 	predicate - function that takes the index of the element and the element and matches or not the element.
            
            result = cell(1, obj.count());
            index = 0;
            
            function addIf(ind, elem)
                if predicate(ind, elem)
                    index = index + 1;
                    result{index} = elem;
                end
            end
            
            obj.forEachIndexed(@(ind, it) addIf(ind, it));
            
            list = MXtension.listFrom(result(1:index));
        end
        
        function list = take(obj, n)
            % list: MXtension.Collections.List = take(n: double) : Returns a list containing first n elements if possible.
            % Throws MXtension:IllegalArgumentException if the passed argument is smaller than zero or not a number.

            if ~isnumeric(n) || n < 0
                throw(MException('MXtension:IllegalArgumentException', 'The requested element count is less than zero.'));
            end
            
            if n == 0
                list = MXtension.emptyList();
                return
            end
            
            count = obj.count();
            
            if n >= count
                list = obj.toList();
                return
            end
            
            if n == 1
                list = MXtension.listOf(obj.first());
                return
            end
            
            outSize = min(n, count);
            if outSize == 0
                list = MXtension.emptyList();
                return;
            else
                list = MXtension.mutableListFrom(cell(1,outSize));
                iterator = obj.iterator();
                outCount = 0;
                while iterator.hasNext()
                    if outCount == n
                        break
                    end
                    outCount = outCount + 1;
                    
                    list.set(outCount, iterator.next());
                end
                list = list.toList();
            end
        end
        
        function list = takeWhile(obj, predicate)
            % list: MXtension.Collections.List = takeWhile(predicate: (Any) -> logical) : Returns a list containing first elements satisfying the given predicate.
            
            iterator = obj.iterator();
            index = 0;
            result = cell(1, obj.count());
            while iterator.hasNext()
                elem = iterator.next();
                if ~predicate(elem)
                    break
                end
                index = index + 1;
                result{index} = elem;
            end
            
            list = MXtension.listFrom(result(1:index));
        end
        
        function list = drop(obj, n)
            % list: MXtension.Collections.List = drop(n: double) : Returns a list containing all elements except first n elements.
            % Throws MXtension:IllegalArgumentException if the passed argument is smaller than zero or not a number.
            
            if ~isnumeric(n) || n < 0
                throw(MException('MXtension:IllegalArgumentException', 'The requested element count is less than zero.'));
            end
            
            count = obj.count();
            if n > count
                list = MXtension.emptyList();
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
                
                list = MXtension.listFrom(result);
            end
        end
        
        function list = dropWhile(obj, predicate)
            % list: MXtension.Collections.List = dropWhile(predicate: (Any) -> logial) : Returns a list containing all elements except first elements that satisfy the given predicate.
            
            yielding = false;
            
            iterator = obj.iterator();
            
            objIndex = 1;
            index = 1;
            result = [];
            while iterator.hasNext()
                elem = iterator.next();
                if yielding
                    result{index} = elem; %#ok<AGROW>
                    index = index + 1;
                elseif ~predicate(elem)
                    result = cell(1, obj.count()-objIndex+1);
                    result{index} = elem;
                    
                    yielding = true;
                    index = index + 1;
                end
                
                objIndex = objIndex + 1;
            end
            
            if ~iscell(result)
                list = MXtension.emptyList();
            else
                list = MXtension.listFrom(result);
            end
            
        end
        
        function acc = fold(obj, initialValue, operation)
            % acc: Any = fold(initialValue: A, operation: (A, Any) -> A) : Accumulates value starting with initial value and applying operation from
            % left to right to current accumulator value and each element.
            %
            % Parameters:
            %   initialValue - The initial accumulated value with any type.
            %   operation - Function that takes the current accumulated value and the current element as arguments and produces the new accumulated
            %   value.
            
            acc = initialValue;
            iterator = obj.iterator();
            while iterator.hasNext()
                acc = operation(acc, iterator.next());
            end
        end
        
        function acc = foldIndexed(obj, initialValue, operation)
            % acc: Any = foldIndexed(initialValue: A, operation: (double, A, Any) -> A) : Accumulates value starting with initial value and applying
            % operation from left to right to current accumulator value and each element with its index in the original collection.
            %
            % Parameters:
            %   initialValue - The initial accumulated value with any type.
            %   operation - Function that takes the index of the current element, the current accumulated value and the current element as arguments
            %       and produces the new accumulated value.
            
            acc = initialValue;
            iterator = obj.iterator();
            index = 1;
            while iterator.hasNext()
                acc = operation(index, acc, iterator.next());
                index = index + 1;
            end
        end
        
        function list = map(obj, transform)
            % list: MXtension.Collections.List = map(transform: (Any) -> Any) : Returns a list containing the results of applying the given transform
            % function to each element in the original collection.
            
            result = cell(1, obj.count());
            iterator = obj.iterator();
            index = 1;
            while iterator.hasNext()
                result{index} = transform(iterator.next());
                index = index + 1;
            end
            
            list = MXtension.listFrom(result);
        end
        
        function list = mapNotNull(obj, transform)
            % list: MXtension.Collections.List = mapNotNull(transform: (Any) -> Any) : Returns a list containing only the non-null results of applying
            % the given transform function to each element in the original collection.
            
            list = MXtension.mutableListOf();
            
            iterator = obj.iterator();
            
            while iterator.hasNext()
                next = transform(iterator.next());
                if ~MXtension.equals(next, [])
                    list.add(next);
                end
            end
            
            list = list.toList();
        end
        
        function list = mapNotEmpty(obj, transform)
            % list: MXtension.Collections.List = mapNotEmpty(transform: (Any) -> Any) : Returns a list containing only the non-empty (~isempty(..)) results of applying
            % the given transform function to each element in the original collection.
            
            list = MXtension.mutableListOf();
            
            iterator = obj.iterator();
            
            while iterator.hasNext()
                next = transform(iterator.next());
                if ~isempty(next)
                    list.add(next);
                end
            end
            
            list = list.toList();
        end
        
        function list = mapIndexed(obj, transform)
            % list: MXtension.Collections.List = mapIndexed(transform: (double, Any) -> Any) : Returns a list containing the results of applying the
            % given transform function to each element and its index in the original collection.
            %
            % Parameters:
            %   transform - function that takes the index of an element and the element itself and returns the result of the transform applied to the element.
            
            result = cell(1, obj.count());
            iterator = obj.iterator();
            index = 1;
            while iterator.hasNext()
                result{index} = transform(index, iterator.next());
                index = index + 1;
            end
            
            list = MXtension.listFrom(result);
        end
        
        function list = flatMap(obj, transform)
            % list: MXtension.Collections.List = flatMap(transform: (Any) -> MXtension.Collections.Collection) : Returns a single list of all elements
            % yielded from results of transform function being invoked on each element of original collection.
            %
            % Parameters:
            %   transform - function that takes the element and returns a collection of any type.
            
            iterator = obj.iterator();
            list = MXtension.mutableListOf();
            while iterator.hasNext()
                list.addAll(transform(iterator.next()));
            end
            
            list = list.toList();
        end
        
        function list = flatten(obj)
            % list: MXtension.Collections.List = flatten() : Returns a single list of all elements from all collections in the given collection.
            % The elements of this collection must be instaces of MXtension.Collections.Collection.
            
            iterator = obj.iterator();
            list = MXtension.mutableListOf();
            while iterator.hasNext()
                list.addAll(iterator.next());
            end
            
            
            list = list.toList();
        end
        
        function set = intersect(obj, collection)
            % set: MXtension.Collections.Set = intersect(collection: <Collection type valid for fromCollection factory>) : Returns a set containing all elements that are
            % contained by both this set and the specified collection.
            % The returned set preserves the element iteration order of the original collection.
            % The equality check is performed using MXtension.equals().
            
            mutableSet = obj.toMutableSet();
            mutableSet.retainAll(collection);
            set = mutableSet.toSet();
        end
        
        function list = distinct(obj)
            % list: list: MXtension.Collections.List = distinct() : Returns a list containing only distinct elements from the given collection.
            % The elements in the resulting list are in the same order as they were in the source collection.
            % The equality check is performed using MXtension.equals().
            
            list = obj.toSet().toList();
        end
        
        function pairOfLists = partition(obj, predicate)
            % pairOfLists: MXtension.Pair<MXtension.Collections.List, MXtension.Collections.List> = partition(predicate: (Any) -> logical) :
            % Splits the original collection into pair of lists, where first list contains elements for which predicate yielded true, while second
            % list contains elements for which predicate yielded false.
            
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
            
            pairOfLists = MXtension.Pair(MXtension.listFrom(first(1:firstIndex)), MXtension.listFrom(second(1:secondIndex)));
        end
        
        function listOfPairs = zip(obj, otherCollection, varargin)
            % listOfPairs: MXtension.Colllections.List<MXtension.Pair> = zip(otherCollection: <Collection type valid for fromCollection factory>) : Returns a list 
            % of pairs built from the elements of this collection and other collection with the same index.
            % The returned list has length of the shortest collection and each element is an MXtension.Pair instance, where the element in the First 
            % property is the element from the first collection and the element in the Second property is the element from the second collection.
            %
            % list: MXtension.Colllections.List = zip(otherCollection: <Collection type valid for fromCollection factory>, transform: (Any, Any) -> Any) : 
            % Returns a list of values built from the elements of this collection and the other collection with the same index using the provided transform function 
            % applied to each pair of elements.
            % The returned list has length of the shortest collection.
            %
            % Parameters:
            %   otherCollection - any collection type valid for fromCollection factory
            %   transform - function that takes the current element from the first collection and the element on the same index from the other
            %   collection and produces the value in the zipped collection.

            if nargin < 3
                transform = @(first, second) MXtension.Pair(first, second);
            else
                transform = varargin{1};
            end
            
            otherCollection = obj.fromCollection(otherCollection);
            
            firstIterator = obj.iterator();
            otherIterator = otherCollection.iterator();
            
            result = cell(1, min(obj.count(), otherCollection.count()));
            index = 1;
            while firstIterator.hasNext() && otherIterator.hasNext()
                result{index} = transform(firstIterator.next(), otherIterator.next());
                index = index + 1;
            end
            
            listOfPairs = MXtension.Collections.ImmutableList.fromCollection(result);
        end
        
        
        function map = associate(obj, transformer)
            % map: MXtension.Collections.Map = associate(transformer: (Any) -> MXtension.Pair) : Returns a Map containing key-value pairs provided by 
            % transform function applied to elements of the given collection.
            % If any of two pairs would have the same key the last one gets added to the map.
            % The returned map preserves the entry iteration order of the original collection.
            
            innerMap = containers.Map();
            iterator = obj.iterator();
            keyType = '';
            while iterator.hasNext()
                pair = transformer(iterator.next());
                if isempty(keyType)
                    keyType = class(pair.First);
                    innerMap = containers.Map('KeyType', keyType, 'ValueType', 'any');
                end
                innerMap(pair.First) = pair.Second;
            end
            map = MXtension.mapFrom(innerMap);
        end
        
        function map = associateWith(obj, valueTransform)
            % map: MXtension.Collections.Map = associateWith(valueTransform: (Any) -> Any) : Returns a Map where keys are elements from the given 
            % collection and values are produced by the valueTransform function applied to each character.
            % If any two characters are equal, the last one gets added to the map.
            % The returned map preserves the entry iteration order of the original char sequence.
            
            map = obj.associate(@(it) MXtension.Pair(it, valueTransform(it)));
        end
        
        function map = associateBy(obj, keySelector, varargin)
            % map: MXtension.Collections.Map = associateBy(keySelector: (Any) -> Any) : Returns a Map containing the elements from the given 
            % collection indexed by the key returned from keySelector function applied to each element.
            % If any two elements would have the same key returned by keySelector the last one gets added to the map.
            % The returned map preserves the entry iteration order of the original collection.
            %
            % map: MXtension.Collections.Map = associateBy(obj, keySelector: (Any) -> Any, valueTransform: (Any) -> Any) : Returns a Map containing 
            % the values provided by valueTransform and indexed by keySelector functions applied to elements of the given collection.
            % If any two elements would have the same key returned by keySelector the last one gets added to the map.
            % The returned map preserves the entry iteration order of the original collection.

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
                
                key = keySelector(element);
                
                if ~mapInited
                    innerMap = containers.Map('KeyType', class(key), 'ValueType', 'any');
                    mapInited = true;
                end
                innerMap(key) = value;
            end
            if ~mapInited
                innerMap = containers.Map();
            end
            
            map = MXtension.mapFrom(innerMap);
        end
        
        function map = groupBy(obj, keySelector, varargin)
            % map: MXtension.Collections.Map<Any, MXtension.Collections.List> = groupBy(keySelector: Any -> Any) : Groups elements of the original 
            % collection by the key returned by the given keySelector function applied to each element and returns a map where each group key is 
            % associated with a list of corresponding elements.
            % The returned map preserves the entry iteration order of the keys produced from the original collection.
            %
            % map: MXtension.Collections.Map<Any, MXtension.Collections.List> = groupBy(keySelector: Any -> Any, valueTransform: (Any) -> Any) : 
            % Groups values returned by the valueTransform function applied to each element of the original collection by the key returned by the 
            % given keySelector function applied to the element and returns a map where each group key is associated with a list of corresponding values.
            % The returned map preserves the entry iteration order of the keys produced from the original collection.
            
            mapInited = false;
            innerMap = [];
            iterator = obj.iterator();
            
            while iterator.hasNext()
                next = iterator.next();
                if nargin > 2
                    valueTransform = varargin{1};
                    value = valueTransform(next);
                else
                    value = next;
                end
               
                key = keySelector(next);
                
                if ~mapInited
                    innerMap = containers.Map('KeyType', class(key), 'ValueType', 'any');
                    mapInited = true;
                end
                if ~innerMap.isKey(key)
                    innerMap(key) = MXtension.mutableListOf();
                end
                innerMap(key).add(value);
            end
            if ~mapInited
                innerMap = containers.Map();
            end
            
            keys = innerMap.keys();
            for iKey = 1:numel(keys)
               elem = innerMap(keys{iKey});
               innerMap(keys{iKey}) = elem.toList();
            end
            
            map = MXtension.mapFrom(innerMap);
        end
        
        function list = reversed(obj)
            % list: MXtension.Collections.List = reversed(): Returns a list with elements in reversed order.
            
            list = obj.toMutableList();
            list.reverse();
            list = list.toList();
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
        
        function list = toList(obj)
            % list: MXtension.Collections.List = toList() : Returns a read-only list containing the elements returned by this enumeration in the order
            % they are returned by the enumeration.
            
            list = MXtension.Collections.ImmutableList.fromCollection(obj);
        end
        
        function list = toMutableList(obj)
            % list: MXtension.Collections.MutableList = toMutableList() : Returns a MutableList filled with all elements of this collection.
            
            list = MXtension.Collections.ArrayList.fromCollection(obj);
        end
        
        function set = toSet(obj)
            % set: MXtension.Collections.Set = toSet() : Returns a Set of all elements.
            % The returned set preserves the element iteration order of the original collection.
            
            set = MXtension.Collections.ImmutableSet.fromCollection(obj);
        end
        
        function set = toMutableSet(obj)
            % set: MXtension.Collections.MutableSet = toMutableSet() : Returns a mutable set containing all distinct elements from the given collection.
            % The returned set preserves the element iteration order of the original collection.
            
            set = MXtension.Collections.ArraySet.fromCollection(obj);
        end
        
        function cellArray = toCellArray(obj)
            % cellArray: cell-array = toCellArray() : Returns a cell-array with the dimension of 1xN, where N is the size of this collection, 
            % filled with all elements of this collection.
            
            cellArray = obj.toList().toCellArray();
        end
        
        
    end
    
    
end
