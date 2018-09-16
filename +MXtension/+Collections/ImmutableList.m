classdef ImmutableList < MXtension.Collections.List
    % An untyped list implementation backed by a cell array.
    
    properties(Access = protected)
        CellArray;
    end
    
    %% Factories
    methods(Static)
        function list = fromCollection(collection)
            % Returns a new List containing the elements in the input collection while keeping the original order. The input collection must be the
            % type of a cell array, an instance of MXtension.Collections.List or an instance of java.util.Collection.
            
            list = MXtension.Collections.ImmutableList('collection', collection);
        end
        
        function list = ofElements(varargin)
            % Returns a new List containing the elements in the input arguments keeping the argument order.
            
            list = MXtension.Collections.ImmutableList('elements', varargin);
        end
        
        function list = ofSize(size, varargin)
            % Returns a new List with the size of the input argument. All elements are null ([]) by default.
            if nargin > 1
                list = MXtension.Collections.ImmutableList('size', {size, varargin{1}});
            else
                list = MXtension.Collections.ImmutableList('size', size);
            end
            
        end
    end
    
    methods(Access = protected)
        function obj = ImmutableList(sourceType, source)
            if strcmp(sourceType, 'elements')
                if isempty(source)
                    obj.CellArray = {};
                else
                    obj.CellArray = source;
                end
            elseif strcmp(sourceType, 'size')
                
                if iscell(source)
                    obj.CellArray = cell(1, source{1});
                    initSelector = source{2};
                    for i = 1:numel(obj.CellArray)
                        obj.CellArray{i} = initSelector(i);
                    end
                else
                    obj.CellArray = cell(1, source);
                end
                
            elseif strcmp(sourceType, 'collection')
                if iscell(source)
                    obj.CellArray = source;
                elseif isa(source, 'MXtension.Collections.List')
                    obj.CellArray = source.toCellArray();
                elseif isa(source, 'MXtension.Collections.Iterable')
                    iterator = source.iterator();
                    obj.CellArray = {};
                    while iterator.hasNext()
                        obj.CellArray{end+1} = iterator.next();
                    end
                    
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
        
        function arrayListIterator = iterator(obj)
            arrayListIterator = MXtension.Collections.ArrayListIterator(obj);
        end
        
        function arrayListReverseIterator = reverseIterator(obj)
            arrayListReverseIterator = MXtension.Collections.ArrayListReverseIterator(obj);
        end
        
        
        function item = get(obj, index)
            % element: Any = list.get(index: double): Returns the element at the specified index in the list.
            % TODO: throws IndexOutOfBoundsException
            
            item = obj.CellArray{index};
        end
        
        
        function size = size(obj)
            % size: double = list.size(): Returns the number of elements in this list.
            size = numel(obj.CellArray);
        end
    end
    
    %% Functional transformation operations
    methods
        
        
        function list = takeWhile(obj, predicate)
            result = {};
            for i = 1:obj.count()
                elem = obj.get(i);
                if ~predicate(elem)
                    break
                end
                result{end+1} = elem;
            end
            
            list = MXtension.Collections.ArrayList(result);
            
        end
        
        
        % takeIf
        
        % takeUnless
        
        function list = takeLast(obj, n)
            % TODO: Require n >= 0
            if n == 0
                list = MXtension.Collections.ArrayList.ofElements();
                return
            end
            
            count = obj.count();
            
            if n >= count
                list = MXtension.Collections.ArrayList.fromCollection(obj.CellArray);
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
        
        
    end
    
    %% Functional terminal operations
    methods
        
        
        %         function elem = last(obj, varargin)
        %             if nargin > 1
        %                 predicate = varargin{1};
        %             else
        %                 predicate = [];
        %             end
        %
        %             if obj.isEmpty()
        %                 error('aaaa')
        %             end
        %
        %
        %             if isempty(predicate)
        %                 elem = obj.get(obj.size());
        %                 return;
        %             else
        %                 for i = obj.count():-1:1
        %                     elem = obj.get(i);
        %                     if predicate(elem)
        %                         return
        %                     end
        %                 end
        %             end
        %
        %             error('could not find')
        %         end
        
        
        function cellArray = toCellArray(obj)
            cellArray = obj.CellArray;
        end
        
    end
    
    
end