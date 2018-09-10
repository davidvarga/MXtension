classdef List < handle
    % An untyped list implementation backed by a cell array.
    
    properties(Access = protected)
        CellArray;
    end
    
    %% Factories
    methods (Static)
        function list = fromCollection(collection)
            % Returns a new List containing the elements in the input collection while keeping the original order. The input collection must be the 
            % type of a cell array, an instance of MXtension.Collections.List or an instance of java.util.Collection.
            
            list = MXtension.Collections.List('collection', collection);
        end
        
        function list = ofElements(varargin)
            % Returns a new List containing the elements in the input arguments keeping the argument order.
            
            list = MXtension.Collections.List('elements', varargin);
        end
        
        function list = ofSize(size)
            % Returns a new List with the size of the input argument. All elements are null ([]) by default.
            
            list = MXtension.Collections.List('size', size);
        end
    end
    
    methods (Access = protected)
        function obj = List(sourceType, source)
            if strcmp(sourceType, 'elements')
                if isempty(source)
                    obj.CellArray = {};
                else
                    obj.CellArray = source;
                end
            elseif strcmp(sourceType, 'size')
                obj.CellArray = cell(1, source);
            elseif strcmp(sourceType, 'collection')
                if iscell(source)
                    obj.CellArray = source;
                elseif isa(source, 'MXtension.Collections.List')
                    obj.CellArray = source.toCellArray();
                elseif isa(source, 'java.util.Collection')
                    iterator = source.iterator();
                    obj.CellArray = cell(1, source.size());
                    index = 1;
                    while iterator.hasNext()
                        obj.CellArray{index} = iterator.next();
                        index = index + 1;
                    end
                else
                    % TODO: IllegalArgument (containerType)
                end
            else
                 % TODO: IllegalArgument (commandType)
            end
            
            
        end
        
    end
    
    %% List interface
    methods

        function changed = add(obj, varargin)
            % changed: logical = add(element: Any): Adds the specified element to the collection.
            % changed: logical = add(index: double, element: Any): Inserts an element into the list at the specified index.
            % Return if the list was changed as the result of the operation.
            % TODO: throws indexoutofbounds
            
            changed = true;
            if nargin < 3
                obj.CellArray{end+1} = varargin{1};
            else
                index = varargin{1};
                obj.CellArray = [obj.take(index-1).toCellArray(), varargin{2}, obj.takeLast(obj.size-index+1).toCellArray()];
               
            end
        end
        
        function changed = addAll(obj, varargin)
            % wasAdded: logical = addAll(collection: <Collection type valid for fromCollection factory>): Adds all of the elements in the specified collection elements into the end of this list.
            % wasAdded: logical = addAll(index: double, collection: <Collection type valid for fromCollection factory>): Inserts all of the elements in the specified collection elements into this list at the specified index.
            % Return if the list was changed as the result of the operation.
            % TODO: throws indexoutofbounds
            
            if nargin < 3
                listToAdd = MXtension.Collections.List.fromCollection(varargin{1});
                index = obj.size()+1;
            else
                listToAdd = MXtension.Collections.List.fromCollection(varargin{2});
                index = varargin{1};
            end
            if listToAdd.isEmpty()
                changed = false;
                return
            end
            
            obj.CellArray = [obj.take(index-1).toCellArray(), listToAdd.toCellArray(), obj.takeLast(obj.size-index+1).toCellArray()];
            changed = true;
        end
        
        function previous = set(obj, index, element)
            % previous: Any = list.set(index: double, element: Any): Replaces the element at the specified index in this list with the specified
            % element and returns the replaced element.
            % TODO: throws IndexOutOfBoundsException
            
            % TODO: require index in bounds
            previous = obj.get(index);
            obj.CellArray{index} = element;
        end
           
        function item = get(obj, index)
            % element: Any = list.get(index: double): Returns the element at the specified index in the list.
            
            item = obj.CellArray{index};
        end
        
        function index = indexOf(obj, element)
            % index: double = list.indexOf(elem: Any): Returns the index of the first occurrence of the specified element in the list, or -1 if the specified element is not contained in the list.
            
            for index = 1:obj.count()
                cElem = obj.get(index);
                if isequal(cElem, element)
                    return
                end
            end
            
            index = -1;
        end
        
        function index = lastIndexOf(obj, element)
            % index: double = list.lastIndexOf(elem: Any): Returns the index of the last occurrence of the specified element in the list, or -1 if the specified element is not contained in the list.
            
            for index = obj.size():-1:1
                cElem = obj.get(index);
                if isequal(cElem, element)
                    return
                end
            end
            
            index = -1;
        end
        
        function isEmpty = isEmpty(obj)
            % isEmpty: logical = list.isEmpty(): Returns true if this list contains no elements, false otherwise.
            
            isEmpty = obj.count() == 0;
        end
        
        function contains = contains(obj, element)
            % contains: logical = list.contains(elem: Any): Checks if the specified element is contained in this collection.
            
            contains = obj.indexOf(element) > 0;
        end
        
        function contains = containsAll(obj, collection)
            % contains: logical = list.containsAll(collection: <Collection type valid for fromCollection factory>): Checks if all elements in the specified collection are contained in this collection.
            
            MXtensionList = MXtension.Collections.List.fromCollection(collection);
            
            % TODO: Use forEach
            for i = 1:MXtensionList.size()
                if ~obj.contains(MXtensionList.get(i))
                    contains = false;
                    return
                end
            end
            contains = true;
        end
        
        function removedElement = removeAt(obj, index)
            % removedElement: Any = list.removeAt(index: double): Removes an element at the specified index from the list and returns the removed
            % element.
            % TODO: throws IndexOutOfBoundsEcxeption
            
            % TODO: Require index <= size
            removedElement = obj.get(index);
            obj.CellArray(index) = [];
        end
        
        function isRemoved = remove(obj, element)
            % isRemoved: logical = list.remove(element: Any): Removes the first occurence of the specified element if found. Returns if a matching element was removed.
            
            index = obj.indexOfFirst(@(it) isequal(it, element));
            if index < 0
                isRemoved = false;
            else
                obj.removeAt(index);
                isRemoved = true;
            end
        end
        
        function isRemoved = removeAll(obj, collectionOrPredicate)
            % isRemoved: logical = list.removeAll(collection: <Collection type valid for fromCollection factory>): Removes all occurences of all the elements in the specified collection from the list.
            % isRemoved: logical = list.removeAll(predicate: @(element: Any) -> logical): Removes all elements from this list that match the given predicate.
            % Returns if any elements was removed.
            
            if isa(collectionOrPredicate, 'function_handle')
                predicate = collectionOrPredicate;
            else
                MXtensionList = MXtension.listOf(collectionOrPredicate);
                predicate = @(elem) MXtensionList.contains(elem);
            end
            
            isRemoved = false;
            for i = obj.size():-1:1
                if predicate(obj.get(i))
                    isRemoved = true;
                    obj.removeAt(i);
                end
            end
        end
        
        function modified = retainAll(obj, collectionOrPredicate)
            % found: logical = list.retainAll(collection: <Collection type valid for fromCollection factory>): Retains only the elements in this collection that are contained in the specified collection.
            % found: logical = list.retainAll(predicate: @(element: Any) -> logical): Retains only elements of this list that match the given predicate.
            % Returns if the list was modified.
            
            if isa(collectionOrPredicate, 'function_handle')
                predicate = @(elem) ~collectionOrPredicate(elem);
            else
                MXtensionList = MXtension.listOf(collectionOrPredicate);
                predicate = @(elem) ~MXtensionList.contains(elem);
            end
            modified = obj.removeAll(@(elem) predicate(elem));
        end
        
        % TODO: removeRange
        
        function clear(obj)
            obj.CellArray = {};
        end
        
        function size = size(obj)
            size = numel(obj.CellArray);
        end
    end
    
    %% List extension functionalities
    methods
        
        
        function obj = fill(obj, value)
            obj.forEachIndexed(@(it, ind) obj.set(ind, value));
        end
        
        function obj = reverse(obj)
            if (obj.isEmpty())
                return
            end
            
            obj.CellArray = obj.reversed().toCellArray();
        end
        
        % TODO: sortWith, sortBy
        
        function forEach(obj, operation)
            for i = 1:obj.count()
                operation(obj.get(i));
            end
        end
        
        function forEachIndexed(obj, operation)
            for i = 1:obj.count()
                operation(obj.get(i), i);
            end
        end
    end
    
    %% Functional transformation operations
    methods
        
        function list = map(obj, handle)
            
            result = cell(1, obj.count());
            for i = 1:numel(obj.CellArray)
                result{i} = handle(obj.CellArray{i});
            end
            
            list = MXtension.Collections.List(result);
            
        end
        
        function list = mapIndexed(obj, transform)
            
            result = cell(1, obj.count());
            for i = 1:numel(obj.CellArray)
                result{i} = transform(obj.CellArray{i}, i);
            end
            
            list = MXtension.Collections.List(result);
        end
        
        function list = filter(obj, filterFcn)
            result = cell(1, obj.size());
            index = 0;
            
            function addIf(elem)
                if filterFcn(elem)
                    index = index + 1;
                    result{index} = elem;
                end
            end
            
            obj.forEach(@(it) addIf(it));
            
            list = MXtension.listOf(result(1:index));
        end
        
        function list = filterIndexed(obj, filterFcn)
            result = cell(1, obj.size());
            index = 0;
            
            function addIf(elem, ind)
                if filterFcn(elem, ind)
                    index = index + 1;
                    result{index} = elem;
                end
            end
            
            obj.forEachIndexed(@(it, ind) addIf(it, ind));
            
            list = MXtension.listOf(result(1:index));
        end
        
        function list = filterNot(obj, filterFcn)
            list = obj.filter(@(elem) ~filterFcn(elem));
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
        
        function list = reversed(obj)
            
            if (obj.isEmpty())
                list = MXtension.Collections.emptyCollection();
                return;
            end
            
            result = cell(1, obj.count());
            index = 1;
            for i = numel(obj.CellArray):-1:1
                result{index} = obj.CellArray{i};
                index = index + 1;
            end
            list = MXtension.Collections.List(result);
            
        end
        
        function list = takeWhile(obj, predicate)
            result = {};
            for i = 1:obj.count()
                elem = obj.get(i);
                if ~predicate(elem)
                    break
                end
                result{end+1} = elem;
            end
            
            list = MXtension.Collections.List(result);
            
        end
        
        function list = take(obj, n)
            % TODO: Require n >= 0
            if n == 0
                list = MXtension.Collections.List.ofElements();
                return
            end
            
            count = obj.count();
            
            if n >= count
                list = MXtension.Collections.List.fromCollection(obj.CellArray);
                return
            end
            
            if n == 1
                list = MXtension.Collections.List.fromCollection({obj.get(1)});
                return
            end
            
            outSize = min(n, numel(obj.CellArray));
            if outSize == 0
                list = MXtension.Collections.emptyList();
                return;
            else
                list = MXtension.Collections.List.ofSize(outSize);
                for i = 1:outSize
                    list.set(i, obj.get(i));
                end
            end
        end
        
        % takeIf
        
        % takeUnless
        
        function list = takeLast(obj, n)
            % TODO: Require n >= 0
            if n == 0
                list = MXtension.Collections.List.ofElements();
                return
            end
            
            count = obj.count();
            
            if n >= count
                list = MXtension.Collections.List.fromCollection(obj.CellArray);
                return
            end
            
            if n == 1
                list = MXtension.Collections.List.fromCollection({obj.get(count)});
                return
            end
            
            outSize = min(n, count);
         
            list = MXtension.Collections.List.ofSize(outSize);
            
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
            
            list = MXtension.Collections.List(result).reversed();
        end
        
        function list = drop(obj, n)
            if n > obj.count()
                list = MXtension.Collections.emptyCollection();
            else
                list = obj.takeLast(obj.count()-n);
            end
            
        end
        
        function list = dropLast(obj, n)
            if n > obj.count()
                list = MXtension.Collections.emptyCollection();
            else
                list = obj.take(obj.count()-n);
            end
            
        end
        
        function list = dropWhile(obj, predicate)
            yielding = false;
            
            list = MXtension.Collections.emptyCollection();
            for i = 1:obj.count()
                elem = obj.get(i);
                if yielding
                    list.add(elem);
                elseif ~predicate(elem)
                    list.add(elem)
                    yielding = true;
                end
            end
        end
        
        function list = dropLastWhile(obj, predicate)
            
            for i = obj.count():-1:1
                if ~predicate(obj.get(i))
                    list = obj.take(i);
                    return
                end
            end
            list = MXtension.Collections.emptyCollection();
            
        end
        
        function list = distinct(obj)
            list = MXtension.Collections.emptyCollection();
            for i = 1:obj.count()
                elem = obj.get(i);
                if ~list.contains(elem)
                    list.add(elem);
                end
            end
        end
        
        %         function list =  distinctBy(obj, selector)
        %             list =  MXtension.Collections.emptyCollection();
        %             for i = 1:obj.count()
        %                 elem = obj.get(i);
        %                 if ~list.contains(elem)
        %                    list.add(elem);
        %                 end
        %             end
        %         end
        
        function result = zip(obj, otherList, varargin)
            MXtensionList = MXtension.listOf(otherList);
            outSize = min(obj.size(), MXtensionList.size());
            if nargin < 3
                transform = @(it, other) MXtension.Collections.Pair(it, other);
            else
                transform = varargin{1};
            end
            result = obj.take(outSize).mapIndexed(@(it, ind) transform(it, MXtensionList.get(ind)));
        end
        
