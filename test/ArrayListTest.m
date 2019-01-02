classdef ArrayListTest < MutableCollectionTest & matlab.unittest.TestCase
    methods
        function classUnderTest = classUnderTest(obj)
            classUnderTest = 'MXtension.Collections.ArrayList';
        end
    end
    
    methods(Test)
        function listIterator_mutablity_add_on_empty_list(testCase)
            list = MXtension.Collections.ArrayList.ofElements();
            it = list.listIterator();
            it.add(1);
            testCase.assertEqual(list.size(), 1);
            testCase.assertEqual(list.get(1), 1);
            testCase.assertFalse(it.hasNext());
            testCase.assertTrue(it.hasPrevious());
            testCase.assertEqual(it.nextIndex(), 2);
            testCase.assertEqual(it.previousIndex(), 1);
            it.add(2);
            testCase.assertEqual(list.size(), 2);
            testCase.assertEqual(list.get(1), 1);
            testCase.assertEqual(list.get(2), 2);
            testCase.assertFalse(it.hasNext());
            testCase.assertTrue(it.hasPrevious());
            testCase.assertEqual(it.nextIndex(), 3);
            testCase.assertEqual(it.previousIndex(), 2);
        end
        
        function listIterator_mutablity_add_and_set_on_empty_list(testCase)
            list = MXtension.Collections.ArrayList.ofElements();
            it = list.listIterator();
            try
                it.set(1);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalStateException');
                testCase.assertEqual(ex.message, 'The last index of the iterator is empty.');
            end
            testCase.assertEqual(list.size(), 0);
            it.add(1);
            testCase.assertEqual(list.size(), 1);
            testCase.assertEqual(list.get(1), 1);
            testCase.assertFalse(it.hasNext());
            testCase.assertTrue(it.hasPrevious());
            testCase.assertEqual(it.nextIndex(), 2);
            testCase.assertEqual(it.previousIndex(), 1);
            try
                it.set(10);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalStateException');
                testCase.assertEqual(ex.message, 'The last index of the iterator is empty.');
            end
            testCase.assertEqual(list.size(), 1);
            testCase.assertEqual(list.get(1), 1);
            testCase.assertFalse(it.hasNext());
            testCase.assertTrue(it.hasPrevious());
            testCase.assertEqual(it.nextIndex(), 2);
            testCase.assertEqual(it.previousIndex(), 1);
            
            testCase.assertEqual(it.previous(), 1);
            
            it.set(10);
            testCase.assertEqual(list.size(), 1);
            testCase.assertEqual(list.get(1), 10);
            testCase.assertTrue(it.hasNext());
            testCase.assertFalse(it.hasPrevious());
            testCase.assertEqual(it.nextIndex(), 1);
            testCase.assertEqual(it.previousIndex(), 0);
            it.set(100);
            testCase.assertEqual(list.size(), 1);
            testCase.assertEqual(list.get(1), 100);
            testCase.assertTrue(it.hasNext());
            testCase.assertFalse(it.hasPrevious());
            testCase.assertEqual(it.nextIndex(), 1);
            testCase.assertEqual(it.previousIndex(), 0);
            
            
            it.add(2);
            testCase.assertEqual(list.size(), 2);
            testCase.assertEqual(list.get(1), 2);
            testCase.assertEqual(list.get(2), 100);
            testCase.assertTrue(it.hasNext());
            testCase.assertTrue(it.hasPrevious());
            testCase.assertEqual(it.nextIndex(), 2);
            testCase.assertEqual(it.previousIndex(), 1);
            try
                it.set(200);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalStateException');
                testCase.assertEqual(ex.message, 'The last index of the iterator is empty.');
            end
            testCase.assertEqual(list.size(), 2);
            testCase.assertEqual(list.get(1), 2);
            testCase.assertEqual(list.get(2), 100);
            testCase.assertTrue(it.hasNext());
            testCase.assertTrue(it.hasPrevious());
            testCase.assertEqual(it.nextIndex(), 2);
            testCase.assertEqual(it.previousIndex(), 1);
            testCase.assertEqual(it.previous(), 2);
            it.set(200);
            
            
            testCase.assertEqual(list.size(), 2);
            testCase.assertEqual(list.get(1), 200);
            testCase.assertEqual(list.get(2), 100);
            testCase.assertTrue(it.hasNext());
            testCase.assertFalse(it.hasPrevious());
            testCase.assertEqual(it.nextIndex(), 1);
            testCase.assertEqual(it.previousIndex(), 0);
        end
        
        function insert_on_empty_list(testCase)
            list = MXtension.Collections.ArrayList.ofElements();
            try
                list.insert(0, 'a');
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'Cannot insert on the specified index.');
                testCase.assertEqual(list.size(), 0);
            end
            
            try
                list.insert(2, 'a');
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'Cannot insert on the specified index.');
                testCase.assertEqual(list.size(), 0);
            end
            
            list.insert(1, 'a');
            testCase.assertEqual(list.size(), 1);
            testCase.assertEqual(list.get(1), 'a');
        end
        
        function insert_on_non_empty_list(testCase)
            list = MXtension.Collections.ArrayList.ofElements(1, 2, 3);
            try
                list.insert(0, 'a');
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'Cannot insert on the specified index.');
                testCase.assertEqual(list.size(), 3);
            end
            
            try
                list.insert(5, 'a');
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'Cannot insert on the specified index.');
                testCase.assertEqual(list.size(), 3);
            end
            
            list.insert(4, 'a');
            testCase.assertEqual(list.size(), 4);
            testCase.assertEqual(list.get(4), 'a');
            
            list.insert(1, 'b');
            testCase.assertEqual(list.size(), 5);
            testCase.assertEqual(list.get(1), 'b');
            
            list.insert(3, 'c');
            testCase.assertEqual(list.size(), 6);
            testCase.assertEqual(list.get(3), 'c');
        end
        
        function insertAll_on_empty_list(testCase)
            list = MXtension.Collections.ArrayList.ofElements();
            try
                list.insertAll(0, {'a'});
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'Cannot insert on the specified index.');
                testCase.assertEqual(list.size(), 0);
            end
            
            try
                list.insertAll(2, {'a'});
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'Cannot insert on the specified index.');
                testCase.assertEqual(list.size(), 0);
            end
            
            collections = testCase.allKindsOfCollectionsOf(1, 2, 3);
            for i = 1:numel(collections)
                list = MXtension.Collections.ArrayList.ofElements();
                list.insertAll(1, collections{i});
                testCase.assertEqual(list.size(), 3);
                testCase.assertElementsFromOneUntil(list, 3);
            end
        end
        
        function insertAll_on_non_empty_list(testCase)
            list = MXtension.Collections.ArrayList.ofElements(1, 2, 3);
            try
                list.insertAll(0, {'a'});
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'Cannot insert on the specified index.');
                testCase.assertEqual(list.size(), 3);
            end
            
            try
                list.insertAll(5, {'a'});
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'Cannot insert on the specified index.');
                testCase.assertEqual(list.size(), 3);
            end
            
            list.insertAll(4, {'a1', 'a2'});
            testCase.assertEqual(list.size(), 5);
            testCase.assertEqual(list.get(4), 'a1');
            testCase.assertEqual(list.get(5), 'a2');
            
            list.insertAll(1, testCase.javaListOf('b1', 'b2'));
            testCase.assertEqual(list.size(), 7);
            testCase.assertEqual(list.get(1), 'b1');
            testCase.assertEqual(list.get(2), 'b2');
            
            list.insertAll(3, testCase.ofElements());
            testCase.assertEqual(list.size(), 7);
            
            list.insertAll(3, testCase.ofElements('c1'));
            testCase.assertEqual(list.size(), 8);
            testCase.assertEqual(list.get(3), 'c1');
        end
        
        function set_on_empty_list(testCase)
            list = MXtension.Collections.ArrayList.ofElements();
            try
                list.set(0, 'a');
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
            try
                list.set(1, 'a');
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
            try
                list.set(-1, 'a');
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
        end
        
        function set_on_non_empty_list(testCase)
            list = MXtension.Collections.ArrayList.ofElements(1, 2, 3);
            try
                list.set(-1, 'a');
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
            try
                list.set(4, 'a');
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
            
            list.set(1, 'a');
            testCase.assertEqual(list.size(), 3);
            testCase.assertEqual(list.get(1), 'a');
            testCase.assertEqual(list.get(2), 2);
            testCase.assertEqual(list.get(3), 3);
            
            list.set(3, 'b');
            testCase.assertEqual(list.size(), 3);
            testCase.assertEqual(list.get(1), 'a');
            testCase.assertEqual(list.get(2), 2);
            testCase.assertEqual(list.get(3), 'b');
            
            list.set(2, 'c');
            testCase.assertEqual(list.size(), 3);
            testCase.assertEqual(list.get(1), 'a');
            testCase.assertEqual(list.get(2), 'c');
            testCase.assertEqual(list.get(3), 'b');
        end
        
        function removeAt_on_empty_list(testCase)
            list = MXtension.Collections.ArrayList.ofElements();
            try
                list.removeAt(0);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
            try
                list.removeAt(1);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
            try
                list.removeAt(-1);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
        end
        
        function removeAt_on_non_empty_list(testCase)
            list = MXtension.Collections.ArrayList.ofElements(1, 2, 3, 4);
            try
                list.removeAt(0);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
            try
                list.removeAt(5);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
            try
                list.removeAt(-1);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
            
            % Remove in the middle
            removed = list.removeAt(2);
            testCase.assertEqual(list.size(), 3);
            testCase.assertEqual(list.get(1), 1);
            testCase.assertEqual(list.get(2), 3);
            testCase.assertEqual(list.get(3), 4);
            testCase.assertEqual(removed, 2);
            
            % Remove on first index
            removed = list.removeAt(1);
            testCase.assertEqual(list.size(), 2);
            testCase.assertEqual(list.get(1), 3);
            testCase.assertEqual(list.get(2), 4);
            testCase.assertEqual(removed, 1);
            
            % Remove on last index
            removed = list.removeAt(2);
            testCase.assertEqual(list.size(), 1);
            testCase.assertEqual(list.get(1), 3);
            testCase.assertEqual(removed, 4);
            
            % Remove on last element in the list
            removed = list.removeAt(1);
            testCase.assertEqual(list.size(), 0);
            testCase.assertEqual(removed, 3);
            
        end
        
        function fill_on_empty_list(testCase)
            list = MXtension.Collections.ArrayList.ofElements();
            list.fill('a');
            testCase.assertEqual(list.size(), 0),
        end
        
        function fill_on_nonempty_list(testCase)
            list = MXtension.Collections.ArrayList.ofElements(1);
            list.fill('a');
            testCase.assertEqual(list.size(), 1),
            testCase.assertEqual(list.get(1), 'a'),
            
            list = MXtension.Collections.ArrayList.ofElements(1, 2, 3);
            list.fill('a');
            testCase.assertEqual(list.size(), 3),
            for i = 1:list.size()
                testCase.assertEqual(list.get(i), 'a');
            end
        end
        
        function reverse_empty_list(testCase)
            list = MXtension.Collections.ArrayList.fromCollection({});
            list.reverse();
            testCase.assertEqual(list.size(), 0);
        end
        
        function reverse_non_empty_list(testCase)
            testCell = {1, 2, 2, 3, 4, 1, 3, 2, 4};
            list = MXtension.Collections.ArrayList.fromCollection(testCell);
            list.reverse();
            for i = 1:list.size()
                testCase.assertEqual(list.get(i), testCell{end-i+1});
            end
        end
    end
end