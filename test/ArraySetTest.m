%% Test Class Definition
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
        
    end
    
end