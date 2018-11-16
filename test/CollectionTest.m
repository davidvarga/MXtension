classdef (Abstract) CollectionTest < matlab.unittest.TestCase
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    
    methods(Abstract)
        collection = fromCollection(obj, collection)
        collection = ofElements(obj, varargin)
    end
    
    methods(Static, Access = protected, Sealed)
        function javaList = javaListOf(varargin)
            javaList = java.util.ArrayList();
            for i = 1:numel(varargin)
                javaList.add(varargin{i});
            end
        end
        
        function javaSet = javaSetOf(varargin)
            javaSet = java.util.HashSet();
            for i = 1:numel(varargin)
                javaSet.add(varargin{i});
            end
        end
    end
    
    methods(Test)
        
        % TODO: withIndex
        
        function test_forEach(testCase)
            calls = {};
            
            function op(item)
                calls{end+1} = item;
            end
            
            collection = testCase.ofElements(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
            collection.forEach(@(it) op(it));
            
            testCase.verifyLength(calls, 10);
            for i = 1:10
                testCase.assertEqual(calls{i}, i);
            end
            
        end
        
        function test_forEachIndexed(testCase)
            calls = {};
            
            function op(item, index)
                calls{end+1} = {item, index};
            end
            
            collection = testCase.ofElements(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
            collection.forEachIndexed(@(it, ind) op(it, ind));
            
            testCase.verifyLength(calls, 10);
            for i = 1:10
                cElem = calls{i};
                testCase.assertEqual(cElem{1}, i);
                testCase.assertEqual(cElem{2}, i);
            end
            
        end
        
        function test_contains(testCase)
            collection = testCase.ofElements(1, 2, 3);
            testCase.assertEqual(collection.contains(2), true);
            testCase.assertEqual(collection.contains(1), true);
            testCase.assertEqual(collection.contains(3), true);
            testCase.assertEqual(collection.contains(0), false);
            
            collection = testCase.ofElements('A', 'Bb', 'ccC');
            testCase.assertEqual(collection.contains('A'), true);
            testCase.assertEqual(collection.contains('Bb'), true);
            testCase.assertEqual(collection.contains('ccC'), true);
            testCase.assertEqual(collection.contains('a'), false);
            
        end
        
        function test_containsAll(testCase)
            collection = testCase.ofElements(1, 2, 3);
            testCase.assertEqual(collection.containsAll({1}), true);
            testCase.assertEqual(collection.containsAll({1, 2}), true);
            testCase.assertEqual(collection.containsAll({1, 2, 3}), true);
            testCase.assertEqual(collection.containsAll({1, 2, 3, 4}), false);
            
            collection = testCase.ofElements('A', 'Bb', 'ccC');
            testCase.assertEqual(collection.containsAll(testCase.ofElements('A')), true);
            testCase.assertEqual(collection.containsAll(testCase.ofElements('A', 'Bb')), true);
            testCase.assertEqual(collection.containsAll(testCase.ofElements('A', 'Bb', 'ccC')), true);
            testCase.assertEqual(collection.containsAll(testCase.ofElements('A', 'Bb', 'ccC', '')), false);
            
            collection = testCase.ofElements('a', 'b', 'c');
            
            testCase.assertEqual(collection.containsAll(testCase.javaListOf('a', 'b', 'c')), true);
            testCase.assertEqual(collection.containsAll(testCase.javaListOf('b', 'c')), true);
            testCase.assertEqual(collection.containsAll(testCase.javaListOf('c')), true);
            testCase.assertEqual(collection.containsAll(testCase.javaListOf()), true);
            testCase.assertEqual(collection.containsAll(testCase.javaListOf('a', 'b', 'c', 'd')), false);
        end
        
        function test_size(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3, 4, 5).size(), 5);
            testCase.assertEqual(testCase.fromCollection({}).size(), 0);
        end
        
        function test_count_without_parameter(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3, 4, 5).count(), 5);
            testCase.assertEqual(testCase.fromCollection({}).count(), 0);
        end
        
        function test_count_with_predicate(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3, 4, 5).count(@(x) x < 3), 2);
            testCase.assertEqual(testCase.ofElements(1, 2, 3, 4, 5).count(@(x) x > 2 && x < 4), 1);
            testCase.assertEqual(testCase.ofElements(1, 2, 3, 4, 5).count(@(x) x < 1), 0);
            testCase.assertEqual(testCase.fromCollection().count(@(x) true), 0);
        end
        
        function test_any(testCase)
            testCase.assertTrue(testCase.ofElements(1).any());
            testCase.assertFalse(testCase.ofElements().any());
            
            testCase.assertTrue(testCase.ofElements(1, 2, 3, 4, 5).any(@(x) x < 3));
            testCase.assertTrue(testCase.ofElements(1, 2, 3, 4, 5).any(@(x) x > 2 && x < 4));
            testCase.assertFalse(testCase.ofElements(1, 2, 3, 4, 5).any(@(x) x < 1));
            testCase.assertFalse(testCase.fromCollection({}).any(@(x) true));
        end
        
        function test_all(testCase)
            testCase.assertFalse(testCase.ofElements(1, 2, 3, 4, 5).all(@(x) x < 3));
            testCase.assertFalse(testCase.ofElements(1, 2, 3, 4, 5).all(@(x) x > 2 && x < 4));
            testCase.assertFalse(testCase.ofElements(1, 2, 3, 4, 5).all(@(x) x < 1));
            testCase.assertTrue(testCase.ofElements(1, 2, 3, 4, 5).all(@(x) x >= 1 && x <= 5));
            testCase.assertTrue(testCase.fromCollection().all(@(x) false));
        end
        
        function test_none(testCase)
            testCase.assertFalse(testCase.ofElements(1).none());
            testCase.assertTrue(testCase.ofElements().none());
            
            testCase.assertFalse(testCase.ofElements(1, 2, 3, 4, 5).none(@(x) x < 3));
            testCase.assertFalse(testCase.ofElements(1, 2, 3, 4, 5).none(@(x) x > 2 && x < 4));
            testCase.assertTrue(testCase.ofElements(1, 2, 3, 4, 5).none(@(x) x < 1));
            testCase.assertFalse(testCase.ofElements(1, 2, 3, 4, 5).none(@(x) x >= 1 && x <= 5));
            testCase.assertTrue(testCase.ofElements().none(@(x) false));
        end
        
        function test_isEmpty(testCase)
            testCase.assertEqual(testCase.ofElements(1), false);
            testCase.assertEqual(testCase.ofElements(), true);
        end
        
        function test_isNotEmpty(testCase)
            testCase.assertEqual(testCase.ofElements(1), true);
            testCase.assertEqual(testCase.ofElements(), false);
        end
        
        function test_first(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).first(), 1);
            testCase.assertEqual(testCase.ofElements('a', 'b').first(), 'a');
            try
                testCase.ofElements().first();
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:NoSuchElementException');
                testCase.assertEqual(ex.message, 'The collection is empty.');
            end
            
            
            testCase.assertEqual(testCase.ofElements(1, 2, 3).first(@(x) x > 2), 3);
            testCase.assertEqual(testCase.ofElements('a', 'b').first(@(x) strcmp(x, 'a')), 'a');
            try
                testCase.ofElements().first(@(x) true);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:NoSuchElementException');
                testCase.assertEqual(ex.message, 'The collection is empty.');
            end
            try
                testCase.ofElements(1,2,3).first(@(x) x > 3);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:NoSuchElementException');
                testCase.assertEqual(ex.message, 'No element matches the given predicate.');
            end
        end
        
        function test_firstOrNull(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).firstOrNull(), 1);
            testCase.assertEqual(testCase.ofElements('a', 'b').firstOrNull(), 'a');
            testCase.assertEqual(testCase.ofElements().firstOrNull(), []);
            
            testCase.assertEqual(testCase.ofElements(1, 2, 3).firstOrNull(@(x) x > 2), 3);
            testCase.assertEqual(testCase.ofElements('a', 'b').firstOrNull(@(x) strcmp(x, 'a')), 'a');
            testCase.assertEqual(testCase.ofElements(1,2,3).firstOrNull(@(x) x > 3), []);
            testCase.assertEqual(testCase.ofElements().firstOrNull(@(x) true), []);
        end
        
        function test_last(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).last(), 3);
            testCase.assertEqual(testCase.ofElements('a', 'b').last(), 'b');
            try
                testCase.ofElements().last();
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:NoSuchElementException');
                testCase.assertEqual(ex.message, 'The collection is empty.');
            end
            
            
            testCase.assertEqual(testCase.ofElements(1, 2, 3).last(@(x) x > 1), 3);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).last(@(x) x < 2), 1);
            testCase.assertEqual(testCase.ofElements('a', 'b').last(@(x) strcmp(x, 'a')), 'a');
            try
                testCase.ofElements().last(@(x) true);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:NoSuchElementException');
                testCase.assertEqual(ex.message, 'The collection is empty.');
            end
            try
                testCase.ofElements(1,2,3).last(@(x) x > 3);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:NoSuchElementException');
                testCase.assertEqual(ex.message, 'No element matches the given predicate.');
            end
        end
        
        function test_lastOrNull(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).lastOrNull(), 3);
            testCase.assertEqual(testCase.ofElements('a', 'b').lastOrNull(), 'b');
            testCase.assertEqual(testCase.ofElements().lastOrNull(), []);

            testCase.assertEqual(testCase.ofElements(1, 2, 3).lastOrNull(@(x) x > 2), 3);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).lastOrNull(@(x) x < 2), 1);
            testCase.assertEqual(testCase.ofElements('a', 'b').lastOrNull(@(x) strcmp(x, 'a')), 'a');
            testCase.assertEqual(testCase.ofElements(1,2,3).lastOrNull(@(x) x > 3), []);
            testCase.assertEqual(testCase.ofElements().lastOrNull(@(x) true), []);
        end
        
        
        function test_indexOf(testCase)
            list = testCase.ofElements(1, 2, 2, 3, 2, 3);
            testCase.assertEqual(list.indexOf(2), 2);
            testCase.assertEqual(list.indexOf(1), 1);
            testCase.assertEqual(list.indexOf(3), 4);
            testCase.assertEqual(list.indexOf(0), -1);
            testCase.assertEqual(list.indexOf('123'), -1);
            
            list = testCase.ofElements('A', 'a', 'bb', 'bb', 'a', 'z');
            testCase.assertEqual(list.indexOf('a'), 2);
            testCase.assertEqual(list.indexOf('A'), 1);
            testCase.assertEqual(list.indexOf('bb'), 3);
            testCase.assertEqual(list.indexOf('z'), 6);
            testCase.assertEqual(list.indexOf(0), -1);
            testCase.assertEqual(list.indexOf('123'), -1);
        end
        
        function test_lastIndexOf(testCase)
            list = testCase.ofElements(1, 2, 2, 3, 2, 3);
            testCase.assertEqual(list.lastIndexOf(2), 5);
            testCase.assertEqual(list.lastIndexOf(1), 1);
            testCase.assertEqual(list.lastIndexOf(3), 6);
            testCase.assertEqual(list.lastIndexOf(0), -1);
            testCase.assertEqual(list.lastIndexOf('123'), -1);
            
            list = testCase.ofElements('A', 'a', 'bb', 'bb', 'a', 'z');
            testCase.assertEqual(list.lastIndexOf('a'), 5);
            testCase.assertEqual(list.lastIndexOf('A'), 1);
            testCase.assertEqual(list.lastIndexOf('bb'), 4);
            testCase.assertEqual(list.lastIndexOf('z'), 6);
            testCase.assertEqual(list.lastIndexOf(0), -1);
            testCase.assertEqual(list.lastIndexOf('123'), -1);
        end
        
        
    end
    
end
