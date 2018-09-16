classdef (Abstract) Collection < MXtension.Collections.Iterable
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    methods(Static, Abstract)
        list = fromCollection(collection)
        list = ofElements(varargin)
        list = ofSize(size, varargin)
    end
    
    
    methods(Abstract)
        
        iterator = reverseIterator(obj);
        
        
        size = size(obj)
        
        
        %         collection = filter(obj, predicate)
        
        
        indexed = takeLast(obj, n)
        indexed = takeLastWhile(obj, predicate)
        indexed = dropLast(obj, n)
        indexed = dropLastWhile(obj, predicate)
        list = takeWhile(obj, predicate) % list !!!
        
        list = drop(obj, n) % list !!!
        list = dropWhile(obj, predicate) % list !!!
        list = distinct(obj) % list !!!
        % function list =  distinctBy(obj, selector)
        listOfPairs = zip(obj, otherCollection, varargin)
        % function chunks = chunked(obj, maxLength)
        
        
        cellArray = toCellArray(obj)
    end
    
    methods
        function isEmpty = isEmpty(obj)
            % isEmpty: logical = list.isEmpty(): Returns true if this list collection no elements, false otherwise.
            
            isEmpty = obj.size() == 0;
        end
        
        function isNotEmpty = isNotEmpty(obj)
            isNotEmpty = ~obj.isEmpty();
        end
        
        
        function contains = containsAll(obj, collection)
            % contains: logical = list.containsAll(collection: <Collection type valid for fromCollection factory>): Checks if all elements in the specified collection are contained in this collection.
            
            MXtensionCollection = obj.fromCollection(collection);
            iterator = MXtensionCollection.iterator();
            % TODO: Use forEach
            while iterator.hasNext()
                if ~obj.contains(iterator.next())
                    contains = false;
                    return
                end
            end
            contains = true;
        end
        
        
        function acc = foldRight(obj, initialValue, operation)
            acc = obj.foldWithIterator(initialValue, operation, obj.reverseIterator());
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
