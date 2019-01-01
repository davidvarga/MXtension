
classdef ArrayListTest < MutableCollectionTest & matlab.unittest.TestCase
    methods
        function classUnderTest = classUnderTest(obj)
            classUnderTest = 'MXtension.Collections.ArrayList';
        end
    end

    methods (Test)
         
        
        
        function insert(testCase)      
            list = MXtension.Collections.ArrayList.ofElements(1, 2, 3);
            list.insert(1, 'newelement');
            testCase.verifyEqual(list.size(), 4);
            testCase.verifyEqual(list.get(1), 'newelement');
            list.insert(3, 123);
            testCase.verifyEqual(list.size(), 5);
            testCase.verifyEqual(list.get(3), 123);
            list.insert(5, 999);
            testCase.verifyEqual(list.size(), 6);
            testCase.verifyEqual(list.get(5), 999);
        end
  
        function insertAll(testCase)      
            list = MXtension.Collections.ArrayList.ofElements('orig1', 'orig2');
            list.insertAll(1, {'newelement1', 'newelement2'});
            testCase.verifyEqual(list.size(), 4);
            testCase.verifyEqual(list.get(1), 'newelement1');
            testCase.verifyEqual(list.get(2), 'newelement2');
            testCase.verifyEqual(list.get(3), 'orig1');
            testCase.verifyEqual(list.get(4), 'orig2');
            list.insertAll(3, MXtension.Collections.ArrayList.fromCollection({1, 2}));
            testCase.verifyEqual(list.size(), 6);
            testCase.verifyEqual(list.get(1), 'newelement1');
            testCase.verifyEqual(list.get(2), 'newelement2');
            testCase.verifyEqual(list.get(3), 1);
            testCase.verifyEqual(list.get(4), 2);
            testCase.verifyEqual(list.get(5), 'orig1');
            testCase.verifyEqual(list.get(6), 'orig2');
            javaList = java.util.ArrayList();
            javaList.add('a');
            javaList.add('b');
            list.insertAll(7, javaList);
            testCase.verifyEqual(list.size(), 8);
            testCase.verifyEqual(list.get(1), 'newelement1');
            testCase.verifyEqual(list.get(2), 'newelement2');
            testCase.verifyEqual(list.get(3), 1);
            testCase.verifyEqual(list.get(4), 2);
            testCase.verifyEqual(list.get(5), 'orig1');
            testCase.verifyEqual(list.get(6), 'orig2');
            testCase.verifyEqual(list.get(7), 'a');
            testCase.verifyEqual(list.get(8), 'b');
        end
        
        function set(testCase)      
            list = MXtension.Collections.ArrayList.ofElements(1,2,3);
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
        
        
        function removeAt(testCase)      
            list = MXtension.Collections.ArrayList.ofElements(1, 2, 3, 4);
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
        
      
        
        %% 
        
        function fill(testCase)      
            list = MXtension.Collections.ArrayList.ofElements(1, 2, 2, 3, 4);
            list.fill('a');
            for i = 1:list.size()
                testCase.assertEqual(list.get(i), 'a');
            end
           list = MXtension.Collections.ArrayList.fromCollection({});
            list.fill('a');
            testCase.verifyEqual(list.size(), 0);
            
        end
        
        function reverse(testCase)      
            testCell = {1, 2, 2, 3, 4};
            list = MXtension.Collections.ArrayList.fromCollection(testCell);
            list.reverse();
            for i = 1:list.size()
                testCase.verifyEqual(list.get(i), testCell{end-i+1});
            end
           list = MXtension.Collections.ArrayList.fromCollection({});
            list.reverse();
            testCase.verifyEqual(list.size(), 0);
            
        end
        
        
      
    end
end