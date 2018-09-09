%% Test Class Definition
classdef ListTest < matlab.unittest.TestCase
    
    %% Test Method Block
    methods (Test)
        
        % TODO: list = MXtension.Collections.List.ofCollection();
            
        % TODO: list =  MXtension.Collections.List.ofCollection(1);
            
        % TODO: list =  MXtension.Collections.List.ofCollection(cell, cell);
        
        function test_list_constructed_with_ofCollection_CellArray(testCase)      
            list = MXtension.Collections.List.ofCollection({1,2,3});
            testCase.verifyEqual(list.size(), 3);
            testCase.verifyEqual(list.get(1), 1);
            testCase.verifyEqual(list.get(2), 2);
            testCase.verifyEqual(list.get(3), 3);
            
            list = MXtension.Collections.List.ofCollection({});
            testCase.verifyEqual(list.size(), 0);
        end
        
        function test_list_constructed_with_ofCollection_MXtensionList(testCase)      
            inputList = MXtension.Collections.List.ofCollection({1,2,3});
            
            list = MXtension.Collections.List.ofCollection(inputList);
            testCase.verifyEqual(list.size(), 3);
            testCase.verifyEqual(list.get(1), 1);
            testCase.verifyEqual(list.get(2), 2);
            testCase.verifyEqual(list.get(3), 3);
            
            inputList = MXtension.Collections.List.ofCollection({});
            
            list = MXtension.Collections.List.ofCollection(inputList);
            testCase.verifyEqual(list.size(), 0);
        end
        
        function test_list_constructed_with_ofCollection_Java_Collection(testCase)      
            javaCollection = java.util.ArrayList();
            javaCollection.add('a');
            javaCollection.add('b');
            javaCollection.add('c');
            
            list = MXtension.Collections.List.ofCollection(javaCollection);
            testCase.verifyEqual(list.size(), 3);
            testCase.verifyEqual(list.get(1), 'a');
            testCase.verifyEqual(list.get(2), 'b');
            testCase.verifyEqual(list.get(3), 'c');
           
            list = MXtension.Collections.List.ofCollection(java.util.ArrayList());
            testCase.verifyEqual(list.size(), 0);
        end
        
        function test_list_constructed_with_ofSize(testCase)      
            list = MXtension.Collections.List.ofSize(3);
            testCase.verifyEqual(list.size(), 3);
            testCase.verifyEqual(list.get(1), []);
            testCase.verifyEqual(list.get(2), []);
            testCase.verifyEqual(list.get(3), []);
           
            list = MXtension.Collections.List.ofSize(0);
            testCase.verifyEqual(list.size(), 0);
        end
        
        function test_list_constructed_with_ofElements(testCase)      
            list = MXtension.Collections.List.ofElements('a', 1, 'b');
            testCase.verifyEqual(list.size(), 3);
            testCase.verifyEqual(list.get(1), 'a');
            testCase.verifyEqual(list.get(2), 1);
            testCase.verifyEqual(list.get(3), 'b');
            
            list = MXtension.Collections.List.ofElements({1,2,3}, {4,5,6});
            testCase.verifyEqual(list.size(), 2);
            testCase.verifyEqual(list.get(1), {1,2,3});
            testCase.verifyEqual(list.get(2), {4,5,6});
            
            list = MXtension.Collections.List.ofElements();
            testCase.verifyEqual(list.size(), 0);
        end
        
        function test_add_with_one_argument(testCase)      
            list = MXtension.Collections.List.ofElements();
            list.add('newelement');
            testCase.verifyEqual(list.size(), 1);
            testCase.verifyEqual(list.get(1), 'newelement');
            list.add(123);
            testCase.verifyEqual(list.size(), 2);
            testCase.verifyEqual(list.get(2), 123);
        end
        
        % TODO: test_add_with_two_arguments(testCase)
        
        function test_set(testCase)      
            list = MXtension.Collections.List.ofElements(1,2,3);
            previous = list.set(2, 'newelement');
            testCase.verifyEqual(list.size(), 3);
            testCase.verifyEqual(list.get(2), 'newelement');
            testCase.verifyEqual(previous, 2);
            previous = list.set(1, 1111);
            testCase.verifyEqual(list.size(), 3);
            testCase.verifyEqual(list.get(1), 1111);
            testCase.verifyEqual(previous, 1);
            
        end
        
        % TODO: test set with exception
        
        function test_indexOf(testCase)      
            list = MXtension.Collections.List.ofElements(1, 2, 2, 3, 2, 3);
            testCase.verifyEqual(list.indexOf(2), 2);
            testCase.verifyEqual(list.indexOf(1), 1);
            testCase.verifyEqual(list.indexOf(3), 4);
            testCase.verifyEqual(list.indexOf(0), -1);
            testCase.verifyEqual(list.indexOf('123'), -1);
            
             list = MXtension.Collections.List.ofElements('A', 'a', 'bb', 'bb', 'a', 'z');
            testCase.verifyEqual(list.indexOf('a'), 2);
            testCase.verifyEqual(list.indexOf('A'), 1);
            testCase.verifyEqual(list.indexOf('bb'), 3);
            testCase.verifyEqual(list.indexOf('z'), 6);
            testCase.verifyEqual(list.indexOf(0), -1);
            testCase.verifyEqual(list.indexOf('123'), -1);            
        end
        
        function test_lastIndexOf(testCase)      
            list = MXtension.Collections.List.ofElements(1, 2, 2, 3, 2, 3);
            testCase.verifyEqual(list.lastIndexOf(2), 5);
            testCase.verifyEqual(list.lastIndexOf(1), 1);
            testCase.verifyEqual(list.lastIndexOf(3), 6);
            testCase.verifyEqual(list.lastIndexOf(0), -1);
            testCase.verifyEqual(list.lastIndexOf('123'), -1);
            
             list = MXtension.Collections.List.ofElements('A', 'a', 'bb', 'bb', 'a', 'z');
            testCase.verifyEqual(list.lastIndexOf('a'), 5);
            testCase.verifyEqual(list.lastIndexOf('A'), 1);
            testCase.verifyEqual(list.lastIndexOf('bb'), 4);
            testCase.verifyEqual(list.lastIndexOf('z'), 6);
            testCase.verifyEqual(list.lastIndexOf(0), -1);
            testCase.verifyEqual(list.lastIndexOf('123'), -1);            
        end
        
        function test_isEmpty(testCase)      
            list = MXtension.Collections.List.ofElements(1);
            testCase.verifyEqual(list.isEmpty(), false);
            
            list = MXtension.Collections.List.ofElements();
            testCase.verifyEqual(list.isEmpty(), true);
           
        end
        
        function test_contains(testCase)      
            list = MXtension.Collections.List.ofElements(1, 2, 3);
            testCase.verifyEqual(list.contains(2), true);
            testCase.verifyEqual(list.contains(1), true);
            testCase.verifyEqual(list.contains(3), true);
            testCase.verifyEqual(list.contains(0), false);
            
            list = MXtension.Collections.List.ofElements('A', 'Bb', 'ccC');
            testCase.verifyEqual(list.contains('A'), true);
            testCase.verifyEqual(list.contains('Bb'), true);
            testCase.verifyEqual(list.contains('ccC'), true);
            testCase.verifyEqual(list.contains('a'), false);
           
        end
        
        function test_containsAll(testCase)      
            list = MXtension.Collections.List.ofElements(1, 2, 3);
            testCase.verifyEqual(list.containsAll({1}), true);
            testCase.verifyEqual(list.containsAll({1,2}), true);
            testCase.verifyEqual(list.containsAll({1,2, 3}), true);
           testCase.verifyEqual(list.containsAll({1,2, 3, 4}), false);
            
            list = MXtension.Collections.List.ofElements('A', 'Bb', 'ccC');
            testCase.verifyEqual(list.containsAll(MXtension.Collections.List.ofElements('A')), true);
            testCase.verifyEqual(list.containsAll(MXtension.Collections.List.ofElements('A', 'Bb')), true);
            testCase.verifyEqual(list.containsAll(MXtension.Collections.List.ofElements('A', 'Bb', 'ccC')), true);
            testCase.verifyEqual(list.containsAll(MXtension.Collections.List.ofElements('A', 'Bb', 'ccC', '')), false);
            
             list = MXtension.Collections.List.ofElements('a', 'b', 'c');
            javaCollection = java.util.ArrayList();
            javaCollection.add('a');
            testCase.verifyEqual(list.containsAll(javaCollection), true);
            javaCollection.add('b');
            testCase.verifyEqual(list.containsAll(javaCollection), true);
            javaCollection.add('c');
            testCase.verifyEqual(list.containsAll(javaCollection), true);
            javaCollection.add('d');
            testCase.verifyEqual(list.containsAll(javaCollection), false);
        end
        
        function test_removeAt(testCase)      
            list = MXtension.Collections.List.ofElements(1, 2, 3, 4);
            % Remove in the middle
            removed = list.removeAt(2);
            testCase.verifyEqual(list.size(), 3);
            testCase.verifyEqual(list.get(1), 1);
            testCase.verifyEqual(list.get(2), 3);
            testCase.verifyEqual(list.get(3), 4);
            testCase.verifyEqual(removed, 2);
            
            % Remove on first index
            removed = list.removeAt(1);
            testCase.verifyEqual(list.size(), 2);
            testCase.verifyEqual(list.get(1), 3);
            testCase.verifyEqual(list.get(2), 4);
            testCase.verifyEqual(removed, 1);
            
            % Remove on last index
            removed = list.removeAt(2);
            testCase.verifyEqual(list.size(), 1);
            testCase.verifyEqual(list.get(1), 3);
            testCase.verifyEqual(removed, 4);
            
            % Remove on last element in the list
            removed = list.removeAt(1);
            testCase.verifyEqual(list.size(), 0);
            testCase.verifyEqual(removed, 3);
          
            
            % TODO: Test Exception
        end
        
        function test_remove(testCase)      
            list = MXtension.Collections.List.ofElements(1, 2, 2, 4);
            % Remove in the middle
            removed = list.remove(2);
            testCase.verifyEqual(list.size(), 3);
            testCase.verifyEqual(list.get(1), 1);
            testCase.verifyEqual(list.get(2), 2);
            testCase.verifyEqual(list.get(3), 4);
            testCase.verifyEqual(removed, true);
            
            % Try to remove not existing
            removed = list.remove(6);
            testCase.verifyEqual(list.size(), 3);
            testCase.verifyEqual(list.get(1), 1);
            testCase.verifyEqual(list.get(2), 2);
            testCase.verifyEqual(list.get(3), 4);
            testCase.verifyEqual(removed, false);
            
            % Remove on first index
            removed = list.remove(1);
            testCase.verifyEqual(list.size(), 2);
            testCase.verifyEqual(list.get(1), 2);
            testCase.verifyEqual(list.get(2), 4);
            testCase.verifyEqual(removed, true);
            
            % Remove on last index
            removed = list.remove(4);
            testCase.verifyEqual(list.size(), 1);
            testCase.verifyEqual(list.get(1), 2);
            testCase.verifyEqual(removed, true);
            
            % Remove on last element in the list
            removed = list.remove(2);
            testCase.verifyEqual(list.size(), 0);
            testCase.verifyEqual(removed, true);
        end
        
      
    end
end