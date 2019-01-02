classdef ArraySetTest < ImmutableSetTest & MutableCollectionTest & matlab.unittest.TestCase
    methods
        function classUnderTest = classUnderTest(obj)
            classUnderTest = 'MXtension.Collections.ArraySet';
        end
    end
    
    methods (Test)
       
        function add_same_element_to_collection_twice(testCase)
            collection = testCase.ofElements();
            testEntry = 'test_entry';
            result = collection.add(testEntry);
            testCase.assertTrue(result);
            result = collection.add(testEntry);
            testCase.assertFalse(result);
            testCase.assertEqual(collection.size(), 1);
            iterator = collection.iterator();
            testCase.assertEqual(iterator.next(), testEntry);
        end
        
        function addAll_duplicate_elements(testCase)
            collection = testCase.ofElements();
            changed = collection.addAll(testCase.ofElements(1, 2, 2, 1, 3, 1, 3, 3, 2, 1));
            testCase.assertTrue(changed);
            testCase.assertElementsFromOneUntil(collection, 3);
        end
    end
end