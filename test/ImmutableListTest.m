
classdef ImmutableListTest < CollectionTest & matlab.unittest.TestCase
    
    methods
        function classUnderTest = classUnderTest(obj)
            classUnderTest = 'MXtension.Collections.ImmutableList';
        end
    end
    
    %% Test Method Block
    methods(Test)
        function listIterator_without_argument_on_empty_list(testCase)
            iterator = testCase.ofElements().listIterator();
            testCase.assertFalse(iterator.hasNext());
            testCase.assertFalse(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 1);
            testCase.assertEqual(iterator.previousIndex(), 0);
            
            try
                iterator = testCase.ofElements().listIterator();
                iterator.next();
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:NoSuchElementException');
                testCase.assertEqual(ex.message, 'The requested element cannot be found.');
            end
            
            try
                iterator = testCase.ofElements().listIterator();
                iterator.previous();
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:NoSuchElementException');
                testCase.assertEqual(ex.message, 'The requested element cannot be found.');
            end
        end
        
        function listIterator_with_argument_on_empty_list(testCase)
            try
                testCase.ofElements().listIterator(0);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
            
            try
                testCase.ofElements().listIterator(2);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
            
            iterator = testCase.ofElements().listIterator(1);
            testCase.assertFalse(iterator.hasNext());
            testCase.assertFalse(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 1);
            testCase.assertEqual(iterator.previousIndex(), 0);
            
            try
                iterator = testCase.ofElements().listIterator(1);
                iterator.next();
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:NoSuchElementException');
                testCase.assertEqual(ex.message, 'The requested element cannot be found.');
            end
            
            try
                iterator = testCase.ofElements().listIterator(1);
                iterator.previous();
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:NoSuchElementException');
                testCase.assertEqual(ex.message, 'The requested element cannot be found.');
            end
        end
        
        function listIterator_without_argument_on_non_empty_list(testCase)
            iterator = testCase.ofElements(3, 2, 1).listIterator();
            testCase.assertTrue(iterator.hasNext());
            testCase.assertFalse(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 1);
            testCase.assertEqual(iterator.previousIndex(), 0);
            testCase.assertEqual(iterator.next(), 3);
            testCase.assertTrue(iterator.hasNext());
            testCase.assertTrue(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 2);
            testCase.assertEqual(iterator.previousIndex(), 1);
            testCase.assertEqual(iterator.next(), 2);
            testCase.assertTrue(iterator.hasNext());
            testCase.assertTrue(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 3);
            testCase.assertEqual(iterator.previousIndex(), 2);
            testCase.assertEqual(iterator.next(), 1);
            testCase.assertFalse(iterator.hasNext());
            testCase.assertTrue(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 4);
            testCase.assertEqual(iterator.previousIndex(), 3);
            try
                iterator.next();
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:NoSuchElementException');
                testCase.assertEqual(ex.message, 'The requested element cannot be found.');
            end
            testCase.assertFalse(iterator.hasNext());
            testCase.assertTrue(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 4);
            testCase.assertEqual(iterator.previousIndex(), 3);
            
            testCase.assertEqual(iterator.previous(), 1);
            testCase.assertTrue(iterator.hasNext());
            testCase.assertTrue(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 3);
            testCase.assertEqual(iterator.previousIndex(), 2);
            testCase.assertEqual(iterator.previous(), 2);
            testCase.assertTrue(iterator.hasNext());
            testCase.assertTrue(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 2);
            testCase.assertEqual(iterator.previousIndex(), 1);
            testCase.assertEqual(iterator.previous(), 3);
            testCase.assertTrue(iterator.hasNext());
            testCase.assertFalse(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 1);
            testCase.assertEqual(iterator.previousIndex(), 0);
            try
                iterator.previous();
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:NoSuchElementException');
                testCase.assertEqual(ex.message, 'The requested element cannot be found.');
            end
            testCase.assertTrue(iterator.hasNext());
            testCase.assertFalse(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 1);
            testCase.assertEqual(iterator.previousIndex(), 0);
            testCase.assertEqual(iterator.next(), 3);
        end
        
        
        function listIterator_with_argument_on_non_empty_list(testCase)
            try
                testCase.ofElements(3, 2, 1).listIterator(0);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
            
            try
                testCase.ofElements(3, 2, 1).listIterator(5);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
            
            iterator = testCase.ofElements(3, 2, 1).listIterator(1);
            testCase.assertTrue(iterator.hasNext());
            testCase.assertFalse(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 1);
            testCase.assertEqual(iterator.previousIndex(), 0);
            testCase.assertEqual(iterator.next(), 3);
            testCase.assertTrue(iterator.hasNext());
            testCase.assertTrue(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 2);
            testCase.assertEqual(iterator.previousIndex(), 1);
            testCase.assertEqual(iterator.next(), 2);
            testCase.assertTrue(iterator.hasNext());
            testCase.assertTrue(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 3);
            testCase.assertEqual(iterator.previousIndex(), 2);
            testCase.assertEqual(iterator.next(), 1);
            testCase.assertFalse(iterator.hasNext());
            testCase.assertTrue(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 4);
            testCase.assertEqual(iterator.previousIndex(), 3);
            try
                iterator.next();
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:NoSuchElementException');
                testCase.assertEqual(ex.message, 'The requested element cannot be found.');
            end
            testCase.assertFalse(iterator.hasNext());
            testCase.assertTrue(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 4);
            testCase.assertEqual(iterator.previousIndex(), 3);
            
            testCase.assertEqual(iterator.previous(), 1);
            testCase.assertTrue(iterator.hasNext());
            testCase.assertTrue(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 3);
            testCase.assertEqual(iterator.previousIndex(), 2);
            testCase.assertEqual(iterator.previous(), 2);
            testCase.assertTrue(iterator.hasNext());
            testCase.assertTrue(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 2);
            testCase.assertEqual(iterator.previousIndex(), 1);
            testCase.assertEqual(iterator.previous(), 3);
            testCase.assertTrue(iterator.hasNext());
            testCase.assertFalse(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 1);
            testCase.assertEqual(iterator.previousIndex(), 0);
            try
                iterator.previous();
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:NoSuchElementException');
                testCase.assertEqual(ex.message, 'The requested element cannot be found.');
            end
            testCase.assertTrue(iterator.hasNext());
            testCase.assertFalse(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 1);
            testCase.assertEqual(iterator.previousIndex(), 0);
            testCase.assertEqual(iterator.next(), 3);
            
            
            iterator = testCase.ofElements(3, 2, 1).listIterator(2);
            testCase.assertTrue(iterator.hasNext());
            testCase.assertTrue(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 2);
            testCase.assertEqual(iterator.previousIndex(), 1);
            testCase.assertEqual(iterator.next(), 2);
            testCase.assertEqual(iterator.previous(), 2);
            testCase.assertEqual(iterator.previous(), 3);
            
            iterator = testCase.ofElements(3, 2, 1).listIterator(4);
            testCase.assertFalse(iterator.hasNext());
            testCase.assertTrue(iterator.hasPrevious());
            testCase.assertEqual(iterator.nextIndex(), 4);
            testCase.assertEqual(iterator.previousIndex(), 3);
            testCase.assertEqual(iterator.previous(), 1);
            testCase.assertEqual(iterator.previous(), 2);
            testCase.assertEqual(iterator.previous(), 3);
        end
        
        
        function get_on_empty_list(testCase)
            list = testCase.ofElements();
            try
                list.get(1);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
            
            try
                list.get(-1);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
        end
        
        function get_on_non_empty_list(testCase)
            list = testCase.ofElements(1, 2, 3);
            testCase.assertEqual(list.get(1), 1);
            testCase.assertEqual(list.get(2), 2);
            testCase.assertEqual(list.get(3), 3);
            
            try
                list.get(-1);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
            
            try
                list.get(4);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
        end
        
        
        function foldRight_on_empty_list(testCase)
            accumulated = testCase.ofElements().foldRight(0, @(acc, x) acc+10);
            testCase.assertEqual(accumulated, 0);
        end
        
        function foldRight_on_non_empty_list(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).foldRight(0, @(acc, elem) acc), 0);
            
            testCase.assertEqual(testCase.ofElements('a', 'b', 'c', 'd', 'e').foldRight(0, @(acc, elem) acc+numel(elem)), 5);
            testCase.assertEqual(testCase.ofElements('a', 'bb', 'ccc').foldRight(0, @(acc, elem) acc+numel(elem)), 6);
            testCase.assertEqual(testCase.ofElements('a', 'bb', 'ccc').foldRight(10, @(acc, elem) acc+numel(elem)), 16);
            
            testCase.assertEqual(testCase.ofElements(testCase.ofElements(1), ...
                testCase.ofElements(1, 2, 3), ...
                testCase.ofElements(1, 2, 3, 4, 5)).foldRight(1000, @(acc, elem) acc+elem.size()), 1009);
            
            testCase.assertEqual(testCase.ofElements('a', 'b', 'c', 'd', 'e').foldRight('', @(acc, elem) [acc, elem]), 'edcba');
        end
        
        
        function foldRightIndexed_on_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements().foldRightIndexed(0, @(ind, acc, elem) 1000), 0);
            testCase.assertEqual(testCase.ofElements().foldRightIndexed(100, @(ind, acc, elem) 1000), 100);
            thc = TestHandleClass();
            testCase.assertEqual(testCase.ofElements().foldRightIndexed(thc, @(ind, acc, elem) 1000), thc);
        end
        
        function foldRightIndexed_on_non_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).foldRightIndexed(0, @(ind, acc, elem) acc), 0);
            
            testCase.assertEqual(testCase.ofElements('a', 'b', 'c', 'd', 'e').foldRightIndexed(0, @(ind, acc, elem) acc+numel(elem)), 5);
            testCase.assertEqual(testCase.ofElements('a', 'b', 'c', 'd', 'e').foldRightIndexed(0, @(ind, acc, elem) acc+ind), 15);
            testCase.assertEqual(testCase.ofElements('a', 'b', 'c', 'd', 'e').foldRightIndexed(100, @(ind, acc, elem) acc+ind), 115);
            
            testCase.assertEqual(testCase.ofElements('a', 'bb', 'ccc').foldRightIndexed(0, @(ind, acc, elem) acc+numel(elem)), 6);
            testCase.assertEqual(testCase.ofElements('a', 'bb', 'ccc').foldRightIndexed(0, @(ind, acc, elem) acc+numel(elem)+ind), 12);
            testCase.assertEqual(testCase.ofElements('a', 'bb', 'ccc').foldRightIndexed(10, @(ind, acc, elem) acc+numel(elem)+ind), 22);
            
            testCase.assertEqual(testCase.ofElements(testCase.ofElements(1), ...
                testCase.ofElements(1, 2, 3), ...
                testCase.ofElements(1, 2, 3, 4, 5)).foldRightIndexed(1000, @(ind, acc, elem) acc+elem.size()), 1009);
            
            testCase.assertEqual(testCase.ofElements(testCase.ofElements(1), ...
                testCase.ofElements(1, 2, 3), ...
                testCase.ofElements(1, 2, 3, 4, 5)).foldRightIndexed(1000, @(ind, acc, elem) acc+elem.size()+ind), 1015);
            
            testCase.assertEqual(testCase.ofElements('a', 'b', 'c', 'd', 'e').foldRightIndexed('', @(ind, acc, elem) [acc, elem, num2str(ind)]), 'e5d4c3b2a1');
        end
        
        
        function drop_on_empty_collection(testCase)
            list = testCase.ofElements().drop(0);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements().drop(1);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function dropLast_with_illegal_argument(testCase)
            
            try
                testCase.ofElements().dropLast(-1);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalArgumentException');
                testCase.assertEqual(ex.message, 'The requested element count is less than zero.');
            end
            
            try
                testCase.ofElements(1, 2, 3).dropLast(-1);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalArgumentException');
                testCase.assertEqual(ex.message, 'The requested element count is less than zero.');
            end
            
            try
                testCase.ofElements(1, 2, 3).dropLast('a');
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalArgumentException');
                testCase.assertEqual(ex.message, 'The requested element count is less than zero.');
            end
            
            try
                testCase.ofElements(1, 2, 3).dropLast(TestDataClass());
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalArgumentException');
                testCase.assertEqual(ex.message, 'The requested element count is less than zero.');
            end
        end
        
        function dropLast_inside_the_collection_size(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).dropLast(0);
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
            
            list = testCase.ofElements(1, 2, 3, 4, 5).dropLast(1);
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 4);
            
            list = testCase.ofElements(1, 2, 3, 4, 5).dropLast(5);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements('a', 'b', 'c', 'd', 'e').dropLast(3);
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 'a');
            testCase.assertEqual(list.get(2), 'b');
            testCase.assertEqual(list.size(), 2);
        end
        
        function dropLast_outside_the_collection_size(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).dropLast(6);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        
        function takeLast_on_empty_collection(testCase)
            list = testCase.ofElements().takeLast(0);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements().takeLast(1);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function takeLast_with_illegal_argument(testCase)
            try
                testCase.ofElements().takeLast(-1);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalArgumentException');
                testCase.assertEqual(ex.message, 'The requested element count is less than zero.');
            end
            
            try
                testCase.ofElements(1, 2, 3).takeLast(-1);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalArgumentException');
                testCase.assertEqual(ex.message, 'The requested element count is less than zero.');
            end
            
            try
                testCase.ofElements(1, 2, 3).takeLast('a');
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalArgumentException');
                testCase.assertEqual(ex.message, 'The requested element count is less than zero.');
            end
            
            try
                testCase.ofElements(1, 2, 3).takeLast(TestDataClass());
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalArgumentException');
                testCase.assertEqual(ex.message, 'The requested element count is less than zero.');
            end
        end
        
        function takeLast_inside_of_the_collection_size(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).takeLast(0);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements(1, 2, 3, 4, 5).takeLast(3);
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntilWithOffset(list, 3, 3);
            
            list = testCase.ofElements(1, 2, 3, 4, 5).takeLast(5);
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
            
            list = testCase.ofElements('a', 'b', 'c', 'd', 'e').takeLast(2);
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 'd');
            testCase.assertEqual(list.get(2), 'e');
            testCase.assertEqual(list.size(), 2);
        end
        
        function takeLast_outside_of_the_collection_size(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).takeLast(7);
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
            
            list = testCase.ofElements('a', 'b', 'c', 'd', 'e').takeLast(100);
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 'a');
            testCase.assertEqual(list.get(2), 'b');
            testCase.assertEqual(list.get(3), 'c');
            testCase.assertEqual(list.get(4), 'd');
            testCase.assertEqual(list.get(5), 'e');
            testCase.assertEqual(list.size(), 5);
        end
        
        
        function takeLastWhile_on_empty_collection(testCase)
            list = testCase.ofElements().takeLastWhile(@(x) true);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements().takeLastWhile(@(x) false);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function takeLastWhile_with_always_true_predicate(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).takeLastWhile(@(x) true);
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
        end
        
        function takeLastWhile_with_always_false_predicate(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).takeLastWhile(@(x) false);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function takeLastWhile_with_partially_matching_predicate(testCase)
            list = testCase.ofElements('a', 'b', 'c', 'd', 'e').takeLastWhile(@(x) ~strcmp(x, 'c'));
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 'd');
            testCase.assertEqual(list.get(2), 'e');
            testCase.assertEqual(list.size(), 2);
            
            list = testCase.ofElements(1, 2, 3, 4, 5).takeLastWhile(@(x) isnumeric(x));
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
        end
        
        
        function dropLastWhile_on_empty_collection(testCase)
            list = testCase.ofElements().dropLastWhile(@(x) true);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements().dropLastWhile(@(x) false);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function dropLastWhile_with_always_true_predicate(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).dropLastWhile(@(x) true);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function dropLastWhile_with_always_false_predicate(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).dropLastWhile(@(x) false);
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
        end
        
        function dropLastWhile_with_partially_matching_predicate(testCase)
            list = testCase.ofElements('a', 'b', 'c', 'd', 'e').dropLastWhile(@(x) ~strcmp(x, 'b'));
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 'a');
            testCase.assertEqual(list.get(2), 'b');
            testCase.assertEqual(list.size(), 2);
            
            list = testCase.ofElements(1, 2, 3, 4, 5).dropLastWhile(@(x) ~isnumeric(x));
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
            
            list = testCase.ofElements(1, 2, 3, 4, 5).dropLastWhile(@(x) isnumeric(x));
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        
    end
end