
classdef ArrayListTest < CollectionTest & matlab.unittest.TestCase
    
    methods
        function classUnderTest = classUnderTest(obj)
            classUnderTest = 'MXtension.Collections.ArrayList';
        end
    end
    

    methods (Test)

        function test_list_constructed_with_ofSize(testCase)      
            list = MXtension.Collections.ArrayList.ofSize(3);
            testCase.verifyEqual(list.size(), 3);
            testCase.verifyEqual(list.get(1), []);
            testCase.verifyEqual(list.get(2), []);
            testCase.verifyEqual(list.get(3), []);
           
            list = MXtension.Collections.ArrayList.ofSize(0);
            testCase.verifyEqual(list.size(), 0);
        end
        
        
        function test_add(testCase)      
            list = MXtension.Collections.ArrayList.ofElements();
            list.add('newelement');
            testCase.verifyEqual(list.size(), 1);
            testCase.verifyEqual(list.get(1), 'newelement');
            list.add(123);
            testCase.verifyEqual(list.size(), 2);
            testCase.verifyEqual(list.get(2), 123);
        end
        
        function test_insert(testCase)      
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
        
        function test_addAll(testCase)      
            list = MXtension.Collections.ArrayList.ofElements();
            list.addAll({'newelement1', 'newelement2'});
            testCase.verifyEqual(list.size(), 2);
            testCase.verifyEqual(list.get(1), 'newelement1');
            testCase.verifyEqual(list.get(2), 'newelement2');
            list.addAll(MXtension.Collections.ArrayList.fromCollection({1, 2}));
            testCase.verifyEqual(list.size(), 4);
            testCase.verifyEqual(list.get(1), 'newelement1');
            testCase.verifyEqual(list.get(2), 'newelement2');
            testCase.verifyEqual(list.get(3), 1);
            testCase.verifyEqual(list.get(4), 2);
            javaList = java.util.ArrayList();
            javaList.add('a');
            javaList.add('b');
            list.addAll(javaList);
            testCase.verifyEqual(list.size(), 6);
            testCase.verifyEqual(list.get(1), 'newelement1');
            testCase.verifyEqual(list.get(2), 'newelement2');
            testCase.verifyEqual(list.get(3), 1);
            testCase.verifyEqual(list.get(4), 2);
            testCase.verifyEqual(list.get(5), 'a');
            testCase.verifyEqual(list.get(6), 'b');
        end
        
        function test_insertAll(testCase)      
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
        
        function test_set(testCase)      
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
        
        
        function test_removeAt(testCase)      
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
        
        function test_remove(testCase)      
            list = MXtension.Collections.ArrayList.ofElements(1, 2, 2, 4);
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
        
        function test_removeAll_with_Collection(testCase)      
            list = MXtension.Collections.ArrayList.ofElements(1, 2, 2, 3, 4);
            
            % Try to remove not existing
            removed = list.removeAll({0});
            testCase.verifyEqual(list.size(), 5);
            testCase.verifyEqual(list.get(1), 1);
            testCase.verifyEqual(list.get(2), 2);
            testCase.verifyEqual(list.get(3), 2);
            testCase.verifyEqual(list.get(4), 3);
            testCase.verifyEqual(list.get(5), 4);
            testCase.verifyEqual(removed, false);
            
            % Remove in the middle
            removed = list.removeAll({2});
            testCase.verifyEqual(list.size(), 3);
            testCase.verifyEqual(list.get(1), 1);
            testCase.verifyEqual(list.get(2), 3);
            testCase.verifyEqual(list.get(3), 4);
            testCase.verifyEqual(removed, true);
            
            % Remove on first index
            removed = list.removeAll({1});
            testCase.verifyEqual(list.size(), 2);
            testCase.verifyEqual(list.get(1), 3);
            testCase.verifyEqual(list.get(2), 4);
            testCase.verifyEqual(removed, true);
            
            % Remove on last index
            removed = list.removeAll({4});
            testCase.verifyEqual(list.size(), 1);
            testCase.verifyEqual(list.get(1), 3);
            testCase.verifyEqual(removed, true);
            
            % Remove on last element in the list
            removed = list.removeAll({3});
            testCase.verifyEqual(list.size(), 0);
            testCase.verifyEqual(removed, true);
        end
        
        function test_removeAll_with_Predicate(testCase)      
            list = MXtension.Collections.ArrayList.ofElements(1, 2, 2, 3, 4);
            
            % Try to remove not existing
            removed = list.removeAll(@(e) e > 4);
            testCase.verifyEqual(list.size(), 5);
            testCase.verifyEqual(list.get(1), 1);
            testCase.verifyEqual(list.get(2), 2);
            testCase.verifyEqual(list.get(3), 2);
            testCase.verifyEqual(list.get(4), 3);
            testCase.verifyEqual(list.get(5), 4);
            testCase.verifyEqual(removed, false);
            
            % Remove in the middle
            removed = list.removeAll(@(e) e == 2);
            testCase.verifyEqual(list.size(), 3);
            testCase.verifyEqual(list.get(1), 1);
            testCase.verifyEqual(list.get(2), 3);
            testCase.verifyEqual(list.get(3), 4);
            testCase.verifyEqual(removed, true);
            
            % Remove on first index
            removed = list.removeAll(@(e) e == 1);
            testCase.verifyEqual(list.size(), 2);
            testCase.verifyEqual(list.get(1), 3);
            testCase.verifyEqual(list.get(2), 4);
            testCase.verifyEqual(removed, true);
            
            % Remove on last index
            removed = list.removeAll(@(e) mod(e,2) == 0);
            testCase.verifyEqual(list.size(), 1);
            testCase.verifyEqual(list.get(1), 3);
            testCase.verifyEqual(removed, true);
            
            % Remove on last element in the list
            removed = list.removeAll(@(e) mod(e,2) == 1);
            testCase.verifyEqual(list.size(), 0);
            testCase.verifyEqual(removed, true);
        end
        
        % TODO: retainsAll_with_collection
        
        % TODO: retainsAll_with_predicate
        
        function test_clear(testCase)      
            list = MXtension.Collections.ArrayList.ofElements(1, 2, 2, 3, 4);
            list.clear();
            testCase.verifyEqual(list.size(), 0);
            list.clear();
            testCase.verifyEqual(list.size(), 0);
            
        end
      
        
        %% 
        
        function test_fill(testCase)      
            list = MXtension.Collections.ArrayList.ofElements(1, 2, 2, 3, 4);
            list.fill('a');
            for i = 1:list.size()
                testCase.assertEqual(list.get(i), 'a');
            end
           list = MXtension.Collections.ArrayList.fromCollection({});
            list.fill('a');
            testCase.verifyEqual(list.size(), 0);
            
        end
        
        function test_reverse(testCase)      
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