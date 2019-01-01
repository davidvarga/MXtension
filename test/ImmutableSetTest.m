
%% Test Class Definition
classdef ImmutableSetTest < CollectionTest & matlab.unittest.TestCase
    
    methods
        function classUnderTest = classUnderTest(obj)
            classUnderTest = 'MXtension.Collections.ImmutableSet';
        end
    end
    
    
    methods(Test)
        % Override
        function indexOf_element_that_matches(testCase)
            collection = testCase.ofElements(1, 2, 2, 3, 2, 3);
            testCase.assertEqual(collection.indexOf(1), 1);
            testCase.assertEqual(collection.indexOf(2), 2);
            testCase.assertEqual(collection.indexOf(3), 3);
        end
        
        % Override
        function lastIndexOf_on_non_empty_collection(testCase)
            collection = testCase.ofElements(1, 2, 2, 3, 2, 3);
            testCase.assertEqual(collection.lastIndexOf(2), 2);
            testCase.assertEqual(collection.lastIndexOf(1), 1);
            testCase.assertEqual(collection.lastIndexOf(3), 3);
            testCase.assertEqual(collection.lastIndexOf(0), -1);
            testCase.assertEqual(collection.lastIndexOf('123'), -1);
            
            collection = testCase.ofElements('A', 'a', 'bb', 'bb', 'a', 'z');
            testCase.assertEqual(collection.lastIndexOf('a'), 2);
            testCase.assertEqual(collection.lastIndexOf('A'), 1);
            testCase.assertEqual(collection.lastIndexOf('bb'), 3);
            testCase.assertEqual(collection.lastIndexOf('z'), 4);
            testCase.assertEqual(collection.lastIndexOf(0), -1);
            testCase.assertEqual(collection.lastIndexOf('123'), -1);
        end
        
        function indexOfLast_on_non_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).indexOfLast(@(x) x > 2), 3);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).indexOfLast(@(x) x < 2), 1);
            testCase.assertEqual(testCase.ofElements(1, 2, 3, 1).indexOfLast(@(x) x < 2), 1);
            testCase.assertEqual(testCase.ofElements('a', 'b').indexOfLast(@(x) strcmp(x, 'a')), 1);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).indexOfLast(@(x) x > 3), -1);
        end
        
        function construct_with_fromCollection_non_unique(testCase)
            collections = testCase.allKindsOfCollectionsOf(1, 2, 2, 1);
            for i = 1:numel(collections)
                set = testCase.fromCollection(collections{i});
                testCase.assertEqual(set.size(), 2);
                it = set.iterator();
                testCase.assertEqual(it.next(), 1);
                testCase.assertEqual(it.next(), 2);
            end
            set = testCase.ofElements(1, 2, 2, 1);
            testCase.assertEqual(set.size(), 2);
            it = set.iterator();
            testCase.assertEqual(it.next(), 1);
            testCase.assertEqual(it.next(), 2);
            
            collections = testCase.allKindsOfCollectionsOf('a', 'a', 'b', 'a');
            for i = 1:numel(collections)
                set = testCase.fromCollection(collections{i});
                testCase.assertEqual(set.size(), 2);
                it = set.iterator();
                testCase.assertEqual(it.next(), 'a');
                testCase.assertEqual(it.next(), 'b');
            end
            set = testCase.ofElements('a', 'a', 'b', 'a');
            testCase.assertEqual(set.size(), 2);
            it = set.iterator();
            testCase.assertEqual(it.next(), 'a');
            testCase.assertEqual(it.next(), 'b');
            
            
            thc = TestHandleClass();
            thc2 = TestHandleClass();
            tdc = TestDataClass();
            tdc2 = TestDataClass();
            
            collections = testCase.matlabCollectionsOf(thc, tdc, thc2, tdc2);
            for i = 1:numel(collections)
                set = testCase.fromCollection(collections{i});
                testCase.assertEqual(set.size(), 3);
                it = set.iterator();
                testCase.assertEqual(it.next(), thc);
                testCase.assertEqual(it.next(), tdc);
                testCase.assertEqual(it.next(), thc2);
            end
            set = testCase.ofElements(thc, tdc, thc2, tdc2);
            testCase.assertEqual(set.size(), 3);
            it = set.iterator();
            testCase.assertEqual(it.next(), thc);
            testCase.assertEqual(it.next(), tdc);
            testCase.assertEqual(it.next(), thc2);
        end
    end
end