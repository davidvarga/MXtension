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
    
    methods(Access = protected, Sealed)
        function mustBeList(obj, list)
            obj.assertTrue(isa(list, 'MXtension.Collections.List'));
            obj.assertFalse(isa(list, 'MXtension.Collections.MutableList'));
        end
        
        function mustBeSet(obj, set)
            obj.assertTrue(isa(set, 'MXtension.Collections.Set'));
            obj.assertFalse(isa(set, 'MXtension.Collections.MutableSet'));
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
            testCase.assertEqual(testCase.ofElements().size(), 0);
        end
        
        function test_count_without_parameter(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3, 4, 5).count(), 5);
            testCase.assertEqual(testCase.ofElements().count(), 0);
        end
        
        function test_count_with_predicate(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3, 4, 5).count(@(x) x < 3), 2);
            testCase.assertEqual(testCase.ofElements(1, 2, 3, 4, 5).count(@(x) x > 2 && x < 4), 1);
            testCase.assertEqual(testCase.ofElements(1, 2, 3, 4, 5).count(@(x) x < 1), 0);
            testCase.assertEqual(testCase.ofElements().count(@(x) true), 0);
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
            testCase.assertTrue(testCase.ofElements().all(@(x) false));
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
            testCase.assertEqual(testCase.ofElements(1).isEmpty(), false);
            testCase.assertEqual(testCase.ofElements().isEmpty(), true);
        end
        
        function test_isNotEmpty(testCase)
            testCase.assertEqual(testCase.ofElements(1).isNotEmpty(), true);
            testCase.assertEqual(testCase.ofElements().isNotEmpty(), false);
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
                testCase.ofElements(1, 2, 3).first(@(x) x > 3);
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
            testCase.assertEqual(testCase.ofElements(1, 2, 3).firstOrNull(@(x) x > 3), []);
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
                testCase.ofElements(1, 2, 3).last(@(x) x > 3);
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
            testCase.assertEqual(testCase.ofElements(1, 2, 3).lastOrNull(@(x) x > 3), []);
            testCase.assertEqual(testCase.ofElements().lastOrNull(@(x) true), []);
        end
        
        function test_find(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).find(@(x) x > 2), 3);
            testCase.assertEqual(testCase.ofElements('a', 'b').find(@(x) strcmp(x, 'a')), 'a');
            testCase.assertEqual(testCase.ofElements(1, 2, 3).find(@(x) x > 3), []);
            testCase.assertEqual(testCase.ofElements().find(@(x) true), []);
        end
        
        function test_findLast(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).findLast(@(x) x > 2), 3);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).findLast(@(x) x < 2), 1);
            testCase.assertEqual(testCase.ofElements('a', 'b').findLast(@(x) strcmp(x, 'a')), 'a');
            testCase.assertEqual(testCase.ofElements(1, 2, 3).findLast(@(x) x > 3), []);
            testCase.assertEqual(testCase.ofElements().findLast(@(x) true), []);
        end
        
        function test_indexOfFirst(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3, 3).indexOfFirst(@(x) x > 2), 3);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).indexOfFirst(@(x) x > 2), 3);
            testCase.assertEqual(testCase.ofElements('a', 'b').indexOfFirst(@(x) strcmp(x, 'a')), 1);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).indexOfFirst(@(x) x > 3), -1);
            testCase.assertEqual(testCase.ofElements().indexOfFirst(@(x) true), -1);
        end
        
        function test_indexOfLast(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).indexOfLast(@(x) x > 2), 3);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).indexOfLast(@(x) x < 2), 1);
            testCase.assertEqual(testCase.ofElements(1, 2, 3, 1).indexOfLast(@(x) x < 2), 4);
            testCase.assertEqual(testCase.ofElements('a', 'b').indexOfLast(@(x) strcmp(x, 'a')), 1);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).indexOfLast(@(x) x > 3), -1);
            testCase.assertEqual(testCase.ofElements().indexOfLast(@(x) true), -1);
        end
        
        function test_indexOf(testCase)
            collection = testCase.ofElements(1, 2, 2, 3, 2, 3);
            testCase.assertEqual(collection.indexOf(2), 2);
            testCase.assertEqual(collection.indexOf(1), 1);
            testCase.assertEqual(collection.indexOf(3), 4);
            testCase.assertEqual(collection.indexOf(0), -1);
            testCase.assertEqual(collection.indexOf('123'), -1);
            
            collection = testCase.ofElements('A', 'a', 'bb', 'bb', 'a', 'z');
            testCase.assertEqual(collection.indexOf('a'), 2);
            testCase.assertEqual(collection.indexOf('A'), 1);
            testCase.assertEqual(collection.indexOf('bb'), 3);
            testCase.assertEqual(collection.indexOf('z'), 6);
            testCase.assertEqual(collection.indexOf(0), -1);
            testCase.assertEqual(collection.indexOf('123'), -1);
        end
        
        function test_lastIndexOf(testCase)
            collection = testCase.ofElements(1, 2, 2, 3, 2, 3);
            testCase.assertEqual(collection.lastIndexOf(2), 5);
            testCase.assertEqual(collection.lastIndexOf(1), 1);
            testCase.assertEqual(collection.lastIndexOf(3), 6);
            testCase.assertEqual(collection.lastIndexOf(0), -1);
            testCase.assertEqual(collection.lastIndexOf('123'), -1);
            
            collection = testCase.ofElements('A', 'a', 'bb', 'bb', 'a', 'z');
            testCase.assertEqual(collection.lastIndexOf('a'), 5);
            testCase.assertEqual(collection.lastIndexOf('A'), 1);
            testCase.assertEqual(collection.lastIndexOf('bb'), 4);
            testCase.assertEqual(collection.lastIndexOf('z'), 6);
            testCase.assertEqual(collection.lastIndexOf(0), -1);
            testCase.assertEqual(collection.lastIndexOf('123'), -1);
        end
        
        function test_elementAt(testCase)
            collection = testCase.ofElements(1, 2, 3, 4, 5);
            for i = 1:5
                testCase.assertEqual(collection.elementAt(i), i);
            end
            try
                collection.elementAt(6);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at index 6');
            end
        end
        
        function test_elementAtOrElse(testCase)
            collection = testCase.ofElements(1, 2, 3, 4, 5);
            for i = 1:10
                testCase.assertEqual(collection.elementAtOrElse(i, @(ind) ind), i);
            end
            
            for i = 1:10
                testCase.assertEqual(collection.elementAtOrElse(i, i), i);
            end
        end
        
        function test_elementAtOrNull(testCase)
            collection = testCase.ofElements(1, 2, 3, 4, 5);
            for i = 1:5
                testCase.assertEqual(collection.elementAtOrNull(i), i);
            end
            
            for i = 6:10
                testCase.assertEqual(collection.elementAtOrNull(i), []);
            end
        end
        
        function test_filter(testCase)
            testCase.assertEqual(testCase.ofElements().filter(@(x) true).size(), 0);
            list = testCase.ofElements(1, 2, 3, 4, 5).filter(@(x) mod(x, 2) == 0);
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 2);
            testCase.assertEqual(list.get(2), 4);
            testCase.assertEqual(list.size(), 2);
        end
        
        function test_filterNot(testCase)
            testCase.assertEqual(testCase.ofElements().filterNot(@(x) true).size(), 0);
            list = testCase.ofElements(1, 2, 3, 4, 5).filterNot(@(x) mod(x, 2) == 0);
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 1);
            testCase.assertEqual(list.get(2), 3);
            testCase.assertEqual(list.get(3), 5);
            testCase.assertEqual(list.size(), 3);
        end
        
        function test_filterNotNull(testCase)
            testCase.assertEqual(testCase.ofElements().filterNotNull().size, 0);
            list = testCase.ofElements(0, 1, [], 3, [], 5, '').filterNotNull();
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 0);
            testCase.assertEqual(list.get(2), 1);
            testCase.assertEqual(list.get(3), 3);
            testCase.assertEqual(list.get(4), 5);
            testCase.assertEqual(list.get(5), '');
            testCase.assertEqual(list.size(), 5);
        end
        
        function test_filterNotEmpty(testCase)
            testCase.assertEqual(testCase.ofElements().filterNotEmpty().size, 0);
            list = testCase.ofElements(0, 1, [], 3, [], 5, '').filterNotEmpty();
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 0);
            testCase.assertEqual(list.get(2), 1);
            testCase.assertEqual(list.get(3), 3);
            testCase.assertEqual(list.get(4), 5);
            testCase.assertEqual(list.size(), 4);
        end
        
        function test_filterIsTypeOf(testCase)
            testCase.assertEqual(testCase.ofElements().filterIsTypeOf('char').size, 0);
            list = testCase.ofElements(0, 1, [], 3, [], 5, '').filterIsTypeOf('char');
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), '');
            testCase.assertEqual(list.size(), 1);
            list = testCase.ofElements(1, 2, 3, 4, 5).filterIsTypeOf('double');
            testCase.mustBeList(list);
            for i = 1:5
                testCase.assertEqual(list.get(i), i);
            end
            testCase.assertEqual(list.size(), 5);
        end
        
        function test_filterIndexed(testCase)
            testCase.assertEqual(testCase.ofElements().filterIndexed(@(ind, x) true).size(), 0);
            list = testCase.ofElements('a', 'b', 'c', 'd', 'e').filterIndexed(@(ind, x) mod(ind, 2) == 0);
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 'b');
            testCase.assertEqual(list.get(2), 'd');
            testCase.assertEqual(list.size(), 2);
        end
        
        function test_take(testCase)
            testCase.assertEqual(testCase.ofElements().take(5).size(), 0);
            testCase.assertEqual(testCase.ofElements(1).take(0).size(), 0);
            testCase.assertEqual(testCase.ofElements().take(0).size(), 0);
            % TODO: error if take(-1)
            
            list = testCase.ofElements('a', 'b', 'c', 'd', 'e').take(2);
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 'a');
            testCase.assertEqual(list.get(2), 'b');
            testCase.assertEqual(list.size(), 2);
            
            list = testCase.ofElements(1, 2, 3, 4, 5).take(6);
            testCase.mustBeList(list);
            for i = 1:5
                testCase.assertEqual(list.get(i), i);
            end
            testCase.assertEqual(list.size(), 5);
        end
        
        function test_takeWhile(testCase)
            testCase.assertEqual(testCase.ofElements().takeWhile(@(x) true).size(), 0);
            testCase.assertEqual(testCase.ofElements(1).takeWhile(@(x) false).size(), 0);
            
            list = testCase.ofElements('a', 'b', 'c', 'd', 'e').takeWhile(@(x) ~strcmp(x, 'c'));
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 'a');
            testCase.assertEqual(list.get(2), 'b');
            testCase.assertEqual(list.size(), 2);
            
            list = testCase.ofElements(1, 2, 3, 4, 5).takeWhile(@(x) isnumeric(x));
            testCase.mustBeList(list);
            for i = 1:5
                testCase.assertEqual(list.get(i), i);
            end
            testCase.assertEqual(list.size(), 5);
        end
        
        function test_drop(testCase)
            testCase.assertEqual(testCase.ofElements().drop(0).size(), 0);
            testCase.assertEqual(testCase.ofElements(1).drop(1).size(), 0);
            testCase.assertEqual(testCase.ofElements(1).drop(2).size(), 0);
            
            % TODO: drop(-1)
            
            list = testCase.ofElements('a', 'b', 'c', 'd', 'e').drop(3);
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 'd');
            testCase.assertEqual(list.get(2), 'e');
            testCase.assertEqual(list.size(), 2);
            
            list = testCase.ofElements(1, 2, 3, 4, 5).drop(0);
            testCase.mustBeList(list);
            for i = 1:5
                testCase.assertEqual(list.get(i), i);
            end
            testCase.assertEqual(list.size(), 5);
        end
        
        function test_dropWhile(testCase)
            testCase.assertEqual(testCase.ofElements().dropWhile(@(x) false).size(), 0);
            testCase.assertEqual(testCase.ofElements(1).dropWhile(@(x) true).size(), 0);
            
            list = testCase.ofElements('a', 'b', 'c', 'd', 'e').dropWhile(@(x) ~strcmp(x, 'd'));
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 'd');
            testCase.assertEqual(list.get(2), 'e');
            testCase.assertEqual(list.size(), 2);
            
            list = testCase.ofElements(1, 2, 3, 4, 5).dropWhile(@(x) ~isnumeric(x));
            testCase.mustBeList(list);
            for i = 1:5
                testCase.assertEqual(list.get(i), i);
            end
            testCase.assertEqual(list.size(), 5);
        end
        
        function test_fold(testCase)
            testCase.assertEqual(testCase.ofElements().fold(0, @(acc, elem) 1000), 0);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).fold(0, @(acc, elem) acc), 0);
            
            testCase.assertEqual(testCase.ofElements('a', 'b', 'c', 'd', 'e').fold(0, @(acc, elem) acc+numel(elem)), 5);
            testCase.assertEqual(testCase.ofElements('a', 'bb', 'ccc').fold(0, @(acc, elem) acc+numel(elem)), 6);
            testCase.assertEqual(testCase.ofElements('a', 'bb', 'ccc').fold(10, @(acc, elem) acc+numel(elem)), 16);
            
            testCase.assertEqual(testCase.ofElements(testCase.ofElements(1), ...
                testCase.ofElements(1, 2, 3), ...
                testCase.ofElements(1, 2, 3, 4, 5)).fold(1000, @(acc, elem) acc+elem.size()), 1009);
        end
        
        function test_foldIndexed(testCase)
            testCase.assertEqual(testCase.ofElements().foldIndexed(0, @(ind, acc, elem) 1000), 0);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).foldIndexed(0, @(ind, acc, elem) acc), 0);
            
            testCase.assertEqual(testCase.ofElements('a', 'b', 'c', 'd', 'e').foldIndexed(0, @(ind, acc, elem) acc+numel(elem)), 5);
            testCase.assertEqual(testCase.ofElements('a', 'b', 'c', 'd', 'e').foldIndexed(0, @(ind, acc, elem) acc+ind), 15);
            testCase.assertEqual(testCase.ofElements('a', 'b', 'c', 'd', 'e').foldIndexed(100, @(ind, acc, elem) acc+ind), 115);
            
            testCase.assertEqual(testCase.ofElements('a', 'bb', 'ccc').foldIndexed(0, @(ind, acc, elem) acc+numel(elem)), 6);
            testCase.assertEqual(testCase.ofElements('a', 'bb', 'ccc').foldIndexed(0, @(ind, acc, elem) acc+numel(elem)+ind), 12);
            testCase.assertEqual(testCase.ofElements('a', 'bb', 'ccc').foldIndexed(10, @(ind, acc, elem) acc+numel(elem)+ind), 22);
            
            testCase.assertEqual(testCase.ofElements(testCase.ofElements(1), ...
                testCase.ofElements(1, 2, 3), ...
                testCase.ofElements(1, 2, 3, 4, 5)).foldIndexed(1000, @(ind, acc, elem) acc+elem.size()), 1009);
            
            testCase.assertEqual(testCase.ofElements(testCase.ofElements(1), ...
                testCase.ofElements(1, 2, 3), ...
                testCase.ofElements(1, 2, 3, 4, 5)).foldIndexed(1000, @(ind, acc, elem) acc+elem.size()+ind), 1015);
        end
        
        function test_map(testCase)
            % Mapping empty collection creates an empty list
            emptyList = testCase.ofElements().map(@(e) e);
            testCase.mustBeList(emptyList);
            testCase.assertEqual(emptyList.size(), 0);
            
            % Create an identic list
            list = testCase.ofElements(1, 2, 3, 4, 5).map(@(e) e);
            testCase.mustBeList(list);
            for i = 1:5
                testCase.assertEqual(list.get(i), i);
            end
            testCase.assertEqual(list.size(), 5);
            
            list = testCase.ofElements('a', 'bb', 'ccc').map(@(elem) numel(elem));
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 3);
            for i = 1:3
                testCase.assertEqual(list.get(i), i);
            end
        end
        
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
            list = testCase.ofElements(0, [], '', [], '', [], 0, struct()).mapNotNull(@(e) e);
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 0);
            testCase.assertEqual(list.get(2), '');
            testCase.assertEqual(list.get(3), '');
            testCase.assertEqual(list.get(4), 0);
            testCase.assertEqual(list.get(5), struct());
            testCase.assertEqual(list.size(), 5);
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
            testCase.assertEqual(list.get(2), 0);
            testCase.assertEqual(list.get(3), {'a'});
            testCase.assertEqual(list.size(), 3);
        end
        
        function test_mapIndexed(testCase)
            % Mapping empty collection creates an empty list
            emptyList = testCase.ofElements().mapIndexed(@(ind, e) e);
            testCase.mustBeList(emptyList);
            testCase.assertEqual(emptyList.size(), 0);
            
            % Create an identic list
            list = testCase.ofElements(1, 2, 3, 4, 5).mapIndexed(@(ind, e) e);
            testCase.mustBeList(list);
            for i = 1:5
                testCase.assertEqual(list.get(i), i);
            end
            testCase.assertEqual(list.size(), 5);
            
            list = testCase.ofElements('a', 'bb', 'ccc').mapIndexed(@(ind, elem) numel(elem));
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 3);
            for i = 1:3
                testCase.assertEqual(list.get(i), i);
            end
        end
        
        function test_flatMap(testCase)
            % Test if empty collections are returned
            testCase.assertEqual(testCase.ofElements().flatMap(@(x) MXtension.listOf('a')).size(), 0);
            testCase.assertEqual(testCase.ofElements('a', 'b').flatMap(@(x) MXtension.emptyList()).size(), 0);
            testCase.assertEqual(testCase.ofElements('a', 'b').flatMap(@(x) MXtension.emptySet()).size(), 0);
            testCase.assertEqual(testCase.ofElements('a', 'b').flatMap(@(x) MXtension.mutableSetOf()).size(), 0);
            testCase.assertEqual(testCase.ofElements('a', 'b').flatMap(@(x) MXtension.mutableListOf()).size(), 0);
            
            
            evaluateResult(testCase.ofElements({1, 2}, {3, 4, 5}).flatMap(@(x) MXtension.listFrom(x)));
            evaluateResult(testCase.ofElements({1, 2}, {3, 4, 5}).flatMap(@(x) MXtension.setFrom(x)));
            
            function evaluateResult(list)
                testCase.mustBeList(list);
                testCase.assertEqual(list.size(), 5);
                for i = 1:5
                    testCase.assertEqual(list.get(i), i);
                end
            end
        end
        
        function test_flatten(testCase)
            % Test if empty collections are returned
            testCase.assertEqual(testCase.ofElements().flatten().size(), 0);
            testCase.assertEqual(testCase.ofElements(MXtension.listOf(), MXtension.setOf()).flatten().size(), 0);
            
            
            list = testCase.ofElements(MXtension.listOf(1, 2), MXtension.setOf(3, 4, 5)).flatten();
            
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 5);
            for i = 1:5
                testCase.assertEqual(list.get(i), i);
            end
            
        end
        
        function test_intersect(testCase)
            testCase.assertEqual(testCase.ofElements().intersect(testCase.ofElements(1)).size(), 0);
            testCase.assertEqual(testCase.ofElements().intersect(testCase.ofElements()).size(), 0);
            
            set = testCase.ofElements(0, 1, 2, 3, 4, 5).intersect(testCase.ofElements(0, 1, 2, 3, 4, 5));
            testCase.mustBeSet(set);
            testCase.assertEqual(set.size(), 6);
            testCase.assertTrue(set.containsAll(testCase.ofElements(0, 1, 2, 3, 4, 5)));
            
            set = testCase.ofElements('a', 'b', 'c').intersect(testCase.ofElements('a', 'b'));
            testCase.mustBeSet(set);
            testCase.assertEqual(set.size(), 2);
            testCase.assertTrue(set.containsAll(testCase.ofElements('a', 'b')));
            
            set = testCase.ofElements('a', 'b', 'c').intersect(testCase.ofElements('d', 'e'));
            testCase.mustBeSet(set);
            testCase.assertEqual(set.size(), 0);
        end
        
        function test_distinct(testCase)
            testCase.assertEqual(testCase.ofElements().distinct().size(), 0);
            
            list = testCase.ofElements(0, 1, 2, 3, 4, 5).distinct();
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 6);
            testCase.assertTrue(list.containsAll(testCase.ofElements(0, 1, 2, 3, 4, 5)));
            
            list = testCase.ofElements(0, 1, 2, 3, 4, 5, 5, 4, 3, 2, 1, 0).distinct();
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 6);
            testCase.assertTrue(list.containsAll(testCase.ofElements(0, 1, 2, 3, 4, 5)));
            
            l1 = MXtension.listOf();
            l2 = MXtension.listOf();
            l3 = MXtension.listOf();
            list = testCase.ofElements(l1, l2, l3).distinct();
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 3);
            testCase.assertTrue(list.containsAll(testCase.ofElements(l1, l2, l3)));
            
            l2 = l1;
            list = testCase.ofElements(l1, l2, l3).distinct();
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 2);
            testCase.assertTrue(list.containsAll(testCase.ofElements(l1, l3)));
            testCase.assertTrue(list.containsAll(testCase.ofElements(l2, l3)));
        end
        
        function test_partition(testCase)
            pair = testCase.ofElements().partition(@(x) true);
            testCase.assertTrue(isa(pair, 'MXtension.Pair'));
            testCase.mustBeList(pair.First);
            testCase.mustBeList(pair.Second);
            testCase.assertEqual(pair.First.size(), 0);
            testCase.assertEqual(pair.Second.size(), 0);
            
            pair = testCase.ofElements(0, 1, 2, 3, 4, 5).partition(@(x) true);
            testCase.assertTrue(isa(pair, 'MXtension.Pair'));
            testCase.mustBeList(pair.First);
            testCase.mustBeList(pair.Second);
            testCase.assertEqual(pair.First.size(), 6);
            testCase.assertEqual(pair.Second.size(), 0);
            testCase.assertTrue(pair.First.containsAll(testCase.ofElements(0, 1, 2, 3, 4, 5)));
            
            pair = testCase.ofElements(0, 1, 2, 3, 4, 5).partition(@(x) false);
            testCase.assertTrue(isa(pair, 'MXtension.Pair'));
            testCase.mustBeList(pair.First);
            testCase.mustBeList(pair.Second);
            testCase.assertEqual(pair.First.size(), 0);
            testCase.assertEqual(pair.Second.size(), 6);
            testCase.assertTrue(pair.Second.containsAll(testCase.ofElements(0, 1, 2, 3, 4, 5)));
            
            pair = testCase.ofElements(0, 1, 2, 3, 4, 5).partition(@(x) x > 3);
            testCase.assertTrue(isa(pair, 'MXtension.Pair'));
            testCase.mustBeList(pair.First);
            testCase.mustBeList(pair.Second);
            testCase.assertEqual(pair.First.size(), 2);
            testCase.assertEqual(pair.Second.size(), 4);
            testCase.assertTrue(pair.First.containsAll(testCase.ofElements(4, 5)));
            testCase.assertTrue(pair.Second.containsAll(testCase.ofElements(0, 1, 2, 3)));
        end
        
        
    end
    
end
