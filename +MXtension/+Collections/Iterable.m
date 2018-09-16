classdef (Abstract) Iterable < handle
    
    
    methods(Abstract)
        iterator = iterator(obj)
    end
    
    methods
        function indexingIterable = withIndex(obj)
            indexingIterable = MXtension.Collections.IndexingIterable(obj.iterator());
        end
        
        function forEach(obj, operation)
            iterator = obj.iterator();
            while iterator.hasNext()
                operation(iterator.next());
            end
        end
        
        function forEachIndexed(obj, operation)
            index = 1;
            iterator = obj.iterator();
            while iterator.hasNext()
                operation(iterator.next(), index);
                index = index + 1;
            end
        end
        
        function contains = contains(obj, element)
            % contains: logical = collection.contains(elem: Any): Checks if the specified element is contained in this collection.
            
            contains = true;
            iterator = obj.iterator();
            while iterator.hasNext()
                if isequal(iterator.next(), element)
                    
                    return
                end
            end
            contains = false;
            
            
        end
        
        function count = count(obj, varargin)
            if nargin == 1
                if isa(obj, 'MXtension.Collections.Collection')
                    count = obj.size();
                else
                    count = 0;
                    iterator = obj.iterator();
                    while iterator.hasNext()
                        iterator.next();
                        count = count + 1;
                    end
                end
                
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
        
        function elem = first(obj, varargin)
            if nargin > 1
                predicate = varargin{1};
            else
                predicate = [];
            end
            
            
            if isempty(predicate)
                
                elem = obj.iterator().next();
                
                return;
            else
                iterator = obj.iterator();
                while iterator.hasNext()
                    if predicate(iterator.next())
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
            
            
            if isempty(predicate)
                iterator = obj.iterator();
                if ~iterator.hasNext()
                    error('NoSuchElement: Empty Collection')
                end
                elem = iterator.next();
                while iterator.hasNext()
                    
                    elem = iterator.next();
                    
                    
                end
            else
                iterator = obj.iterator();
                if ~iterator.hasNext()
                    error('NoSuchElement: Empty Collection')
                end
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
                    error('NoSuchElement: No matching element')
                end
                
                
            end
            
            
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
        
        
        function boolean = any(obj, predicate)
            boolean = false;
            iterator = obj.iterator();
            while iterator.hasNext()
                if predicate(iterator.next())
                    boolean = true;
                    return
                end
            end
        end
        
        function boolean = all(obj, predicate)
            boolean = true;
            iterator = obj.iterator();
            while iterator.hasNext()
                if ~predicate(iterator.next())
                    boolean = false;
                    return
                end
            end
        end
        
        function boolean = none(obj, predicate)
            boolean = obj.all(@(elem) ~predicate(elem));
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
        
        
        function map = associate(obj, transformer)
            innerMap = containers.Map();
            iterator = obj.iterator();
            while iterator.hasNext()
                entry = transformer(iterator.next());
                innerMap(entry.Key) = entry.Value;
            end
            map = MXtension.Collections.Map(innerMap);
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
            
            map = MXtension.Collections.Map(innerMap);
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
            
            map = MXtension.Collections.Map(innerMap);
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
        
        function cellArray = toCellArray(obj)
            cellArray = obj.toList().toCellArray();
        end
        
        
    end
    
    
end
