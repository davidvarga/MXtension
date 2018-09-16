%% Test Class Definition
classdef ArrayListTest < matlab.unittest.TestCase
    
    %% Test Method Block
    methods (Test)
        
        % TODO: list = MXtension.Collections.ArrayList.fromCollection();
            
        % TODO: list =  MXtension.Collections.ArrayList.fromCollection(1);
            
        % TODO: list =  MXtension.Collections.ArrayList.fromCollection(cell, cell);
        
        function test_list_constructed_with_ofCollection_CellArray(testCase)      
            list = MXtension.Collections.ArrayList.fromCollection({1,2,3});
            testCase.verifyEqual(list.size(), 3);
            testCase.verifyEqual(list.get(1), 1);
            testCase.verifyEqual(list.get(2), 2);
            testCase.verifyEqual(list.get(3), 3);
            
            list = MXtension.Collections.ArrayList.fromCollection({});
            testCase.verifyEqual(list.size(), 0);
        end
        
        function test_list_constructed_with_ofCollection_MXtensionList(testCase)      
            inputList = MXtension.Collections.ArrayList.fromCollection({1,2,3});
            
            list = MXtension.Collections.ArrayList.fromCollection(inputList);
            testCase.verifyEqual(list.size(), 3);
            testCase.verifyEqual(list.get(1), 1);
            testCase.verifyEqual(list.get(2), 2);
            testCase.verifyEqual(list.get(3), 3);
            
            inputList = MXtension.Collections.ArrayList.fromCollection({});
            
            list = MXtension.Collections.ArrayList.fromCollection(inputList);
            testCase.verifyEqual(list.size(), 0);
        end
        
        function test_list_constructed_with_ofCollection_Java_Collection(testCase)      
            javaCollection = java.util.ArrayList();
            javaCollection.add('a');
            javaCollection.add('b');
            javaCollection.add('c');
            
            list = MXtension.Collections.ArrayList.fromCollection(javaCollection);
            testCase.verifyEqual(list.size(), 3);
            testCase.verifyEqual(list.get(1), 'a');
            testCase.verifyEqual(list.get(2), 'b');
            testCase.verifyEqual(list.get(3), 'c');
           
            list = MXtension.Collections.ArrayList.fromCollection(java.util.ArrayList());
            testCase.verifyEqual(list.size(), 0);
        end
        
        function test_list_constructed_with_ofSize(testCase)      
            list = MXtension.Collections.ArrayList.ofSize(3);
            testCase.verifyEqual(list.size(), 3);
            testCase.verifyEqual(list.get(1), []);
            testCase.verifyEqual(list.get(2), []);
            testCase.verifyEqual(list.get(3), []);
           
            list = MXtension.Collections.ArrayList.ofSize(0);
            testCase.verifyEqual(list.size(), 0);
        end
        
        function test_list_constructed_with_ofElements(testCase)      
            list = MXtension.Collections.ArrayList.ofElements('a', 1, 'b');
            testCase.verifyEqual(list.size(), 3);
            testCase.verifyEqual(list.get(1), 'a');
            testCase.verifyEqual(list.get(2), 1);
            testCase.verifyEqual(list.get(3), 'b');
            
            list = MXtension.Collections.ArrayList.ofElements({1,2,3}, {4,5,6});
            testCase.verifyEqual(list.size(), 2);
            testCase.verifyEqual(list.get(1), {1,2,3});
            testCase.verifyEqual(list.get(2), {4,5,6});
            
            list = MXtension.Collections.ArrayList.ofElements();
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
        
        function test_indexOf(testCase)      
            list = MXtension.Collections.ArrayList.ofElements(1, 2, 2, 3, 2, 3);
            testCase.verifyEqual(list.indexOf(2), 2);
            testCase.verifyEqual(list.indexOf(1), 1);
            testCase.verifyEqual(list.indexOf(3), 4);
            testCase.verifyEqual(list.indexOf(0), -1);
            testCase.verifyEqual(list.indexOf('123'), -1);
            
             list = MXtension.Collections.ArrayList.ofElements('A', 'a', 'bb', 'bb', 'a', 'z');
            testCase.verifyEqual(list.indexOf('a'), 2);
            testCase.verifyEqual(list.indexOf('A'), 1);
            testCase.verifyEqual(list.indexOf('bb'), 3);
            testCase.verifyEqual(list.indexOf('z'), 6);
            testCase.verifyEqual(list.indexOf(0), -1);
            testCase.verifyEqual(list.indexOf('123'), -1);            
        end
        
        function test_lastIndexOf(testCase)      
            list = MXtension.Collections.ArrayList.ofElements(1, 2, 2, 3, 2, 3);
            testCase.verifyEqual(list.lastIndexOf(2), 5);
            testCase.verifyEqual(list.lastIndexOf(1), 1);
            testCase.verifyEqual(list.lastIndexOf(3), 6);
            testCase.verifyEqual(list.lastIndexOf(0), -1);
            testCase.verifyEqual(list.lastIndexOf('123'), -1);
            
             list = MXtension.Collections.ArrayList.ofElements('A', 'a', 'bb', 'bb', 'a', 'z');
            testCase.verifyEqual(list.lastIndexOf('a'), 5);
            testCase.verifyEqual(list.lastIndexOf('A'), 1);
            testCase.verifyEqual(list.lastIndexOf('bb'), 4);
            testCase.verifyEqual(list.lastIndexOf('z'), 6);
            testCase.verifyEqual(list.lastIndexOf(0), -1);
            testCase.verifyEqual(list.lastIndexOf('123'), -1);            
        end
        
        function test_isEmpty(testCase)      
            list = MXtension.Collections.ArrayList.ofElements(1);
            testCase.verifyEqual(list.isEmpty(), false);
            
            list = MXtension.Collections.ArrayList.ofElements();
            testCase.verifyEqual(list.isEmpty(), true);
           
        end
        
        function test_contains(testCase)      
            list = MXtension.Collections.ArrayList.ofElements(1, 2, 3);
            testCase.verifyEqual(list.contains(2), true);
            testCase.verifyEqual(list.contains(1), true);
            testCase.verifyEqual(list.contains(3), true);
            testCase.verifyEqual(list.contains(0), false);
            
            list = MXtension.Collections.ArrayList.ofElements('A', 'Bb', 'ccC');
            testCase.verifyEqual(list.contains('A'), true);
            testCase.verifyEqual(list.contains('Bb'), true);
            testCase.verifyEqual(list.contains('ccC'), true);
            testCase.verifyEqual(list.contains('a'), false);
           
        end
        
        function test_containsAll(testCase)      
            list = MXtension.Collections.ArrayList.ofElements(1, 2, 3);
            testCase.verifyEqual(list.containsAll({1}), true);
            testCase.verifyEqual(list.containsAll({1,2}), true);
            testCase.verifyEqual(list.containsAll({1,2, 3}), true);
           testCase.verifyEqual(list.containsAll({1,2, 3, 4}), false);
            
            list = MXtension.Collections.ArrayList.ofElements('A', 'Bb', 'ccC');
            testCase.verifyEqual(list.containsAll(MXtension.Collections.ArrayList.ofElements('A')), true);
            testCase.verifyEqual(list.containsAll(MXtension.Collections.ArrayList.ofElements('A', 'Bb')), true);
            testCase.verifyEqual(list.containsAll(MXtension.Collections.ArrayList.ofElements('A', 'Bb', 'ccC')), true);
            testCase.verifyEqual(list.containsAll(MXtension.Collections.ArrayList.ofElements('A', 'Bb', 'ccC', '')), false);
            
             list = MXtension.Collections.ArrayList.ofElements('a', 'b', 'c');
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
        
        function test_size(testCase)      
            list = MXtension.Collections.ArrayList.ofElements(1, 2, 2, 3, 4);
     
            testCase.verifyEqual(list.size(), 5);
            list = MXtension.Collections.ArrayList.fromCollection({});
            testCase.verifyEqual(list.size(), 0);
            
        end
        
        
        %% 
        
        function test_fill(testCase)      
            list = MXtension.Collections.ArrayList.ofElements(1, 2, 2, 3, 4);
            list.fill('a');
            for i = 1:list.size()
                testCase.verifyEqual(list.get(i), 'a');
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