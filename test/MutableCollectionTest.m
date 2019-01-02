classdef (Abstract) MutableCollectionTest < CollectionTest & matlab.unittest.TestCase
    
    
    methods(Access = protected, Sealed)
        function mustBeIterator(obj, iterator)
            obj.assertTrue(isa(iterator, 'MXtension.Collections.Iterators.Iterator'));
            obj.assertTrue(isa(iterator, 'MXtension.Collections.Iterators.MutableIterator'));
        end
        
        
    end
    
    methods(Test)
        
        function mutableIterator_on_empty_collection(testCase)
            collection = testCase.ofElements();
            
            try
                collection.iterator().remove();
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalStateException');
                testCase.assertEqual(ex.message, 'The last index of the iterator is empty.');
            end
            
        end
        
        function mutableIterator_on_nonempty_collection(testCase)
            collection = testCase.ofElements(1, 2, 3, 4);
            it = collection.iterator();
            try
                it.remove();
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalStateException');
                testCase.assertEqual(ex.message, 'The last index of the iterator is empty.');
            end
            testCase.assertEqual(it.next(), 1);
            it.remove();
            testCase.assertEqual(collection.size(), 3);
            try
                it.remove();
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalStateException');
                testCase.assertEqual(ex.message, 'The last index of the iterator is empty.');
            end
            testCase.assertEqual(it.next(), 2);
            testCase.assertEqual(it.next(), 3);
            it.remove();
            testCase.assertEqual(collection.size(), 2);
            try
                it.remove();
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalStateException');
                testCase.assertEqual(ex.message, 'The last index of the iterator is empty.');
            end
            testCase.assertEqual(it.next(), 4);
            it.remove();
            testCase.assertEqual(collection.size(), 1);
            testCase.assertFalse(it.hasNext());
            it = collection.iterator();
            testCase.assertEqual(it.next(), 2);
            it.remove();
            testCase.assertEqual(collection.size(), 0);
            try
                it.remove();
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalStateException');
                testCase.assertEqual(ex.message, 'The last index of the iterator is empty.');
            end
        end
        
        function add_element_to_empty_collection(testCase)
            assertCollection('test_entry');
            assertCollection(1);
            assertCollection(struct());
            
            function assertCollection(testEntry)
                collection = testCase.ofElements();
                result = collection.add(testEntry);
                testCase.assertEqual(collection.size(), 1);
                testCase.assertTrue(result);
                testCase.assertEqual(collection.iterator().next(), testEntry);
            end
        end
        
        function add_same_element_to_collection_twice(testCase)
            collection = testCase.ofElements();
            testEntry = 'test_entry';
            result = collection.add(testEntry);
            testCase.assertTrue(result);
            result = collection.add(testEntry);
            testCase.assertTrue(result);
            testCase.assertEqual(collection.size(), 2);
            iterator = collection.iterator();
            testCase.assertEqual(iterator.next(), testEntry);
            testCase.assertEqual(iterator.next(), testEntry);
        end
        
        function addAll_with_empty_parameter(testCase)
            collection = testCase.ofElements();
            changed = collection.addAll(testCase.ofElements());
            testCase.assertFalse(changed);
            testCase.assertEqual(collection.size(), 0);
        end
        
        function addAll_unique_elements(testCase)
            collection = testCase.ofElements();
            changed = collection.addAll(testCase.ofElements(1, 2, 3));
            testCase.assertTrue(changed);
            testCase.assertElementsFromOneUntil(collection, 3);
        end
        
        function clear_empty_collection(testCase)
            collection = testCase.ofElements();
            collection.clear();
            testCase.assertEqual(collection.size(), 0);
        end
        
        function clear_any_collection(testCase)
            collection = testCase.ofElements(1, 2, 3);
            collection.clear();
            testCase.assertEqual(collection.size(), 0);
        end
        
        function remove_from_empty_collection(testCase)
            collection = testCase.ofElements();
            changed = collection.remove('a');
            testCase.assertFalse(changed);
            testCase.assertEqual(collection.size(), 0);
        end
        
        function remove_not_existing_element(testCase)
            collection = testCase.ofElements(1, 2, 3);
            changed = collection.remove(4);
            testCase.assertFalse(changed);
            testCase.assertElementsFromOneUntil(collection, 3);
        end
        
        function remove_elements_one_by_one_from_end(testCase)
            collection = testCase.ofElements(1, 2, 3);
            changed = collection.remove(3);
            testCase.assertTrue(changed);
            testCase.assertElementsFromOneUntil(collection, 2);
            changed = collection.remove(2);
            testCase.assertTrue(changed);
            testCase.assertElementsFromOneUntil(collection, 1);
            changed = collection.remove(1);
            testCase.assertTrue(changed);
            testCase.assertEqual(collection.size(), 0);
        end
        
        function remove_elements_one_by_one_from_start(testCase)
            collection = testCase.ofElements(1, 2, 3);
            changed = collection.remove(1);
            testCase.assertTrue(changed);
            testCase.assertElementsFromOneUntilWithOffset(collection, 2, 2);
            changed = collection.remove(2);
            testCase.assertTrue(changed);
            testCase.assertElementsFromOneUntilWithOffset(collection, 1, 3);
            changed = collection.remove(3);
            testCase.assertTrue(changed);
            testCase.assertEqual(collection.size(), 0);
        end
        
        function removeAll_with_collection_from_empty_collection(testCase)
            collecstionsToRemove = {testCase.ofElements(1, 2, 3), ...
                testCase.javaListOf(1, 2, 3), ...
                testCase.javaSetOf(10, 20, 30), ...
                {'a', 'b', 'c'}};
            
            for i = 1:numel(collecstionsToRemove)
                collection = testCase.ofElements();
                changed = collection.removeAll(collecstionsToRemove{i});
                testCase.assertFalse(changed);
                testCase.assertEqual(collection.size(), 0);
            end
        end
        
        function removeAll_with_collection_of_not_existent_elements(testCase)
            collecstionsToRemove = {testCase.ofElements(1, 2, 3), ...
                testCase.javaListOf(1, 2, 3), ...
                testCase.javaSetOf(10, 20, 30), ...
                {'a', 'b', 'c'}};
            
            for i = 1:numel(collecstionsToRemove)
                collection = testCase.ofElements(100, 101, 102, 103);
                changed = collection.removeAll(collecstionsToRemove{i});
                testCase.assertFalse(changed);
                testCase.assertElementsFromOneUntilWithOffset(collection, 4, 100);
            end
        end
        
        function removeAll_with_empty_collection(testCase)
            collecstionsToRemove = {testCase.ofElements(), ...
                testCase.javaListOf(), ...
                testCase.javaSetOf(), ...
                {}};
            
            for i = 1:numel(collecstionsToRemove)
                collection = testCase.ofElements(100, 101, 102, 103);
                changed = collection.removeAll(collecstionsToRemove{i});
                testCase.assertFalse(changed);
                testCase.assertElementsFromOneUntilWithOffset(collection, 4, 100);
            end
        end
        
        function removeAll_with_collection_containing_exactly_every_element(testCase)
            collecstionsToRemove = {testCase.ofElements(1, 2, 3), ...
                testCase.javaListOf(3, 2, 1), ...
                testCase.javaSetOf(1, 2, 3), ...
                {2, 1, 3}};
            
            for i = 1:numel(collecstionsToRemove)
                collection = testCase.ofElements(1, 2, 3);
                changed = collection.removeAll(collecstionsToRemove{i});
                testCase.assertTrue(changed);
                testCase.assertEqual(collection.size(), 0);
            end
        end
        
        function removeAll_with_collection_containing_every_element_and_more(testCase)
            collecstionsToRemove = {testCase.ofElements(1, 2, 3, 4, 5), ...
                testCase.javaListOf(2, 1, 0, 3, 5, 6), ...
                testCase.javaSetOf(6, 5, 1, 2, 0, 3, 9), ...
                {3, 5, 6, 1, 2, 3}};
            
            for i = 1:numel(collecstionsToRemove)
                collection = testCase.ofElements(1, 2, 3);
                changed = collection.removeAll(collecstionsToRemove{i});
                testCase.assertTrue(changed);
                testCase.assertEqual(collection.size(), 0);
            end
        end
        
        function removeAll_with_collection_of_partial_match(testCase)
            collecstionsToRemove = {testCase.ofElements(3, 2, 4, 5), ...
                testCase.javaListOf(2, 0, 3, 5, 6), ...
                testCase.javaSetOf(6, 5, 2, 0, 3, 9), ...
                {3, 5, 6, 2, 3}};
            
            for i = 1:numel(collecstionsToRemove)
                collection = testCase.ofElements(1, 2, 3);
                changed = collection.removeAll(collecstionsToRemove{i});
                testCase.assertTrue(changed);
                testCase.assertElementsFromOneUntil(collection, 1);
            end
        end
        
        function removeAll_with_predicate_from_empty_collection(testCase)
            collection = testCase.ofElements();
            changed = collection.removeAll(@(e) true);
            testCase.assertFalse(changed);
            testCase.assertEqual(collection.size(), 0);
        end
        
        function removeAll_with_predicate_which_always_false(testCase)
            collection = testCase.ofElements(100, 101, 102, 103);
            changed = collection.removeAll(@(e) false);
            testCase.assertFalse(changed);
            testCase.assertElementsFromOneUntilWithOffset(collection, 4, 100);
        end
        
        function removeAll_with_predicate_which_always_true(testCase)
            collection = testCase.ofElements(1, 2, 3);
            changed = collection.removeAll(@(e) true);
            testCase.assertTrue(changed);
            testCase.assertEqual(collection.size(), 0);
        end
        
        
        function removeAll_with_predicate_of_partial_match(testCase)
            collection = testCase.ofElements(2, 1, 3);
            changed = collection.removeAll(@(e) e >= 2);
            testCase.assertTrue(changed);
            testCase.assertElementsFromOneUntil(collection, 1);
        end
        
        function retainAll_with_collection_from_empty_collection(testCase)
            collecstionsToRetain = {testCase.ofElements(1, 2, 3), ...
                testCase.javaListOf(1, 2, 3), ...
                testCase.javaSetOf(10, 20, 30), ...
                {'a', 'b', 'c'}};
            
            for i = 1:numel(collecstionsToRetain)
                collection = testCase.ofElements();
                changed = collection.retainAll(collecstionsToRetain{i});
                testCase.assertFalse(changed);
                testCase.assertEqual(collection.size(), 0);
            end
        end
        
        function retainAll_with_collection_of_not_existent_elements(testCase)
            collecstionsToRetain = {testCase.ofElements(1, 2, 3), ...
                testCase.javaListOf(1, 2, 3), ...
                testCase.javaSetOf(10, 20, 30), ...
                {'a', 'b', 'c'}};
            
            for i = 1:numel(collecstionsToRetain)
                collection = testCase.ofElements(100, 101, 102, 103);
                changed = collection.retainAll(collecstionsToRetain{i});
                testCase.assertTrue(changed);
                testCase.assertEqual(collection.size(), 0);
            end
        end
        
        function retainAll_with_empty_collection(testCase)
            collecstionsToRetain = {testCase.ofElements(), ...
                testCase.javaListOf(), ...
                testCase.javaSetOf(), ...
                {}};
            
            for i = 1:numel(collecstionsToRetain)
                collection = testCase.ofElements(100, 101, 102, 103);
                changed = collection.retainAll(collecstionsToRetain{i});
                testCase.assertTrue(changed);
                testCase.assertEqual(collection.size(), 0);
            end
        end
        
        function retainAll_with_collection_containing_exactly_every_element(testCase)
            collecstionsToRetain = {testCase.ofElements(1, 2, 3), ...
                testCase.javaListOf(3, 2, 1), ...
                testCase.javaSetOf(1, 2, 3), ...
                {2, 1, 3}};
            
            for i = 1:numel(collecstionsToRetain)
                collection = testCase.ofElements(1, 2, 3);
                changed = collection.retainAll(collecstionsToRetain{i});
                testCase.assertFalse(changed);
                testCase.assertElementsFromOneUntil(collection, 3);
            end
        end
        
        function retainAll_with_collection_containing_every_element_and_more(testCase)
            collecstionsToRetain = {testCase.ofElements(1, 2, 3, 4, 5), ...
                testCase.javaListOf(2, 1, 0, 3, 5, 6), ...
                testCase.javaSetOf(6, 5, 1, 2, 0, 3, 9), ...
                {3, 5, 6, 1, 2, 3}};
            
            for i = 1:numel(collecstionsToRetain)
                collection = testCase.ofElements(1, 2, 3);
                changed = collection.retainAll(collecstionsToRetain{i});
                testCase.assertFalse(changed);
                testCase.assertElementsFromOneUntil(collection, 3);
            end
        end
        
        function retainAll_with_collection_of_partial_match(testCase)
            collecstionsToRetain = {testCase.ofElements(3, 2, 4, 5), ...
                testCase.javaListOf(2, 0, 3, 5, 6), ...
                testCase.javaSetOf(6, 5, 2, 0, 3, 9), ...
                {3, 5, 6, 2, 3}};
            
            for i = 1:numel(collecstionsToRetain)
                collection = testCase.ofElements(1, 2, 3);
                changed = collection.retainAll(collecstionsToRetain{i});
                testCase.assertTrue(changed);
                testCase.assertElementsFromOneUntilWithOffset(collection, 2, 2);
            end
        end
        
        function retainAll_with_predicate_from_empty_collection(testCase)
            collection = testCase.ofElements();
            changed = collection.retainAll(@(e) true);
            testCase.assertFalse(changed);
            testCase.assertEqual(collection.size(), 0);
        end
        
        function retainAll_with_predicate_which_always_false(testCase)
            collection = testCase.ofElements(100, 101, 102, 103);
            changed = collection.retainAll(@(e) false);
            testCase.assertTrue(changed);
            testCase.assertEqual(collection.size(), 0);
        end
        
        function retainAll_with_predicate_which_always_true(testCase)
            collection = testCase.ofElements(1, 2, 3);
            changed = collection.retainAll(@(e) true);
            testCase.assertFalse(changed);
            testCase.assertElementsFromOneUntil(collection, 3);
        end
        
        
        function retainAll_with_predicate_of_partial_match(testCase)
            collection = testCase.ofElements(2, 1, 3);
            changed = collection.retainAll(@(e) e >= 2);
            testCase.assertTrue(changed);
            testCase.assertElementsFromOneUntilWithOffset(collection, 2, 2);
        end
        
    end
end