%         function chunks = chunked(obj, maxLength)
%             % TODO: preallocate
%             countOfLists = floor(obj.size() / maxLength);
%             chunks = 
%             
%             cIndex = 1;
%             for i = 1:obj.size()
%                 
%                 
%             end
%             
%         end
        
        function map = associate(obj, transformer)
            innerMap = containers.Map();
            for i = 1:obj.count()
                entry = transformer(obj.get(i));
                innerMap(entry.Key) = entry.Value;
            end
            map = MXtension.mapOf(innerMap);
        end
        
        function map = associateBy(obj, selector, varargin)
            % Always takes the last
            mapInited = false;
            innerMap = [];
            for i = 1:obj.count()
                if nargin > 2
                    valueTransform = varargin{1};
                    value = valueTransform(obj.get(i));
                else
                    value = obj.get(i);
                end
                
                key = selector(obj.get(i));
                
                if ~mapInited
                    innerMap = containers.Map('KeyType', class(key), 'ValueType', 'any');
                    mapInited = true;
                end
                innerMap(key) = value;
            end
            if ~mapInited
                innerMap = containers.Map();
            end
            
            map = MXtension.Collections.Map(innerMap);
        end
        
        function map = groupBy(obj, keySelector)
            % Always takes the last
            mapInited = false;
            innerMap = [];
            for i = 1:obj.count()
                value = obj.get(i);
                key = keySelector(obj.get(i));
                
                if ~mapInited
                    innerMap = containers.Map('KeyType', class(key), 'ValueType', 'any');
                    mapInited = true;
                end
                if ~innerMap.isKey(key)
                    innerMap(key) = MXtension.emptyList();
                end
                innerMap(key).add(value);
            end
            if ~mapInited
                innerMap = containers.Map();
            end
            
            map = MXtension.Collections.Map(innerMap);
        end
        
    end
    
    %% Functional terminal operations
    methods
        
        function elem = first(obj, varargin)
            if nargin > 1
                predicate = varargin{1};
            else
                predicate = [];
            end
            
            if obj.isEmpty()
                error('aaaa')
            end
            
            if isempty(predicate)
                elem = obj.get(1);
                return;
            else
                for i = 1:obj.count()
                    elem = obj.get(i);
                    if predicate(elem)
                        return
                    end
                end
            end
            
            error('could not find')
        end
        
        function elem = last(obj, varargin)
            if nargin > 1
                predicate = varargin{1};
            else
                predicate = [];
            end
            
            if obj.isEmpty()
                error('aaaa')
            end
            
            
            if isempty(predicate)
                elem = obj.get(obj.count());
                return;
            else
                for i = obj.count():-1:1
                    elem = obj.get(i);
                    if predicate(elem)
                        return
                    end
                end
            end
            
            error('could not find')
        end
        
        function count = count(obj, varargin)
            if nargin == 1
                count = obj.size();
            else
                predicate = varargin{1};
                count = 0;
                for i = 1:numel(obj.CellArray)
                    elem = obj.CellArray{i};
                    if predicate(elem)
                        count = count + 1;
                    end
                end
            end
        end
        
        function boolean = any(obj, predicate)
            boolean = false;
            for i = 1:obj.count()
                if predicate(obj.get(i))
                    boolean = true;
                    return
                end
            end
        end
        
        function boolean = all(obj, predicate)
            boolean = true;
            for i = 1:obj.count()
                if ~predicate(obj.get(i))
                    boolean = false;
                    return
                end
            end
        end
        
        function boolean = none(obj, predicate)
            boolean = obj.all(@(elem) ~predicate(elem));
        end
        
        function index = indexOfFirst(obj, predicate)
            for index = 1:obj.count()
                if predicate(obj.get(index))
                    return
                end
            end
            
            index = -1;
        end
        
        function index = indexOfLast(obj, predicate)
            for index = obj.count():-1:1
                if predicate(obj.get(index))
                    return
                end
            end
            
            index = -1;
        end
        
        function isNotEmpty = isNotEmpty(obj)
            isNotEmpty = ~obj.isEmpty();
        end
        
        function acc = fold(obj, initialValue, operation)
            acc = initialValue;
            for i = 1:obj.count()
                acc = operation(acc, obj.get(i));
            end
        end
        
        function acc = foldRight(obj, initialValue, operation)
            acc = initialValue;
            for i = obj.count():-1:1
                acc = operation(acc, obj.get(i));
            end
        end
        
        function str = joinToString(obj, varargin)
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
            
            str = '';
            for i = 1:numel(obj.CellArray)
                str = [str, fcn(obj.CellArray{i}), separator];
                
            end
            
            if numel(separator) && numel(str) >= numel(separator)
                str = str(1:end-numel(separator));
            end
            
            str = [prefix, str, postfix];
            
        end
        
        function cellArray = toCellArray(obj)
            cellArray = obj.CellArray;
        end
        
    end
    
    
end