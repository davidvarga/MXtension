classdef (Abstract) CollectionTest < matlab.unittest.TestCase
    
    methods(Abstract)
        classUnderTest = classUnderTest(obj)
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
        function collection = fromCollection(obj, collection) %#ok<INUSD>
            collection = eval([obj.classUnderTest(), '.fromCollection(collection);']);
        end
        
        function collection = ofElements(obj, varargin)
            collection = eval([obj.classUnderTest(), '.ofElements(varargin{:});']);
        end
        
        
        function mustBeList(obj, list)
            obj.assertTrue(isa(list, 'MXtension.Collections.List'));
            obj.assertFalse(isa(list, 'MXtension.Collections.MutableList'));
        end
        
        function mustBeSet(obj, set)
            obj.assertTrue(isa(set, 'MXtension.Collections.Set'));
            obj.assertFalse(isa(set, 'MXtension.Collections.MutableSet'));
        end
        
        function mustBeMap(obj, list)
            obj.assertTrue(isa(list, 'MXtension.Collections.Map'));
            obj.assertFalse(isa(list, 'MXtension.Collections.MutableMap'));
        end
        
        function mustBePair(obj, pair)
            obj.assertTrue(isa(pair, 'MXtension.Pair'));
        end
        
        function constructorBaseTest(testCase, oneToThree, abc, emptyCollection, varargin)
            checkForOrder = nargin < 5 || (nargin == 5 && varargin{1});
            collection = testCase.fromCollection(oneToThree);
            testCase.assertEqual(collection.size(), 3);
            if checkForOrder
                collection.forEachIndexed(@(ind, elem) testCase.assertEqual(elem, ind));
            end
            testCase.assertTrue(collection.containsAll(MXtension.listOf(1, 2, 3)));
            
            function checkElement(ind, elem)
                switch ind
                    case 1
                        testCase.assertEqual(elem, 'a');
                    case 2
                        testCase.assertEqual(elem, 'b');
                    case 3
                        testCase.assertEqual(elem, 'c');
                end
            end
            collection = testCase.fromCollection(abc);
            testCase.assertEqual(collection.size(), 3);
            if checkForOrder
                collection.forEachIndexed(@(ind, elem) checkElement(ind, elem));
            end
            testCase.assertTrue(collection.containsAll(MXtension.listOf('a', 'b', 'c')));
            
            
            collection = testCase.fromCollection(emptyCollection);
            testCase.assertEqual(collection.size(), 0);
        end
    end
    
    methods(Test)
        
        function test_construct_with_fromCollection_CellArray(testCase)
            testCase.constructorBaseTest({1, 2, 3}, {'a', 'b', 'c'}, {});
        end
        
        function test_construct_with_fromCollection_List(testCase)
            testCase.constructorBaseTest(MXtension.listFrom({1, 2, 3}), MXtension.listFrom({'a', 'b', 'c'}), MXtension.listOf());
        end
        
        function test_construct_with_fromCollection_Set(testCase)
            testCase.constructorBaseTest(MXtension.setFrom({1, 2, 3}), MXtension.setFrom({'a', 'b', 'c'}), MXtension.setOf());
        end
        
        function test_construct_with_fromCollection_JavaList(testCase)
            testCase.constructorBaseTest(testCase.javaListOf(1, 2, 3), testCase.javaListOf('a', 'b', 'c'), testCase.javaListOf());
        end
        
        function test_construct_with_fromCollection_JavaSet(testCase)
            testCase.constructorBaseTest(testCase.javaSetOf(1, 2, 3), testCase.javaSetOf('a', 'b', 'c'), testCase.javaSetOf(), false);
            
        end
        
        function test_construct_with_ofElements(testCase)
            testCase.constructorBaseTest(testCase.ofElements(1, 2, 3), testCase.ofElements('a', 'b', 'c'), testCase.ofElements());
        end
        
        function test_construct_with_invalidCollectionType(testCase)
            try
                testCase.fromCollection([1, 2, 3]);
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalArgumentException');
                testCase.assertEqual(ex.message, 'The passed collection type is not supported.');
            end
        end
        
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
            testCase.mustBePair(pair);
            testCase.mustBeList(pair.First);
            testCase.mustBeList(pair.Second);
            testCase.assertEqual(pair.First.size(), 0);
            testCase.assertEqual(pair.Second.size(), 0);
            
            pair = testCase.ofElements(0, 1, 2, 3, 4, 5).partition(@(x) true);
            testCase.mustBePair(pair);
            testCase.mustBeList(pair.First);
            testCase.mustBeList(pair.Second);
            testCase.assertEqual(pair.First.size(), 6);
            testCase.assertEqual(pair.Second.size(), 0);
            testCase.assertTrue(pair.First.containsAll(testCase.ofElements(0, 1, 2, 3, 4, 5)));
            
            pair = testCase.ofElements(0, 1, 2, 3, 4, 5).partition(@(x) false);
            testCase.mustBePair(pair);
            testCase.mustBeList(pair.First);
            testCase.mustBeList(pair.Second);
            testCase.assertEqual(pair.First.size(), 0);
            testCase.assertEqual(pair.Second.size(), 6);
            testCase.assertTrue(pair.Second.containsAll(testCase.ofElements(0, 1, 2, 3, 4, 5)));
            
            pair = testCase.ofElements(0, 1, 2, 3, 4, 5).partition(@(x) x > 3);
            testCase.mustBePair(pair);
            testCase.mustBeList(pair.First);
            testCase.mustBeList(pair.Second);
            testCase.assertEqual(pair.First.size(), 2);
            testCase.assertEqual(pair.Second.size(), 4);
            testCase.assertTrue(pair.First.containsAll(testCase.ofElements(4, 5)));
            testCase.assertTrue(pair.Second.containsAll(testCase.ofElements(0, 1, 2, 3)));
        end
        
        function test_zip(testCase)
            % Zip without transform
            list = testCase.ofElements().zip(testCase.ofElements());
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements().zip(MXtension.setOf(1, 2, 3));
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements(1, 2, 3).zip(MXtension.listOf());
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            
            list = testCase.ofElements(1, 2, 3).zip(MXtension.listOf('a', 'b', 'c'));
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 3);
            for i = 1:3
                elem = list.get(i);
                testCase.mustBePair(elem);
                testCase.assertEqual(elem.First, i);
                switch i
                    case 1
                        testCase.assertEqual(elem.Second, 'a');
                        break;
                    case 2
                        testCase.assertEqual(elem.Second, 'b');
                        break;
                    case 3
                        testCase.assertEqual(elem.Second, 'c');
                        break;
                end
            end
            
            list = testCase.ofElements(1, 2, 3).zip(MXtension.listOf(10, 20));
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 2);
            for i = 1:2
                elem = list.get(i);
                testCase.mustBePair(elem);
                testCase.assertEqual(elem.First, i);
                testCase.assertEqual(elem.Second, i*10);
            end
            
            list = testCase.ofElements(1, 2).zip(MXtension.listOf(10, 20, 30));
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 2);
            for i = 1:2
                elem = list.get(i);
                testCase.mustBePair(elem);
                testCase.assertEqual(elem.First, i);
                testCase.assertEqual(elem.Second, i*10);
            end
            
            
            % Zip with transform
            list = testCase.ofElements().zip(testCase.ofElements(), @(first, second) MXtension.Pair(second, first));
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements().zip(MXtension.setOf(1, 2, 3), @(first, second) MXtension.Pair(second, first));
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements(1, 2, 3).zip(MXtension.listOf(), @(first, second) MXtension.Pair(second, first));
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            
            list = testCase.ofElements(1, 2, 3).zip(MXtension.listOf('a', 'b', 'c'), @(first, second) MXtension.Pair(second, first));
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 3);
            for i = 1:3
                elem = list.get(i);
                testCase.mustBePair(elem);
                testCase.assertEqual(elem.Second, i);
                switch i
                    case 1
                        testCase.assertEqual(elem.First, 'a');
                        break;
                    case 2
                        testCase.assertEqual(elem.First, 'b');
                        break;
                    case 3
                        testCase.assertEqual(elem.First, 'c');
                        break;
                end
            end
            
            list = testCase.ofElements(1, 2, 3).zip(MXtension.listOf(10, 20), @(first, second) MXtension.Pair(second, first));
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 2);
            for i = 1:2
                elem = list.get(i);
                testCase.mustBePair(elem);
                testCase.assertEqual(elem.Second, i);
                testCase.assertEqual(elem.First, i*10);
            end
            
            list = testCase.ofElements(1, 2).zip(MXtension.listOf(10, 20, 30), @(first, second) MXtension.Pair(second, first));
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 2);
            for i = 1:2
                elem = list.get(i);
                testCase.mustBePair(elem);
                testCase.assertEqual(elem.Second, i);
                testCase.assertEqual(elem.First, i*10);
            end
        end
        
        function test_associate(testCase)
            map = testCase.ofElements().associate(@(x) MXtension.Pair('a', 2));
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 0);
            
            map = testCase.ofElements({'a', 1}, {'b', 2}, {'c', 3}).associate(@(x) MXtension.Pair(x{1}, x{2}));
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 3);
            testCase.assertEqual(map.get('a'), 1);
            testCase.assertEqual(map.get('b'), 2);
            testCase.assertEqual(map.get('c'), 3);
            
            map = testCase.ofElements({'a', 1}, {'a', 2}, {'a', 3}).associate(@(x) MXtension.Pair(x{1}, x{2}));
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 1);
            testCase.assertEqual(map.get('a'), 3);
        end
        
        function test_associateBy(testCase)
            map = testCase.ofElements().associateBy(@(x) double(x));
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 0);
            
            map = testCase.ofElements().associateBy(@(x) double(x), @(x) [x, '-1']);
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 0);
            
            
            map = testCase.ofElements('a', 'b', 'c').associateBy(@(x) double(x));
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 3);
            testCase.assertEqual(map.get(97), 'a');
            testCase.assertEqual(map.get(98), 'b');
            testCase.assertEqual(map.get(99), 'c');
            
            map = testCase.ofElements('a', 'a', 'a').associateBy(@(x) double(x));
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 1);
            testCase.assertEqual(map.get(97), 'a');
            
            map = testCase.ofElements('a', 'b', 'c').associateBy(@(x) double(x), @(x) [x, '-', num2str(double(x))]);
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 3);
            testCase.assertEqual(map.get(97), 'a-97');
            testCase.assertEqual(map.get(98), 'b-98');
            testCase.assertEqual(map.get(99), 'c-99');
            
            map = testCase.ofElements('a', 'a', 'a').associateBy(@(x) double(x), @(x) [x, '-', num2str(double(x))]);
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 1);
            testCase.assertEqual(map.get(97), 'a-97');
        end
        
        function test_associateWith(testCase)
            map = testCase.ofElements().associateWith(@(x) double(x));
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 0);
            
            map = testCase.ofElements('a', 'b', 'c').associateWith(@(x) double(x));
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 3);
            testCase.assertEqual(map.get('a'), 97);
            testCase.assertEqual(map.get('b'), 98);
            testCase.assertEqual(map.get('c'), 99);
            
            map = testCase.ofElements('a', 'a', 'a').associateWith(@(x) double(x));
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 1);
            testCase.assertEqual(map.get('a'), 97);
        end
        
        function test_groupBy(testCase)
            map = testCase.ofElements().groupBy(@(x) numel(x));
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 0);
            
            map = testCase.ofElements().groupBy(@(x) numel(x), @(x) [x, '-', x]);
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 0);
            
            map = testCase.ofElements('1', '11', '111').groupBy(@(x) numel(x));
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 3);
            testCase.assertEqual(map.get(1).size(), 1);
            testCase.mustBeList(map.get(1));
            testCase.assertTrue(map.get(1).containsAll(MXtension.listOf('1')));
            testCase.assertEqual(map.get(2).size(), 1);
            testCase.mustBeList(map.get(2));
            testCase.assertTrue(map.get(2).containsAll(MXtension.listOf('11')));
            testCase.assertEqual(map.get(3).size(), 1);
            testCase.mustBeList(map.get(3));
            testCase.assertTrue(map.get(3).containsAll(MXtension.listOf('111')));
            
            map = testCase.ofElements('1', '11', '111', '222', '333', '22').groupBy(@(x) numel(x));
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 3);
            testCase.assertEqual(map.get(1).size(), 1);
            testCase.mustBeList(map.get(1));
            testCase.assertTrue(map.get(1).containsAll(MXtension.listOf('1')));
            testCase.assertEqual(map.get(2).size(), 2);
            testCase.mustBeList(map.get(2));
            testCase.assertTrue(map.get(2).containsAll(MXtension.listOf('11', '22')));
            testCase.assertEqual(map.get(3).size(), 3);
            testCase.mustBeList(map.get(3));
            testCase.assertTrue(map.get(3).containsAll(MXtension.listOf('111', '222', '333')));
            
            %
            map = testCase.ofElements('1', '11', '111').groupBy(@(x) numel(x), @(x) [x, '-', x]);
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 3);
            testCase.assertEqual(map.get(1).size(), 1);
            testCase.mustBeList(map.get(1));
            testCase.assertTrue(map.get(1).containsAll(MXtension.listOf('1-1')));
            testCase.assertEqual(map.get(2).size(), 1);
            testCase.mustBeList(map.get(2));
            testCase.assertTrue(map.get(2).containsAll(MXtension.listOf('11-11')));
            testCase.assertEqual(map.get(3).size(), 1);
            testCase.mustBeList(map.get(3));
            testCase.assertTrue(map.get(3).containsAll(MXtension.listOf('111-111')));
            
            map = testCase.ofElements('1', '11', '111', '222', '333', '22').groupBy(@(x) numel(x), @(x) [x, '-', x]);
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 3);
            testCase.assertEqual(map.get(1).size(), 1);
            testCase.mustBeList(map.get(1));
            testCase.assertTrue(map.get(1).containsAll(MXtension.listOf('1-1')));
            testCase.assertEqual(map.get(2).size(), 2);
            testCase.mustBeList(map.get(2));
            testCase.assertTrue(map.get(2).containsAll(MXtension.listOf('11-11', '22-22')));
            testCase.assertEqual(map.get(3).size(), 3);
            testCase.mustBeList(map.get(3));
            testCase.assertTrue(map.get(3).containsAll(MXtension.listOf('111-111', '222-222', '333-333')));
        end
        
        function test_reversed(testCase)
            list = testCase.ofElements().reversed();
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements('a', 'b', 'c').reversed();
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 3);
            testCase.assertEqual(list.get(1), 'c');
            testCase.assertEqual(list.get(2), 'b');
            testCase.assertEqual(list.get(3), 'a');
            
            list = testCase.ofElements(1, 2).reversed();
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 2);
            testCase.assertEqual(list.get(1), 2);
            testCase.assertEqual(list.get(2), 1);
        end
        
        
    end
    
end
