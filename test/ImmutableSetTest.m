%% Test Class Definition
classdef ImmutableSetTest < CollectionTest & matlab.unittest.TestCase
    
    methods
        function classUnderTest = classUnderTest(obj)
            classUnderTest = 'MXtension.Collections.ImmutableSet';
        end
    end
    
    %% Test Method Block
    methods (Test)
        % Override because of element uniqeness
        function indexOfLast_on_non_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).indexOfLast(@(x) x > 2), 3);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).indexOfLast(@(x) x < 2), 1);
            testCase.assertEqual(testCase.ofElements('a', 'b').indexOfLast(@(x) strcmp(x, 'a')), 1);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).indexOfLast(@(x) x > 3), -1);
            testCase.assertEqual(testCase.ofElements().indexOfLast(@(x) true), -1);
        end
        
        % Override because of element uniqeness
        function indexOf_element_that_matches(testCase)
            collection = testCase.ofElements(1, 2, 3);
            testCase.assertEqual(collection.indexOf(2), 2);
            testCase.assertEqual(collection.indexOf(1), 1);
            testCase.assertEqual(collection.indexOf(3), 3);
        end
        
        % Override because of element uniqeness
        function lastIndexOf_on_non_empty_collection(testCase)
            collection = testCase.ofElements(1, 2, 3);
            testCase.assertEqual(collection.lastIndexOf(2), 2);
            testCase.assertEqual(collection.lastIndexOf(1), 1);
            testCase.assertEqual(collection.lastIndexOf(3), 3);
            testCase.assertEqual(collection.lastIndexOf(0), -1);
            testCase.assertEqual(collection.lastIndexOf('123'), -1);
            
            collection = testCase.ofElements('A', 'a', 'bb', 'z');
            testCase.assertEqual(collection.lastIndexOf('a'), 2);
            testCase.assertEqual(collection.lastIndexOf('A'), 1);
            testCase.assertEqual(collection.lastIndexOf('bb'), 3);
            testCase.assertEqual(collection.lastIndexOf('z'), 4);
            testCase.assertEqual(collection.lastIndexOf(0), -1);
            testCase.assertEqual(collection.lastIndexOf('123'), -1);
        end
        

        
      
    end
end