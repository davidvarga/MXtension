
classdef ImmutableListTest < CollectionTest & matlab.unittest.TestCase
    
    methods
        function classUnderTest = classUnderTest(obj)
            classUnderTest = 'MXtension.Collections.ImmutableList';
        end
    end
    
    %% Test Method Block
    methods(Test)
        
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
        
        
    end
end