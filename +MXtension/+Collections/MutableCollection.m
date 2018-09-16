classdef (Abstract) MutableCollection < MXtension.Collections.Collection & MXtension.Collections.MutableIterator
    
    
    methods(Abstract)
        changed = add(obj, element);
        changed = addAll(obj, collection);
        isRemoved = remove(obj, element)
        clear(obj)
        
    end
    
    methods
        function isRemoved = removeAll(obj, collectionOrPredicate)
            % isRemoved: logical = list.removeAll(collection: <Collection type valid for fromCollection factory>): Removes all occurences of all the elements in the specified collection from the list.
            % isRemoved: logical = list.removeAll(predicate: @(element: Any) -> logical): Removes all elements from this list that match the given predicate.
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
                MXtensionList = obj.fromCollection(collectionOrPredicate);
                predicate = @(elem) ~MXtensionList.contains(elem);
            end
            modified = obj.removeAll(@(elem) predicate(elem));
        end
        
        
    end
end
