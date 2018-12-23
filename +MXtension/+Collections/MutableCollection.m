classdef (Abstract) MutableCollection < MXtension.Collections.Collection
    
    methods(Abstract)
        % changed: logical = add(element: Any): Adds the specified element to the collection.
        % Return if the list was changed as the result of the operation.
        changed = add(obj, element);
        
        % changed: logical = addAll(collection: <Collection type valid for fromCollection factory) - Adds all of the elements of the specified collection to the end of this list.
        % The elements are appended in the order they appear in the collection collection.
        % Returns: true if the collection was changed as the result of the operation.
        changed = addAll(obj, collection);
        
        % isRemoved: logical = remove(element: Any) Removes a single instance of the specified element from this collection, if it is present. Returns
        % true if the element was removed, false if the element was not present.
        isRemoved = remove(obj, element);
        
        % clear() : Removes all elements from this collection.
        clear(obj); 
        
    end
    
    methods
        function isRemoved = removeAll(obj, collectionOrPredicate)
            % isRemoved: logical = list.removeAll(collection: <Collection type valid for fromCollection factory>): Removes all occurences of all the elements in the specified collection from the list.
            % isRemoved: logical = list.removeAll(predicate: (element: Any) -> logical): Removes all elements from this list that match the given predicate.
            % Returns if any elements was removed.
            
            if isa(collectionOrPredicate, 'function_handle')
                predicate = collectionOrPredicate;
            else
                MXtensionCollection = obj.fromCollection(collectionOrPredicate);
                predicate = @(elem) MXtensionCollection.contains(elem);
            end
            iterator = obj.iterator();
            isRemoved = false;
            while iterator.hasNext()
                n = iterator.next();
                if predicate(n)
                    isRemoved = true;
                    iterator.remove();
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
                MXtensionCollection = obj.fromCollection(collectionOrPredicate);
                predicate = @(elem) ~MXtensionCollection.contains(elem);
            end
            modified = obj.removeAll(@(elem) predicate(elem));
        end
        
        
    end
end
