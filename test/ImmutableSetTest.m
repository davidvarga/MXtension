%% Test Class Definition
classdef ImmutableSetTest < CollectionTest & matlab.unittest.TestCase
    
    methods
          
        function collection = fromCollection(obj, collection)
            collection = MXtension.Collections.ImmutableSet.fromCollection(collection);
        end
        
        function collection = ofElements(obj, varargin)
            collection = MXtension.Collections.ImmutableSet.ofElements(varargin{:});
        end
    
     
    end
    
    %% Test Method Block
    methods (Test)
        % Override because of element uniqeness
        function test_indexOfLast(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).indexOfLast(@(x) x > 2), 3);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).indexOfLast(@(x) x < 2), 1);
            testCase.assertEqual(testCase.ofElements('a', 'b').indexOfLast(@(x) strcmp(x, 'a')), 1);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).indexOfLast(@(x) x > 3), -1);
            testCase.assertEqual(testCase.ofElements().indexOfLast(@(x) true), -1);
        end
        
        % Override because of element uniqeness
        function test_indexOf(testCase)
            collection = testCase.ofElements(1, 2, 3);
            testCase.assertEqual(collection.indexOf(2), 2);
            testCase.assertEqual(collection.indexOf(1), 1);
            testCase.assertEqual(collection.indexOf(3), 3);
            testCase.assertEqual(collection.indexOf(0), -1);
            testCase.assertEqual(collection.indexOf('123'), -1);
            
            collection = testCase.ofElements('A', 'a', 'bb', 'z');
            testCase.assertEqual(collection.indexOf('a'), 2);
            testCase.assertEqual(collection.indexOf('A'), 1);
            testCase.assertEqual(collection.indexOf('bb'), 3);
            testCase.assertEqual(collection.indexOf('z'), 4);
            testCase.assertEqual(collection.indexOf(0), -1);
            testCase.assertEqual(collection.indexOf('123'), -1);
        end
        
        % Override because of element uniqeness
        function test_lastIndexOf(testCase)
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
        % Override because of element uniqeness
        function test_mapNotNull(testCase)
            % Mapping empty collection creates an empty list
            emptyList = testCase.ofElements().mapNotNull(@(e) e);
            testCase.mustBeList(emptyList);
            testCase.assertEqual(emptyList.size(), 0);
            
            % List containing nulls 
            list = testCase.ofElements(1, [], 2, [], [], 3, 4, 5, []).mapNotNull(@(e) e);
            testCase.mustBeList(list);
            for i = 1:5
               testCase.assertEqual(list.get(i), i); 
            end
            testCase.assertEqual(list.size(), 5);
            
            list = testCase.ofElements('a', 'bb', 'ccc').mapNotNull(@(elem) numel(elem));
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 3);
            for i = 1:3
               testCase.assertEqual(list.get(i), i); 
            end
            
            % List containing nulls 
            list = testCase.ofElements(0, [], '', [], [], 0, struct()).mapNotNull(@(e) e);
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 0); 
            testCase.assertEqual(list.get(2), ''); 
            testCase.assertEqual(list.get(3), struct()); 
            testCase.assertEqual(list.size(), 3);
         end
        
         function test_mapNotEmpty(testCase)
            % Mapping empty collection creates an empty list
            emptyList = testCase.ofElements().mapNotEmpty(@(e) e);
            testCase.mustBeList(emptyList);
            testCase.assertEqual(emptyList.size(), 0);
            
            % List containing nulls 
            list = testCase.ofElements(1, [], 2, [], [], 3, 4, 5, []).mapNotEmpty(@(e) e);
            testCase.mustBeList(list);
            for i = 1:5
               testCase.assertEqual(list.get(i), i); 
            end
            testCase.assertEqual(list.size(), 5);
            
            list = testCase.ofElements('a', 'bb', 'ccc').mapNotEmpty(@(elem) numel(elem));
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 3);
            for i = 1:3
               testCase.assertEqual(list.get(i), i); 
            end
            
            % List containing nulls 
            list = testCase.ofElements(0, [], '', [], '', [], 0, {}, {'a'}).mapNotEmpty(@(e) e);
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 0); 
            testCase.assertEqual(list.get(2), {'a'}); 
            testCase.assertEqual(list.size(), 2);
        end
        
      
    end
end