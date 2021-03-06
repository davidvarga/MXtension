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
        
        function collections = allKindsOfCollectionsOf(varargin)
            mlCollections = CollectionTest.matlabCollectionsOf(varargin{:});
            % CollectionTest.javaSetOf(varargin{:}
            javaCollections = {CollectionTest.javaListOf(varargin{:})};
            
            collections = [mlCollections, javaCollections];
        end
        
        function collections = matlabCollectionsOf(varargin)
            collections = {; ...
                MXtension.listOf(varargin{:}), ...
                MXtension.mutableListOf(varargin{:}), ...
                MXtension.setOf(varargin{:}), ...
                MXtension.mutableSetOf(varargin{:}), ...
                varargin};
        end
    end
    
    methods(Access = protected)
        function collection = fromCollection(obj, collection) %#ok<INUSD>
            collection = eval([obj.classUnderTest(), '.fromCollection(collection);']);
        end
        
        function collection = ofElements(obj, varargin)
            collection = eval([obj.classUnderTest(), '.ofElements(varargin{:});']);
        end
        
        function mustBeIterator(obj, iterator)
            obj.assertTrue(isa(iterator, 'MXtension.Collections.Iterators.Iterator'));
            obj.assertFalse(isa(iterator, 'MXtension.Collections.Iterators.MutableIterator'));
        end
        
        function mustBeCellArray(obj, cellArray)
            obj.assertTrue(iscell(cellArray));
        end
        
        function mustBeList(obj, list)
            obj.assertTrue(isa(list, 'MXtension.Collections.List'));
            obj.assertFalse(isa(list, 'MXtension.Collections.MutableList'));
        end
        
        function mustBeMutableList(obj, list)
            obj.assertTrue(isa(list, 'MXtension.Collections.MutableList'));
        end
        
        function mustBeSet(obj, set)
            obj.assertTrue(isa(set, 'MXtension.Collections.Set'));
            obj.assertFalse(isa(set, 'MXtension.Collections.MutableSet'));
        end
        
        function mustBeMutableSet(obj, set)
            obj.assertTrue(isa(set, 'MXtension.Collections.MutableSet'));
        end
        
        function mustBeMap(obj, map)
            obj.assertTrue(isa(map, 'MXtension.Collections.Map'));
            obj.assertFalse(isa(map, 'MXtension.Collections.MutableMap'));
        end
        
        function mustBePair(obj, pair)
            obj.assertTrue(isa(pair, 'MXtension.Pair'));
        end
        
        function mustThrowException(obj, toExecute, identifier, message)
            try
                toExecute();
                obj.verifyFail();
            catch ex
                obj.assertEqual(ex.identifier, identifier);
                obj.assertEqual(ex.message, message);
            end
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
        
        function checkIteratorsNextElement(testCase, iterator, expected)
            testCase.assertTrue(iterator.hasNext());
            element = iterator.next();
            testCase.assertEqual(element, expected);
        end
        
        function checkIteratorOfCollection(testCase, iterator, elements)
            for i = 1:numel(elements)
                testCase.checkIteratorsNextElement(iterator, elements{i});
            end
            testCase.assertFalse(iterator.hasNext());
            testCase.mustThrowException(@() iterator.next(), 'MXtension:NoSuchElementException', 'The requested element cannot be found.');
        end
        
        function checkIndexedIteratorsNextElement(testCase, iterator, expected, index)
            testCase.assertTrue(iterator.hasNext());
            element = iterator.next();
            testCase.assertTrue(isa(element, 'MXtension.Collections.Iterators.IndexedValue'));
            testCase.assertEqual(element.Index, index);
            testCase.assertEqual(element.Value, expected);
        end
        
        function checkIndexedIteratorOfCollection(testCase, iterator, elements)
            for i = 1:numel(elements)
                testCase.checkIndexedIteratorsNextElement(iterator, elements{i}, i);
            end
            testCase.assertFalse(iterator.hasNext());
            testCase.mustThrowException(@() iterator.next(), 'MXtension:NoSuchElementException', 'The requested element cannot be found.');
        end
        
        function assertElementsFromOneUntil(obj, collection, until)
            obj.assertElementsFromOneUntilWithOffset(collection, until, 1);
            
        end
        
        function assertElementsFromOneUntilWithOffset(obj, collection, until, offset)
            obj.assertEqual(collection.size(), until);
            iterator = collection.iterator();
            for i = 1:until
                obj.assertEqual(iterator.next(), i+offset-1);
            end
        end
        
    end
    
    methods(Test)
        
        function construct_with_fromCollection_CellArray(testCase)
            testCase.constructorBaseTest({1, 2, 3}, {'a', 'b', 'c'}, {});
        end
        
        function construct_with_fromCollection_List(testCase)
            testCase.constructorBaseTest(MXtension.listFrom({1, 2, 3}), MXtension.listFrom({'a', 'b', 'c'}), MXtension.listOf());
        end
        
        function construct_with_fromCollection_Set(testCase)
            testCase.constructorBaseTest(MXtension.setFrom({1, 2, 3}), MXtension.setFrom({'a', 'b', 'c'}), MXtension.setOf());
        end
        
        function construct_with_fromCollection_JavaList(testCase)
            testCase.constructorBaseTest(testCase.javaListOf(1, 2, 3), testCase.javaListOf('a', 'b', 'c'), testCase.javaListOf());
        end
        
        function construct_with_fromCollection_JavaSet(testCase)
            testCase.constructorBaseTest(testCase.javaSetOf(1, 2, 3), testCase.javaSetOf('a', 'b', 'c'), testCase.javaSetOf(), false);
        end
        
        function construct_with_fromCollection_invalidCollectionType(testCase)
            try
                testCase.fromCollection([1, 2, 3]);
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalArgumentException');
                testCase.assertEqual(ex.message, 'The passed collection type is not supported.');
            end
        end
        
        
        function construct_with_ofElements(testCase)
            testCase.constructorBaseTest(testCase.ofElements(1, 2, 3), testCase.ofElements('a', 'b', 'c'), testCase.ofElements());
        end
        
        
        function iterator_of_empty_collection(testCase)
            iterator = testCase.ofElements().iterator();
            testCase.mustBeIterator(iterator);
            testCase.checkIteratorOfCollection(iterator, {});
        end
        
        function iterator_of_singleton_collection(testCase)
            iterator = testCase.ofElements('a').iterator();
            testCase.mustBeIterator(iterator);
            testCase.checkIteratorOfCollection(iterator, {'a'});
        end
        
        function iterator_of_collection_with_multiple_elements(testCase)
            iterator = testCase.ofElements('a', 1, 'dog').iterator();
            testCase.mustBeIterator(iterator);
            testCase.checkIteratorOfCollection(iterator, {'a', 1, 'dog'});
        end
        
        
        function withIndex_on_empty_collection(testCase)
            indexedCollection = testCase.ofElements().withIndex();
            testCase.assertTrue(isa(indexedCollection, 'MXtension.Collections.IndexedCollection'));
            iterator = indexedCollection.iterator();
            testCase.assertTrue(isa(iterator, 'MXtension.Collections.Iterators.IndexedIterator'));
            testCase.checkIndexedIteratorOfCollection(iterator, {});
        end
        
        function withIndex_on_singleton_collection(testCase)
            indexedCollection = testCase.ofElements('a').withIndex();
            testCase.assertTrue(isa(indexedCollection, 'MXtension.Collections.IndexedCollection'));
            iterator = indexedCollection.iterator();
            testCase.assertTrue(isa(iterator, 'MXtension.Collections.Iterators.IndexedIterator'));
            testCase.checkIndexedIteratorOfCollection(iterator, {'a'});
        end
        
        function withIndex_on_colletion_with_multiple_elements(testCase)
            indexedCollection = testCase.ofElements('a', 1, 'dog').withIndex();
            testCase.assertTrue(isa(indexedCollection, 'MXtension.Collections.IndexedCollection'));
            iterator = indexedCollection.iterator();
            testCase.assertTrue(isa(iterator, 'MXtension.Collections.Iterators.IndexedIterator'));
            testCase.checkIndexedIteratorOfCollection(iterator, {'a', 1, 'dog'});
        end
        
        
        function forEach_on_empty_collection(testCase)
            calls = {};
            
            function op(item)
                calls{end+1} = item;
            end
            
            collection = testCase.ofElements();
            collection.forEach(@(it) op(it));
            
            testCase.verifyLength(calls, 0);
        end
        
        function forEach_on_non_empty_collection(testCase)
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
        
        
        function forEachIndexed_on_empty_collection(testCase)
            calls = {};
            
            function op(item, index)
                calls{end+1} = {item, index};
            end
            
            collection = testCase.ofElements();
            collection.forEachIndexed(@(it, ind) op(it, ind));
            
            testCase.verifyLength(calls, 0);
        end
        
        function forEachIndexed_on_non_empty_collection(testCase)
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
        
        
        function contains_called_on_empty_collection(testCase)
            collection = testCase.ofElements();
            
            testCase.assertEqual(collection.contains(2), false);
            testCase.assertEqual(collection.contains(''), false);
        end
        
        function contains_called_on_nonempty_collection(testCase)
            collection = testCase.ofElements(1, 'a', 3);
            testCase.assertEqual(collection.contains('a'), true);
            testCase.assertEqual(collection.contains(1), true);
            testCase.assertEqual(collection.contains(3), true);
            testCase.assertEqual(collection.contains(''), false);
        end
        
        
        function containsAll_called_on_empty_collection(testCase)
            collection = testCase.ofElements();
            collections = testCase.allKindsOfCollectionsOf(1, 2, 3);
            for i = 1:numel(collections)
                testCase.assertEqual(collection.containsAll(collections{i}), false);
            end
            collections = testCase.allKindsOfCollectionsOf('a', 'b');
            for i = 1:numel(collections)
                testCase.assertEqual(collection.containsAll(collections{i}), false);
            end
            
            collections = testCase.allKindsOfCollectionsOf();
            for i = 1:numel(collections)
                testCase.assertEqual(collection.containsAll(collections{i}), true);
            end
            
        end
        
        function containsAll_called_on_non_empty_collection(testCase)
            
            collections = testCase.allKindsOfCollectionsOf(1, 2, 3);
            for i = 1:numel(collections)
                collection = testCase.ofElements(1, 2, 3);
                testCase.assertEqual(collection.containsAll(collections{i}), true);
                collection = testCase.ofElements(1, 2, 3, 'a', 4);
                testCase.assertEqual(collection.containsAll(collections{i}), true);
            end
            collections = testCase.allKindsOfCollectionsOf('a', 'b');
            for i = 1:numel(collections)
                collection = testCase.ofElements('a', 'b');
                testCase.assertEqual(collection.containsAll(collections{i}), true);
                collection = testCase.ofElements('a', 'b', 1, 'c');
                testCase.assertEqual(collection.containsAll(collections{i}), true);
            end
            
            collections = testCase.allKindsOfCollectionsOf();
            for i = 1:numel(collections)
                collection = testCase.ofElements(1, 2, 3);
                testCase.assertEqual(collection.containsAll(collections{i}), true);
                collection = testCase.ofElements('a', 'b', 'c');
                testCase.assertEqual(collection.containsAll(collections{i}), true);
            end
        end
        
        
        function size_of_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements().size(), 0);
        end
        
        function size_of_non_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3, 4, 5).size(), 5);
            testCase.assertEqual(testCase.ofElements(1).size(), 1);
        end
        
        
        function count_without_parameter_on_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements().count(), 0);
        end
        
        function count_without_parameter_on_non_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3, 4, 5).count(), 5);
            testCase.assertEqual(testCase.ofElements(1).count(), 1);
        end
        
        function count_with_predicate_which_always_false(testCase)
            testCase.assertEqual(testCase.ofElements().count(@(x) false), 0);
            testCase.assertEqual(testCase.ofElements(1).count(@(x) false), 0);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).count(@(x) false), 0);
        end
        
        function count_with_predicate_which_always_true(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3, 4, 5).count(@(x) true), 5);
            testCase.assertEqual(testCase.ofElements(1).count(@(x) true), 1);
            testCase.assertEqual(testCase.ofElements().count(@(x) true), 0);
        end
        
        function count_with_predicate_with_partial_match(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3, 4, 5).count(@(x) x < 3), 2);
            testCase.assertEqual(testCase.ofElements(1, 2, 3, 4, 5).count(@(x) x > 2 && x < 4), 1);
            testCase.assertEqual(testCase.ofElements(1, 2, 3, 4, 5).count(@(x) x < 1), 0);
        end
        
        
        function any_without_argument_on_empty_collection(testCase)
            testCase.assertFalse(testCase.ofElements().any());
        end
        
        function any_without_argument_on_non_empty_collection(testCase)
            testCase.assertTrue(testCase.ofElements(1).any());
            testCase.assertTrue(testCase.ofElements(1, 2, 3).any());
        end
        
        function any_with_predicate_on_empty_collection(testCase)
            testCase.assertFalse(testCase.ofElements().any(@(e) true));
            testCase.assertFalse(testCase.ofElements().any(@(e) false));
        end
        
        function any_with_predicate_with_partial_match(testCase)
            testCase.assertTrue(testCase.ofElements(1, 2, 3, 4, 5).any(@(x) x < 3));
            testCase.assertTrue(testCase.ofElements(1, 2, 3, 4, 5).any(@(x) x > 2 && x < 4));
            testCase.assertFalse(testCase.ofElements(1, 2, 3, 4, 5).any(@(x) x < 1));
        end
        
        
        function all_on_empty_collection(testCase)
            testCase.assertTrue(testCase.ofElements().all(@(x) false));
            testCase.assertTrue(testCase.ofElements().all(@(x) false));
        end
        
        function all_on_non_empty_collection(testCase)
            testCase.assertTrue(testCase.ofElements(1, 2, 3, 4, 5).all(@(x) true));
            testCase.assertTrue(testCase.ofElements(1).all(@(x) true));
            
            testCase.assertFalse(testCase.ofElements(1, 2, 3, 4, 5).all(@(x) false));
            testCase.assertFalse(testCase.ofElements(1).all(@(x) false));
            
            testCase.assertFalse(testCase.ofElements(1, 2, 3, 4, 5).all(@(x) x < 3));
            testCase.assertFalse(testCase.ofElements(1, 2, 3, 4, 5).all(@(x) x > 2 && x < 4));
            testCase.assertFalse(testCase.ofElements(1, 2, 3, 4, 5).all(@(x) x < 1));
            testCase.assertTrue(testCase.ofElements(1, 2, 3, 4, 5).all(@(x) x >= 1 && x <= 5));
        end
        
        
        function none_without_argument_on_empty_collection(testCase)
            testCase.assertTrue(testCase.ofElements().none());
        end
        
        function none_without_argument_on_non_empty_collection(testCase)
            testCase.assertFalse(testCase.ofElements(1).none());
            testCase.assertFalse(testCase.ofElements('a', 'b').none());
        end
        
        function none_with_predicate_on_empty_collection(testCase)
            testCase.assertTrue(testCase.ofElements().none(@(e) true));
            testCase.assertTrue(testCase.ofElements().none(@(e) false));
        end
        
        function none_with_predicate_on_non_empty_collection(testCase)
            testCase.assertFalse(testCase.ofElements(1, 2, 3, 4, 5).none(@(x) true));
            testCase.assertTrue(testCase.ofElements(1, 2, 3, 4, 5).none(@(x) false));
            
            testCase.assertFalse(testCase.ofElements(1, 2, 3, 4, 5).none(@(x) x < 3));
            testCase.assertFalse(testCase.ofElements(1, 2, 3, 4, 5).none(@(x) x > 2 && x < 4));
            testCase.assertTrue(testCase.ofElements(1, 2, 3, 4, 5).none(@(x) x < 1));
            testCase.assertFalse(testCase.ofElements(1, 2, 3, 4, 5).none(@(x) x >= 1 && x <= 5));
        end
        
        
        function isEmpty_on_empty_collection(testCase)
            testCase.assertTrue(testCase.ofElements().isEmpty());
        end
        
        function isEmpty_on_non_empty_collection(testCase)
            testCase.assertFalse(testCase.ofElements(1).isEmpty());
            testCase.assertFalse(testCase.ofElements('a', 'b').isEmpty());
        end
        
        
        function isNotEmpty_on_empty_collection(testCase)
            testCase.assertFalse(testCase.ofElements().isNotEmpty());
        end
        
        function isNotEmpty_on_non_empty_collection(testCase)
            testCase.assertTrue(testCase.ofElements(1).isNotEmpty());
            testCase.assertTrue(testCase.ofElements('a', 'b').isNotEmpty());
        end
        
        
        function first_without_argument_on_empty_collection(testCase)
            try
                testCase.ofElements().first();
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:NoSuchElementException');
                testCase.assertEqual(ex.message, 'The collection is empty.');
            end
        end
        
        function first_without_argument_on_non_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).first(), 1);
            testCase.assertEqual(testCase.ofElements('a', 'b').first(), 'a');
        end
        
        function first_with_predicate_on_empty_collection(testCase)
            try
                testCase.ofElements().first(@(x) true);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:NoSuchElementException');
                testCase.assertEqual(ex.message, 'The collection is empty.');
            end
        end
        
        function first_with_predicate_on_non_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).first(@(x) x > 2), 3);
            testCase.assertEqual(testCase.ofElements('a', 'b').first(@(x) strcmp(x, 'a')), 'a');
            try
                testCase.ofElements(1, 2, 3).first(@(x) x > 3);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:NoSuchElementException');
                testCase.assertEqual(ex.message, 'No element matches the given predicate.');
            end
        end
        
        
        function firstOrNull_without_argument_on_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements().firstOrNull(), []);
        end
        
        function firstOrNull_without_argument_on_non_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).firstOrNull(), 1);
            testCase.assertEqual(testCase.ofElements('a', 'b').firstOrNull(), 'a');
        end
        
        function firstOrNull_with_predicate_on_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements().firstOrNull(@(x) true), []);
            testCase.assertEqual(testCase.ofElements().firstOrNull(@(x) false), []);
        end
        
        function firstOrNull_with_predicate_on_non_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).firstOrNull(@(x) x > 2), 3);
            testCase.assertEqual(testCase.ofElements('a', 'b').firstOrNull(@(x) strcmp(x, 'a')), 'a');
            testCase.assertEqual(testCase.ofElements(1, 2, 3).firstOrNull(@(x) x > 3), []);
        end
        
        
        function last_without_argument_on_empty_collection(testCase)
            try
                testCase.ofElements().last();
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:NoSuchElementException');
                testCase.assertEqual(ex.message, 'The collection is empty.');
            end
        end
        
        function last_without_argument_on_non_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).last(), 3);
            testCase.assertEqual(testCase.ofElements('a', 'b').last(), 'b');
        end
        
        function last_with_predicate_on_empty_collection(testCase)
            try
                testCase.ofElements().last(@(x) true);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:NoSuchElementException');
                testCase.assertEqual(ex.message, 'The collection is empty.');
            end
        end
        
        function last_with_predicate_on_non_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).last(@(x) x > 1), 3);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).last(@(x) x < 2), 1);
            testCase.assertEqual(testCase.ofElements('a', 'b').last(@(x) strcmp(x, 'a')), 'a');
            
            try
                testCase.ofElements(1, 2, 3).last(@(x) x > 3);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:NoSuchElementException');
                testCase.assertEqual(ex.message, 'No element matches the given predicate.');
            end
        end
        
        
        function lastOrNull_without_argument_on_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements().lastOrNull(), []);
        end
        
        function lastOrNull_without_argument_on_non_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).lastOrNull(), 3);
            testCase.assertEqual(testCase.ofElements('a', 'b').lastOrNull(), 'b');
        end
        
        function lastOrNull_with_predicate_on_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements().lastOrNull(@(x) true), []);
            testCase.assertEqual(testCase.ofElements().lastOrNull(@(x) false), []);
        end
        
        function lastOrNull_with_predicate_on_non_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).lastOrNull(@(x) false), []);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).lastOrNull(@(x) x > 2), 3);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).lastOrNull(@(x) x < 2), 1);
            testCase.assertEqual(testCase.ofElements('a', 'b').lastOrNull(@(x) strcmp(x, 'a')), 'a');
            testCase.assertEqual(testCase.ofElements(1, 2, 3).lastOrNull(@(x) x > 3), []);
        end
        
        
        function find_on_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements().find(@(x) true), []);
            testCase.assertEqual(testCase.ofElements().find(@(x) false), []);
        end
        
        function find_on_non_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).find(@(x) x > 2), 3);
            testCase.assertEqual(testCase.ofElements('a', 'b').find(@(x) strcmp(x, 'a')), 'a');
            testCase.assertEqual(testCase.ofElements(1, 2, 3).find(@(x) x > 3), []);
        end
        
        
        function findLast_on_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements().findLast(@(x) true), []);
            testCase.assertEqual(testCase.ofElements().findLast(@(x) false), []);
        end
        
        function findLast_on_non_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).findLast(@(x) x > 2), 3);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).findLast(@(x) x < 2), 1);
            testCase.assertEqual(testCase.ofElements('a', 'b').findLast(@(x) strcmp(x, 'a')), 'a');
            testCase.assertEqual(testCase.ofElements(1, 2, 3).findLast(@(x) x > 3), []);
        end
        
        
        function indexOfFirst_on_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements().indexOfFirst(@(x) true), -1);
        end
        
        function indexOfFirst_on_non_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3, 3).indexOfFirst(@(x) x > 2), 3);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).indexOfFirst(@(x) x > 2), 3);
            testCase.assertEqual(testCase.ofElements('a', 'b').indexOfFirst(@(x) strcmp(x, 'a')), 1);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).indexOfFirst(@(x) x > 3), -1);
        end
        
        
        function indexOfLast_on_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements().indexOfLast(@(x) true), -1);
        end
        
        function indexOfLast_on_non_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).indexOfLast(@(x) x > 2), 3);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).indexOfLast(@(x) x < 2), 1);
            testCase.assertEqual(testCase.ofElements(1, 2, 3, 1).indexOfLast(@(x) x < 2), 4);
            testCase.assertEqual(testCase.ofElements('a', 'b').indexOfLast(@(x) strcmp(x, 'a')), 1);
            testCase.assertEqual(testCase.ofElements(1, 2, 3).indexOfLast(@(x) x > 3), -1);
        end
        
        
        function indexOf_on_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements().indexOf(1), -1);
            testCase.assertEqual(testCase.ofElements().indexOf('a'), -1);
        end
        
        function indexOf_no_match(testCase)
            collection = testCase.ofElements(1, 2, 2, 3, 2, 3);
            testCase.assertEqual(collection.indexOf(0), -1);
            testCase.assertEqual(collection.indexOf('123'), -1);
            
            collection = testCase.ofElements('A', 'a', 'bb', 'bb', 'a', 'z');
            testCase.assertEqual(collection.indexOf(0), -1);
            testCase.assertEqual(collection.indexOf('123'), -1);
        end
        
        function indexOf_element_that_matches(testCase)
            collection = testCase.ofElements(1, 2, 2, 3, 2, 3);
            testCase.assertEqual(collection.indexOf(1), 1);
            testCase.assertEqual(collection.indexOf(2), 2);
            testCase.assertEqual(collection.indexOf(3), 4);
        end
        
        
        function lastIndexOf_on_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements().lastIndexOf(2), -1);
            testCase.assertEqual(testCase.ofElements().lastIndexOf('a'), -1);
        end
        
        function lastIndexOf_on_non_empty_collection(testCase)
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
        
        
        function elementAt_on_empty_collection(testCase)
            collection = testCase.ofElements();
            try
                collection.elementAt(1);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
            
            try
                collection.elementAt(0);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
        end
        
        function elementAt_on_non_empty_collection(testCase)
            collection = testCase.ofElements(1, 2, 3, 4, 5);
            for i = 1:5
                testCase.assertEqual(collection.elementAt(i), i);
            end
            try
                collection.elementAt(6);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
            
            try
                collection.elementAt(0);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IndexOutOfBoundsException');
                testCase.assertEqual(ex.message, 'The collection does not contain any element at the specified index.');
            end
        end
        
        
        function elementAtOrElse_with_predicate_on_empty_collection(testCase)
            collection = testCase.ofElements();
            
            testCase.assertEqual(collection.elementAtOrElse(0, @(ind) 'c'), 'c');
            testCase.assertEqual(collection.elementAtOrElse(1, @(ind) 'a'), 'a');
            testCase.assertEqual(collection.elementAtOrElse(-1, @(ind) 'b'), 'b');
            
            
        end
        
        function elementAtOrElse_with_element_on_empty_collection(testCase)
            collection = testCase.ofElements();
            
            testCase.assertEqual(collection.elementAtOrElse(0, 'c'), 'c');
            testCase.assertEqual(collection.elementAtOrElse(1, 'a'), 'a');
            testCase.assertEqual(collection.elementAtOrElse(-1, 'b'), 'b');
            
        end
        
        function elementAtOrElse_with_predicate_on_non_empty_collection(testCase)
            collection = testCase.ofElements(1, 2, 3, 4, 5);
            for i = 1:10
                if i < 6
                    testCase.assertEqual(collection.elementAtOrElse(i, @(ind) 'a'), i);
                else
                    testCase.assertEqual(collection.elementAtOrElse(i, @(ind) 'a'), 'a');
                end
            end
            
            testCase.assertEqual(collection.elementAtOrElse(0, @(ind) 'c'), 'c');
            testCase.assertEqual(collection.elementAtOrElse(-1, @(ind) 'b'), 'b');
            
        end
        
        function elementAtOrElse_with_element_on_non_empty_collection(testCase)
            collection = testCase.ofElements(1, 2, 3, 4, 5);
            for i = 1:10
                if i < 6
                    testCase.assertEqual(collection.elementAtOrElse(i, 'a'), i);
                else
                    testCase.assertEqual(collection.elementAtOrElse(i, 'a'), 'a');
                end
            end
            
            testCase.assertEqual(collection.elementAtOrElse(0, 'c'), 'c');
            testCase.assertEqual(collection.elementAtOrElse(-1, 'b'), 'b');
        end
        
        
        function elementAtOrNull_on_empty_collection(testCase)
            collection = testCase.ofElements();
            
            testCase.assertEqual(collection.elementAtOrNull(-1), []);
            testCase.assertEqual(collection.elementAtOrNull(1), []);
            testCase.assertEqual(collection.elementAtOrNull(0), []);
        end
        
        function elementAtOrNull_on_non_empty_collection(testCase)
            collection = testCase.ofElements(1, 2, 3, 4, 5);
            for i = 1:5
                testCase.assertEqual(collection.elementAtOrNull(i), i);
            end
            
            for i = 6:10
                testCase.assertEqual(collection.elementAtOrNull(i), []);
            end
            testCase.assertEqual(collection.elementAtOrNull(-1), []);
            testCase.assertEqual(collection.elementAtOrNull(0), []);
        end
        
        
        function filter_on_empty_collection(testCase)
            list = testCase.ofElements().filter(@(x) true);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            list = testCase.ofElements().filter(@(x) false);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function filter_with_always_true_predicate(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).filter(@(x) true);
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
        end
        
        function filter_with_always_false_predicate(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).filter(@(x) false);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function filter_with_partially_matching_predicate(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).filter(@(x) mod(x, 2) == 0);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 2);
            
            testCase.assertEqual(list.get(1), 2);
            testCase.assertEqual(list.get(2), 4);
        end
        
        
        function filterNot_on_empty_collection(testCase)
            list = testCase.ofElements().filterNot(@(x) true);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            list = testCase.ofElements().filterNot(@(x) false);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function filterNot_with_always_true_predicate(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).filterNot(@(x) true);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function filterNot_with_always_false_predicate(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).filterNot(@(x) false);
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
            
        end
        
        function filterNot_with_partially_matching_predicate(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).filterNot(@(x) mod(x, 2) ~= 0);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 2);
            
            testCase.assertEqual(list.get(1), 2);
            testCase.assertEqual(list.get(2), 4);
        end
        
        
        function filterNotNull_on_empty_collection(testCase)
            list = testCase.ofElements().filterNotNull();
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function filterNotNull_on_non_empty_collection(testCase)
            list = testCase.ofElements(0, 1, [], 3, [], 5, '').filterNotNull();
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 0);
            testCase.assertEqual(list.get(2), 1);
            testCase.assertEqual(list.get(3), 3);
            testCase.assertEqual(list.get(4), 5);
            testCase.assertEqual(list.get(5), '');
            testCase.assertEqual(list.size(), 5);
        end
        
        
        function filterNotEmpty_on_empty_collection(testCase)
            list = testCase.ofElements().filterNotEmpty();
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function filterNotEmpty_on_non_empty_collection(testCase)
            list = testCase.ofElements(0, 1, [], 3, [], 5, '').filterNotEmpty();
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 0);
            testCase.assertEqual(list.get(2), 1);
            testCase.assertEqual(list.get(3), 3);
            testCase.assertEqual(list.get(4), 5);
            testCase.assertEqual(list.size(), 4);
        end
        
        
        function filterIsInstanceOf_on_empty_collection(testCase)
            list = testCase.ofElements().filterIsInstanceOf('char');
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements().filterIsInstanceOf('double');
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements().filterIsInstanceOf('TestDataClass');
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements().filterIsInstanceOf('TestHandleClass');
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function filterIsInstanceOf_on_non_empty_collection(testCase)
            list = testCase.ofElements(0, 1, [], 3, [], 5, '').filterIsInstanceOf('char');
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), '');
            testCase.assertEqual(list.size(), 1);
            
            list = testCase.ofElements(1, 2, 3, 4, 5).filterIsInstanceOf('double');
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
            
            tdc1 = TestDataClass();
            tdc1.Property1 = '1';
            tdc1.Property2 = '2';
            
            tdc2 = TestDataClass();
            tdc2.Property1 = '3';
            tdc2.Property2 = '4';
            
            thc1 = TestHandleClass();
            thc1.PropertyA = 'A';
            thc1.PropertyB = 'B';
            
            thc2 = TestHandleClass();
            thc2.PropertyA = 'C';
            thc2.PropertyB = 'D';
            
            list = testCase.ofElements(tdc1, thc1, tdc2, thc2).filterIsInstanceOf('TestDataClass');
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), tdc1);
            testCase.assertEqual(list.get(2), tdc2);
            testCase.assertEqual(list.size(), 2);
            
            list = testCase.ofElements(tdc1, thc1, tdc2, thc2).filterIsInstanceOf('TestHandleClass');
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), thc1);
            testCase.assertEqual(list.get(2), thc2);
            testCase.assertEqual(list.size(), 2);
        end
        
        
        function filterIndexed_on_empty_collection(testCase)
            list = testCase.ofElements().filterIndexed(@(ind, x) true);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function filterIndexed_on_non_empty_collection(testCase)
            list = testCase.ofElements('a', 'b', 'c', 'd', 'e').filterIndexed(@(ind, x) mod(ind, 2) == 0);
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 'b');
            testCase.assertEqual(list.get(2), 'd');
            testCase.assertEqual(list.size(), 2);
        end
        
        
        function take_on_empty_collection(testCase)
            list = testCase.ofElements().take(0);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements().take(1);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function take_with_illegal_argument(testCase)
            
            try
                testCase.ofElements().take(-1);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalArgumentException');
                testCase.assertEqual(ex.message, 'The requested element count is less than zero.');
            end
            
            try
                testCase.ofElements(1, 2, 3).take(-1);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalArgumentException');
                testCase.assertEqual(ex.message, 'The requested element count is less than zero.');
            end
            
            try
                testCase.ofElements(1, 2, 3).take('a');
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalArgumentException');
                testCase.assertEqual(ex.message, 'The requested element count is less than zero.');
            end
            
            try
                testCase.ofElements(1, 2, 3).take(TestDataClass());
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalArgumentException');
                testCase.assertEqual(ex.message, 'The requested element count is less than zero.');
            end
            
        end
        
        function take_inside_of_the_collection_size(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).take(0);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements(1, 2, 3, 4, 5).take(3);
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 3);
            
            list = testCase.ofElements(1, 2, 3, 4, 5).take(5);
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
            
            list = testCase.ofElements('a', 'b', 'c', 'd', 'e').take(2);
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 'a');
            testCase.assertEqual(list.get(2), 'b');
            testCase.assertEqual(list.size(), 2);
        end
        
        function take_outside_of_the_collection_size(testCase)
            
            list = testCase.ofElements(1, 2, 3, 4, 5).take(7);
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
            
            list = testCase.ofElements('a', 'b', 'c', 'd', 'e').take(100);
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 'a');
            testCase.assertEqual(list.get(2), 'b');
            testCase.assertEqual(list.get(3), 'c');
            testCase.assertEqual(list.get(4), 'd');
            testCase.assertEqual(list.get(5), 'e');
            testCase.assertEqual(list.size(), 5);
        end
        
        
        function takeWhile_on_empty_collection(testCase)
            list = testCase.ofElements().takeWhile(@(x) true);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements().takeWhile(@(x) false);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function takeWhile_with_always_true_predicate(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).takeWhile(@(x) true);
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
        end
        
        function takeWhile_with_always_false_predicate(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).takeWhile(@(x) false);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function takeWhile_with_partially_matching_predicate(testCase)
            
            list = testCase.ofElements('a', 'b', 'c', 'd', 'e').takeWhile(@(x) ~strcmp(x, 'c'));
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 'a');
            testCase.assertEqual(list.get(2), 'b');
            testCase.assertEqual(list.size(), 2);
            
            list = testCase.ofElements(1, 2, 3, 4, 5).takeWhile(@(x) isnumeric(x));
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
        end
        
        
        function drop_on_empty_collection(testCase)
            list = testCase.ofElements().drop(0);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements().drop(1);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            
        end
        
        function drop_with_illegal_argument(testCase)
            
            try
                testCase.ofElements().drop(-1);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalArgumentException');
                testCase.assertEqual(ex.message, 'The requested element count is less than zero.');
            end
            
            try
                testCase.ofElements(1, 2, 3).drop(-1);
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalArgumentException');
                testCase.assertEqual(ex.message, 'The requested element count is less than zero.');
            end
            
            try
                testCase.ofElements(1, 2, 3).drop('a');
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalArgumentException');
                testCase.assertEqual(ex.message, 'The requested element count is less than zero.');
            end
            
            try
                testCase.ofElements(1, 2, 3).drop(TestDataClass());
                testCase.verifyFail();
            catch ex
                testCase.assertEqual(ex.identifier, 'MXtension:IllegalArgumentException');
                testCase.assertEqual(ex.message, 'The requested element count is less than zero.');
            end
            
        end
        
        function drop_inside_the_collection_size(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).drop(0);
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
            
            list = testCase.ofElements(1, 2, 3, 4, 5).drop(1);
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntilWithOffset(list, 4, 2);
            
            list = testCase.ofElements(1, 2, 3, 4, 5).drop(5);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements('a', 'b', 'c', 'd', 'e').drop(3);
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 'd');
            testCase.assertEqual(list.get(2), 'e');
            testCase.assertEqual(list.size(), 2);
        end
        
        function drop_outside_the_collection_size(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).drop(6);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        
        function dropWhile_on_empty_collection(testCase)
            list = testCase.ofElements().dropWhile(@(x) true);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements().dropWhile(@(x) false);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function dropWhile_with_always_true_predicate(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).dropWhile(@(x) true);
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function dropWhile_with_always_false_predicate(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).dropWhile(@(x) false);
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
        end
        
        function dropWhile_with_partially_matching_predicate(testCase)
            
            list = testCase.ofElements('a', 'b', 'c', 'd', 'e').dropWhile(@(x) ~strcmp(x, 'd'));
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 'd');
            testCase.assertEqual(list.get(2), 'e');
            testCase.assertEqual(list.size(), 2);
            
            list = testCase.ofElements(1, 2, 3, 4, 5).dropWhile(@(x) ~isnumeric(x));
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
            
            list = testCase.ofElements(1, 2, 3, 4, 5).dropWhile(@(x) isnumeric(x));
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        
        function fold_on_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements().fold(0, @(acc, elem) 1000), 0);
            testCase.assertEqual(testCase.ofElements().fold(100, @(acc, elem) 1000), 100);
            thc = TestHandleClass();
            testCase.assertEqual(testCase.ofElements().fold(thc, @(acc, elem) 1000), thc);
        end
        
        function fold_on_non_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements(1, 2, 3).fold(0, @(acc, elem) acc), 0);
            
            testCase.assertEqual(testCase.ofElements('a', 'b', 'c', 'd', 'e').fold(0, @(acc, elem) acc+numel(elem)), 5);
            testCase.assertEqual(testCase.ofElements('a', 'bb', 'ccc').fold(0, @(acc, elem) acc+numel(elem)), 6);
            testCase.assertEqual(testCase.ofElements('a', 'bb', 'ccc').fold(10, @(acc, elem) acc+numel(elem)), 16);
            
            testCase.assertEqual(testCase.ofElements(testCase.ofElements(1), ...
                testCase.ofElements(1, 2, 3), ...
                testCase.ofElements(1, 2, 3, 4, 5)).fold(1000, @(acc, elem) acc+elem.size()), 1009);
        end
        
        function foldIndexed_on_empty_collection(testCase)
            testCase.assertEqual(testCase.ofElements().foldIndexed(0, @(ind, acc, elem) 1000), 0);
            testCase.assertEqual(testCase.ofElements().foldIndexed(100, @(ind, acc, elem) 1000), 100);
            thc = TestHandleClass();
            testCase.assertEqual(testCase.ofElements().foldIndexed(thc, @(ind, acc, elem) 1000), thc);
        end
        
        function foldIndexed_on_non_empty_collection(testCase)
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
        
        
        function map_on_empty_collection(testCase)
            emptyList = testCase.ofElements().map(@(e) e);
            testCase.mustBeList(emptyList);
            testCase.assertEqual(emptyList.size(), 0);
        end
        
        function map_on_non_empty_collection(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).map(@(e) e);
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
            
            list = testCase.ofElements('a', 'bb', 'ccc').map(@(elem) numel(elem));
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 3);
        end
        
        
        function mapNotNull_on_empty_collection(testCase)
            emptyList = testCase.ofElements().mapNotNull(@(e) e);
            testCase.mustBeList(emptyList);
            testCase.assertEqual(emptyList.size(), 0);
        end
        
        function mapNotNull_on_non_empty_collection(testCase)
            list = testCase.ofElements(1, [], 2, [], [], 3, 4, 5, []).mapNotNull(@(e) e);
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
            
            list = testCase.ofElements('a', 'bb', 'ccc').mapNotNull(@(elem) numel(elem));
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 3);
            
            list = testCase.ofElements(1, [], '', [], [], 4, struct()).mapNotNull(@(e) e);
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 1);
            testCase.assertEqual(list.get(2), '');
            testCase.assertEqual(list.get(3), 4);
            testCase.assertEqual(list.get(4), struct());
            testCase.assertEqual(list.size(), 4);
        end
        
        
        function mapNotEmpty_on_empty_collection(testCase)
            emptyList = testCase.ofElements().mapNotEmpty(@(e) e);
            testCase.mustBeList(emptyList);
            testCase.assertEqual(emptyList.size(), 0);
        end
        
        function mapNotEmpty_on_non_empty_collection(testCase)
            list = testCase.ofElements(1, [], 2, [], [], 3, 4, 5, []).mapNotEmpty(@(e) e);
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
            
            list = testCase.ofElements('a', 'bb', 'ccc').mapNotNull(@(elem) numel(elem));
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 3);
            
            
            list = testCase.ofElements(0, [], '', [], '', [], 1, {}, {'a'}).mapNotEmpty(@(e) e);
            testCase.mustBeList(list);
            testCase.assertEqual(list.get(1), 0);
            testCase.assertEqual(list.get(2), 1);
            testCase.assertEqual(list.get(3), {'a'});
            testCase.assertEqual(list.size(), 3);
        end
        
        
        function mapIndexed_on_empty_collection(testCase)
            emptyList = testCase.ofElements().mapIndexed(@(ind, e) e);
            testCase.mustBeList(emptyList);
            testCase.assertEqual(emptyList.size(), 0);
        end
        
        function mapIndexed_on_non_empty_collection(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).mapIndexed(@(ind, e) ind);
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
            
            list = testCase.ofElements(1, 2, 3, 4, 5).mapIndexed(@(ind, e) e);
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
        end
        
        
        function flatMap_on_empty_collection(testCase)
            emptyList = testCase.ofElements().flatMap(@(e) MXtension.listOf('a', 'b'));
            testCase.mustBeList(emptyList);
            testCase.assertEqual(emptyList.size(), 0);
        end
        
        function flatMap_on_non_empty_collection(testCase)
            list = testCase.ofElements(1, 2, 3).flatMap(@(e) MXtension.emptyList());
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements(1, 2, 3).flatMap(@(e) MXtension.emptySet());
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
            
            list = testCase.ofElements({1, 2}, {3, 4, 5}).flatMap(@(x) MXtension.listFrom(x));
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
            
            list = testCase.ofElements({1, 2}, {3, 4, 5}).flatMap(@(x) MXtension.setFrom(x));
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
            
            list = testCase.ofElements(MXtension.listOf(1, 2), MXtension.setOf(3, 4, 5)).flatMap(@(x) MXtension.listFrom(x));
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
            
            list = testCase.ofElements(testCase.javaListOf(1, 2), ...
                testCase.javaListOf(), ...
                testCase.javaSetOf(3, 4, 5), ...
                testCase.javaSetOf(), ...
                MXtension.setOf(), ...
                MXtension.setOf(6, 7), ...
                MXtension.listOf(8), ...
                MXtension.listOf(), ...
                {9, 10}, ...
                {}).flatMap(@(x) MXtension.setFrom(x));
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 10);
        end
        
        
        function flatten_on_empty_collection(testCase)
            emptyList = testCase.ofElements().flatten();
            testCase.mustBeList(emptyList);
            testCase.assertEqual(emptyList.size(), 0);
        end
        
        function flatten_on_non_empty_collection(testCase)
            
            list = testCase.ofElements(MXtension.listOf(1, 2), MXtension.setOf(3, 4, 5)).flatten();
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
            
            list = testCase.ofElements(testCase.javaListOf(1, 2), ...
                testCase.javaListOf(), ...
                testCase.javaSetOf(3, 4, 5), ...
                testCase.javaSetOf(), ...
                MXtension.setOf(), ...
                MXtension.setOf(6, 7), ...
                MXtension.listOf(8), ...
                MXtension.listOf(), ...
                {9, 10}, ...
                {}).flatten();
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 10);
            
        end
        
        
        function intersect_receiver_collection_is_empty(testCase)
            collections = testCase.allKindsOfCollectionsOf(1, 2, 3);
            for i = 1:numel(collections)
                set = testCase.ofElements().intersect(collections{i});
                testCase.mustBeSet(set);
                testCase.assertEqual(set.size(), 0);
            end
        end
        
        function intersect_passed_collection_is_empty(testCase)
            collections = testCase.allKindsOfCollectionsOf();
            for i = 1:numel(collections)
                set = testCase.ofElements(1, 2, 3).intersect(collections{i});
                testCase.mustBeSet(set);
                testCase.assertEqual(set.size(), 0);
            end
        end
        
        function intersect_both_collection_is_non_empty(testCase)
            collections = testCase.allKindsOfCollectionsOf(1, 2, 3, 4, 5);
            for i = 1:numel(collections)
                set = testCase.ofElements(1, 2, 3, 4, 5).intersect(collections{i});
                testCase.mustBeSet(set);
                testCase.assertElementsFromOneUntil(set, 5);
            end
            
            collections = testCase.allKindsOfCollectionsOf(2, 5, 1, 3, 4);
            for i = 1:numel(collections)
                set = testCase.ofElements(1, 2, 3, 4, 5).intersect(collections{i});
                testCase.mustBeSet(set);
                testCase.assertElementsFromOneUntil(set, 5);
            end
            
            collections = testCase.allKindsOfCollectionsOf(0, 2, 5, 1, 3, 4);
            for i = 1:numel(collections)
                set = testCase.ofElements(1, 2, 3, 4, 5).intersect(collections{i});
                testCase.mustBeSet(set);
                testCase.assertElementsFromOneUntil(set, 5);
            end
            
            collections = testCase.allKindsOfCollectionsOf(1, 2, 3, 4, 5);
            for i = 1:numel(collections)
                set = testCase.ofElements(0, 1, 11, 2, 22, 3, 33, 4, 44, 5, 55).intersect(collections{i});
                testCase.mustBeSet(set);
                testCase.assertElementsFromOneUntil(set, 5);
            end
            
            collections = testCase.allKindsOfCollectionsOf(1, 2, 3, 4, 5);
            for i = 1:numel(collections)
                set = testCase.ofElements(6, 7, 8, 9, 10).intersect(collections{i});
                testCase.mustBeSet(set);
                testCase.assertEqual(set.size(), 0);
            end
            
            collections = testCase.allKindsOfCollectionsOf('b', 'd', 'a');
            for i = 1:numel(collections)
                set = testCase.ofElements('a', 'b', 'c').intersect(collections{i});
                testCase.mustBeSet(set);
                testCase.assertEqual(set.size(), 2);
                it = set.iterator();
                testCase.assertEqual(it.next(), 'a');
                testCase.assertEqual(it.next(), 'b');
            end
            
            
            tdc1 = TestDataClass();
            tdc1.Property1 = '1';
            tdc1.Property2 = '2';
            
            tdc2 = TestDataClass();
            tdc2.Property1 = '1';
            tdc2.Property2 = '2';
            
            thc1 = TestHandleClass();
            thc1.PropertyA = 'A';
            thc1.PropertyB = 'B';
            
            thc2 = TestHandleClass();
            thc2.PropertyA = 'A';
            thc2.PropertyB = 'B';
            
            collections = testCase.matlabCollectionsOf(thc2, thc1, tdc2);
            for i = 1:numel(collections)
                set = testCase.ofElements(thc1, tdc1, 'c').intersect(collections{i});
                testCase.mustBeSet(set);
                testCase.assertEqual(set.size(), 2);
                it = set.iterator();
                testCase.assertEqual(it.next(), thc1);
                testCase.assertEqual(it.next(), tdc1);
            end
        end
        
        
        function distinct_on_empty_collection(testCase)
            list = testCase.ofElements().distinct();
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function distinct_on_non_empty_collection(testCase)
            list = testCase.ofElements(1, 2, 3, 4, 5).distinct();
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
            
            list = testCase.ofElements(1, 2, 3, 4, 5, 5, 4, 3, 2, 1).distinct();
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
            
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
            
            tdc1 = TestDataClass();
            tdc1.Property1 = '1';
            tdc1.Property2 = '2';
            
            tdc2 = TestDataClass();
            tdc2.Property1 = '1';
            tdc2.Property2 = '2';
            
            thc1 = TestHandleClass();
            thc1.PropertyA = 'A';
            thc1.PropertyB = 'B';
            
            thc2 = TestHandleClass();
            thc2.PropertyA = 'A';
            thc2.PropertyB = 'B';
            
            list = testCase.ofElements(tdc1, tdc2, thc1, thc2).distinct();
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 3);
            it = list.iterator();
            testCase.assertEqual(it.next(), tdc1);
            testCase.assertEqual(it.next(), thc1);
            testCase.assertEqual(it.next(), thc2);
        end
        
        
        function partition_on_empty_list(testCase)
            pair = testCase.ofElements().partition(@(x) true);
            testCase.mustBePair(pair);
            testCase.mustBeList(pair.First);
            testCase.mustBeList(pair.Second);
            testCase.assertEqual(pair.First.size(), 0);
            testCase.assertEqual(pair.Second.size(), 0);
        end
        
        function partition_with_always_true_predicate(testCase)
            pair = testCase.ofElements(0, 1, 2, 3, 4, 5).partition(@(x) true);
            testCase.mustBePair(pair);
            testCase.mustBeList(pair.First);
            testCase.mustBeList(pair.Second);
            testCase.assertEqual(pair.First.size(), 6);
            testCase.assertEqual(pair.Second.size(), 0);
            testCase.assertTrue(pair.First.containsAll(testCase.ofElements(0, 1, 2, 3, 4, 5)));
        end
        
        function partition_with_always_false_predicate(testCase)
            pair = testCase.ofElements(0, 1, 2, 3, 4, 5).partition(@(x) false);
            testCase.mustBePair(pair);
            testCase.mustBeList(pair.First);
            testCase.mustBeList(pair.Second);
            testCase.assertEqual(pair.First.size(), 0);
            testCase.assertEqual(pair.Second.size(), 6);
            testCase.assertTrue(pair.Second.containsAll(testCase.ofElements(0, 1, 2, 3, 4, 5)));
        end
        
        function partition_with_partially_matching_predicate(testCase)
            pair = testCase.ofElements(1, 2, 3, 4, 5).partition(@(x) x > 3);
            testCase.mustBePair(pair);
            testCase.mustBeList(pair.First);
            testCase.mustBeList(pair.Second);
            testCase.assertEqual(pair.First.size(), 2);
            testCase.assertEqual(pair.Second.size(), 3);
            
            testCase.assertElementsFromOneUntilWithOffset(pair.First, 2, 4);
            testCase.assertElementsFromOneUntil(pair.Second, 3);
        end
        
        
        function zip_without_transform_receiver_collection_is_empty(testCase)
            collections = testCase.allKindsOfCollectionsOf(1, 2, 3);
            for i = 1:numel(collections)
                list = testCase.ofElements().zip(collections{i});
                testCase.mustBeList(list);
                testCase.assertEqual(list.size(), 0);
            end
        end
        
        function zip_without_transform_passed_collection_is_empty(testCase)
            collections = testCase.allKindsOfCollectionsOf();
            for i = 1:numel(collections)
                list = testCase.ofElements(1, 2, 3).zip(collections{i});
                testCase.mustBeList(list);
                testCase.assertEqual(list.size(), 0);
            end
        end
        
        function zip_without_transform(testCase)
            collections = testCase.allKindsOfCollectionsOf(4, 5, 6);
            for iColl = 1:numel(collections)
                list = testCase.ofElements(1, 2, 3).zip(collections{iColl});
                testCase.mustBeList(list);
                testCase.assertEqual(list.size(), 3);
                for i = 1:3
                    elem = list.get(i);
                    testCase.mustBePair(elem);
                    testCase.assertEqual(elem.First, i);
                    switch i
                        case 1
                            testCase.assertEqual(elem.Second, 4);
                            break;
                        case 2
                            testCase.assertEqual(elem.Second, 5);
                            break;
                        case 3
                            testCase.assertEqual(elem.Second, 6);
                            break;
                    end
                end
            end
            
            collections = testCase.allKindsOfCollectionsOf('a', 'b', 'c', 'd');
            for iColl = 1:numel(collections)
                list = testCase.ofElements(1, 2, 3).zip(collections{iColl});
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
            end
            
            collections = testCase.allKindsOfCollectionsOf('a', 'b', 'c');
            for iColl = 1:numel(collections)
                list = testCase.ofElements(1, 2, 3, 4).zip(collections{iColl});
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
            end
        end
        
        function zip_with_transform_receiver_collection_is_empty(testCase)
            collections = testCase.allKindsOfCollectionsOf(1, 2, 3);
            for i = 1:numel(collections)
                list = testCase.ofElements().zip(collections{i}, @(first, second) MXtension.Pair(second, first));
                testCase.mustBeList(list);
                testCase.assertEqual(list.size(), 0);
            end
        end
        
        function zip_with_transform_passed_collection_is_empty(testCase)
            collections = testCase.allKindsOfCollectionsOf();
            for i = 1:numel(collections)
                list = testCase.ofElements(1, 2, 3).zip(collections{i}, @(first, second) MXtension.Pair(second, first));
                testCase.mustBeList(list);
                testCase.assertEqual(list.size(), 0);
            end
        end
        
        function zip_with_transform(testCase)
            collections = testCase.allKindsOfCollectionsOf('a', 'b', 'c');
            for iColl = 1:numel(collections)
                list = testCase.ofElements(1, 2, 3).zip(collections{iColl}, @(first, second) MXtension.Pair(second, first));
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
            end
            
            collections = testCase.allKindsOfCollectionsOf('a', 'b', 'c', 'd');
            for iColl = 1:numel(collections)
                list = testCase.ofElements(1, 2, 3).zip(collections{iColl}, @(first, second) MXtension.Pair(second, first));
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
            end
            
            collections = testCase.allKindsOfCollectionsOf('a', 'b', 'c');
            for iColl = 1:numel(collections)
                list = testCase.ofElements(1, 2, 3, 4).zip(collections{iColl}, @(first, second) MXtension.Pair(second, first));
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
            end
        end
        
        
        function associate_on_empty_collection(testCase)
            map = testCase.ofElements().associate(@(x) MXtension.Pair('a', 2));
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 0);
        end
        
        function associate_on_non_empty_collection(testCase)
            map = testCase.ofElements({'a', 1}, {'b', 2}, {'c', 3}).associate(@(x) MXtension.Pair(x{2}, x{1}));
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 3);
            testCase.assertEqual(map.get(1), 'a');
            testCase.assertEqual(map.get(2), 'b');
            testCase.assertEqual(map.get(3), 'c');
            
            map = testCase.ofElements({'a', 1}, {'b', 10}, {'a', 2}, {'b', 100}, {'a', 3}).associate(@(x) MXtension.Pair(x{1}, x{2}));
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 2);
            testCase.assertEqual(map.get('a'), 3);
            testCase.assertEqual(map.get('b'), 100);
        end
        
        
        function associateBy_keyselector_on_empty_collection(testCase)
            map = testCase.ofElements().associateBy(@(x) double(x));
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 0);
        end
        
        function associateBy_keySelector_and_valueTransform_on_empty_collection(testCase)
            map = testCase.ofElements().associateBy(@(x) double(x), @(x) [x, '-1']);
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 0);
        end
        
        function associateBy_keySelector_on_non_empty_collection(testCase)
            map = testCase.ofElements('a', 'b', 'c').associateBy(@(x) double(x));
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 3);
            testCase.assertEqual(map.get(97), 'a');
            testCase.assertEqual(map.get(98), 'b');
            testCase.assertEqual(map.get(99), 'c');
            
            map = testCase.ofElements('a', 'b', 'c').associateBy(@(x) 10);
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 1);
            testCase.assertEqual(map.get(10), 'c');
        end
        
        function associateBy_keySelector_valueTransform_on_non_empty_collection(testCase)
            map = testCase.ofElements('a', 'b', 'c').associateBy(@(x) double(x), @(x) [x, '-', num2str(double(x))]);
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 3);
            testCase.assertEqual(map.get(97), 'a-97');
            testCase.assertEqual(map.get(98), 'b-98');
            testCase.assertEqual(map.get(99), 'c-99');
            
            map = testCase.ofElements('a', 'b', 'c').associateBy(@(x) 10, @(x) [x, '-', num2str(double(x))]);
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 1);
            testCase.assertEqual(map.get(10), 'c-99');
        end
        
        
        function associateWith_on_empty_collection(testCase)
            map = testCase.ofElements().associateWith(@(x) double(x));
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 0);
        end
        
        function associateWith_on_non_empty_collection(testCase)
            map = testCase.ofElements('a', 'b', 'c').associateWith(@(x) double(x));
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 3);
            testCase.assertEqual(map.get('a'), 97);
            testCase.assertEqual(map.get('b'), 98);
            testCase.assertEqual(map.get('c'), 99);
            
            map = testCase.ofElements('a', 'a', 'a').associateWith(@(x) 10);
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 1);
            testCase.assertEqual(map.get('a'), 10);
        end
        
        
        function groupBy_keySelector_on_empty_collection(testCase)
            map = testCase.ofElements().groupBy(@(x) numel(x));
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 0);
        end
        
        function groupBy_keySelector_valueTransform_on_empty_collection(testCase)
            map = testCase.ofElements().groupBy(@(x) numel(x), @(x) [x, '-', x]);
            testCase.mustBeMap(map);
            testCase.assertEqual(map.keys.size(), 0);
        end
        
        function groupBy_keySelector_on_non_empty_collection(testCase)
            
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
        end
        
        function groupBy_keySelector_valueTransform_on_non_empty_collection(testCase)
            
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
        
        
        function reversed_on_empty_collection(testCase)
            list = testCase.ofElements().reversed();
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function reversed_on_non_empty_collection(testCase)
            list = testCase.ofElements('a', 'b', 'c').reversed();
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 3);
            testCase.assertEqual(list.get(1), 'c');
            testCase.assertEqual(list.get(2), 'b');
            testCase.assertEqual(list.get(3), 'a');
            
            list = testCase.ofElements(5, 4, 3, 2, 1).reversed();
            testCase.mustBeList(list);
            testCase.assertElementsFromOneUntil(list, 5);
        end
        
        
        function joinToChar_on_empty_collection(testCase)
            str = testCase.ofElements().joinToChar();
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(numel(str), 0);
            
            str = testCase.ofElements().joinToChar('transform', @(x) [x, '1']);
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(numel(str), 0);
            
            str = testCase.ofElements().joinToChar('truncated', 'mytruncate');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(numel(str), 0);
            
            str = testCase.ofElements().joinToChar('limit', 0);
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(numel(str), 0);
            
            str = testCase.ofElements().joinToChar('limit', 1, 'truncated', 'mytruncate');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(numel(str), 0);
            
            str = testCase.ofElements().joinToChar('limit', 1);
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(numel(str), 0);
            
            str = testCase.ofElements().joinToChar('separator', '-');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(numel(str), 0);
            
            str = testCase.ofElements().joinToChar('separator', '-', 'limit', 0);
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(numel(str), 0);
            
            str = testCase.ofElements().joinToChar('separator', '-', 'limit', 1);
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(numel(str), 0);
            
            str = testCase.ofElements().joinToChar('separator', '-', 'limit', 1, 'truncated', 'mytruncate');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(numel(str), 0);
            
            str = testCase.ofElements().joinToChar('prefix', 'myprefix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'myprefix');
            
            str = testCase.ofElements().joinToChar('limit', 0, 'prefix', 'myprefix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'myprefix');
            
            str = testCase.ofElements().joinToChar('limit', 1, 'prefix', 'myprefix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'myprefix');
            
            str = testCase.ofElements().joinToChar('limit', 1, 'truncated', 'mytruncate', 'prefix', 'myprefix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'myprefix');
            
            str = testCase.ofElements().joinToChar('separator', '-', 'prefix', 'myprefix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'myprefix');
            
            str = testCase.ofElements().joinToChar('limit', 0, 'separator', '-', 'prefix', 'myprefix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'myprefix');
            
            str = testCase.ofElements().joinToChar('limit', 1, 'separator', '-', 'prefix', 'myprefix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'myprefix');
            
            str = testCase.ofElements().joinToChar('limit', 1, 'truncated', 'mytruncate', 'separator', '-', 'prefix', 'myprefix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'myprefix');
            
            str = testCase.ofElements().joinToChar('postfix', 'mypostfix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'mypostfix');
            
            str = testCase.ofElements().joinToChar('limit', 0, 'postfix', 'mypostfix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'mypostfix');
            
            str = testCase.ofElements().joinToChar('limit', 1, 'postfix', 'mypostfix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'mypostfix');
            
            str = testCase.ofElements().joinToChar('limit', 1, 'truncated', 'mytruncate', 'postfix', 'mypostfix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'mypostfix');
            
            str = testCase.ofElements().joinToChar('separator', '-', 'postfix', 'mypostfix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'mypostfix');
            
            str = testCase.ofElements().joinToChar('limit', 0, 'separator', '-', 'postfix', 'mypostfix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'mypostfix');
            
            str = testCase.ofElements().joinToChar('limit', 1, 'separator', '-', 'postfix', 'mypostfix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'mypostfix');
            
            str = testCase.ofElements().joinToChar('limit', 1, 'truncated', 'mytruncate', 'separator', '-', 'postfix', 'mypostfix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'mypostfix');
            
            str = testCase.ofElements().joinToChar('prefix', 'myprefix', 'postfix', 'mypostfix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'myprefixmypostfix');
            
            str = testCase.ofElements().joinToChar('limit', 0, 'prefix', 'myprefix', 'postfix', 'mypostfix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'myprefixmypostfix');
            
            str = testCase.ofElements().joinToChar('limit', 1, 'prefix', 'myprefix', 'postfix', 'mypostfix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'myprefixmypostfix');
            
            str = testCase.ofElements().joinToChar('limit', 1, 'truncated', 'mytruncate', 'prefix', 'myprefix', 'postfix', 'mypostfix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'myprefixmypostfix');
            
            str = testCase.ofElements().joinToChar('separator', '-', 'prefix', 'myprefix', 'postfix', 'mypostfix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'myprefixmypostfix');
            
            str = testCase.ofElements().joinToChar('limit', 0, 'separator', '-', 'prefix', 'myprefix', 'postfix', 'mypostfix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'myprefixmypostfix');
            
            str = testCase.ofElements().joinToChar('limit', 1, 'separator', '-', 'prefix', 'myprefix', 'postfix', 'mypostfix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'myprefixmypostfix');
            
            str = testCase.ofElements().joinToChar('limit', 1, 'truncated', 'mytruncate', 'separator', '-', 'prefix', 'myprefix', 'postfix', 'mypostfix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'myprefixmypostfix');
        end
        
        function joinToChar_defaults(testCase)
            str = testCase.ofElements('a', 'b', 'c').joinToChar();
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'a, b, c');
            
            str = testCase.ofElements('a').joinToChar();
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'a');
        end
        
        function joinToChar_transform(testCase)
            str = testCase.ofElements('a', 'b', 'c').joinToChar('transform', @(x) [x, '-1']);
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'a-1, b-1, c-1');
            
            str = testCase.ofElements('a').joinToChar('transform', @(x) [x, '-1']);
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'a-1');
        end
        
        function joinToChar_separator(testCase)
            str = testCase.ofElements('a', 'b', 'c').joinToChar('separator', '+');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'a+b+c');
            
            str = testCase.ofElements('a').joinToChar('separator', '+');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'a');
        end
        
        function joinToChar_transform_separator(testCase)
            str = testCase.ofElements('a', 'b', 'c').joinToChar('transform', @(x) [x, '-1'], 'separator', '+');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'a-1+b-1+c-1');
            
            str = testCase.ofElements('a').joinToChar('transform', @(x) [x, '-1'], 'separator', '+');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'a-1');
        end
        
        function joinToChar_prefix_postfix(testCase)
            str = testCase.ofElements('a', 'b', 'c').joinToChar('prefix', 'myprefix+');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'myprefix+a, b, c');
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('postfix', '+mypostfix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'a, b, c+mypostfix');
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('prefix', 'myprefix+', 'postfix', '+mypostfix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'myprefix+a, b, c+mypostfix');
            
            str = testCase.ofElements('a').joinToChar('prefix', 'myprefix+');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'myprefix+a');
            
            str = testCase.ofElements('a').joinToChar('postfix', '+mypostfix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'a+mypostfix');
            
            str = testCase.ofElements('a').joinToChar('prefix', 'myprefix+', 'postfix', '+mypostfix');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'myprefix+a+mypostfix');
        end
        
        function joinToChar_limit(testCase)
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 0);
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, '...');
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 1);
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'a, ...');
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 2);
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'a, b, ...');
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 3);
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'a, b, c');
        end
        
        function joinToChar_limit_prefix_postfix(testCase)
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 0, 'prefix', 'pre');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'pre...');
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 0, 'postfix', 'post');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, '...post');
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 0, 'prefix', 'pre', 'postfix', 'post');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'pre...post');
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 1, 'prefix', 'pre');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'prea, ...');
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 1, 'postfix', 'post');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'a, ...post');
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 1, 'prefix', 'pre', 'postfix', 'post');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'prea, ...post');
            
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 2, 'prefix', 'pre');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'prea, b, ...');
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 2, 'postfix', 'post');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'a, b, ...post');
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 2, 'prefix', 'pre', 'postfix', 'post');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'prea, b, ...post');
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 3, 'prefix', 'pre');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'prea, b, c');
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 3, 'postfix', 'post');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'a, b, cpost');
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 3, 'prefix', 'pre', 'postfix', 'post');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'prea, b, cpost');
        end
        
        function joinToChar_limit_truncate(testCase)
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 0, 'truncate', '++++');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, '++++');
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 1, 'truncate', '++++');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'a, ++++');
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 2, 'truncate', '++++');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'a, b, ++++');
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 3, 'truncate', '++++');
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'a, b, c');
        end
        
        
        function joinToChar_everything_set(testCase)
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 0, 'truncate', '++', 'prefix', 'pre', 'postfix', 'post', 'separator', '@', 'transform', @(x) [x, '!']);
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'pre++post');
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 1, 'truncate', '++', 'prefix', 'pre', 'postfix', 'post', 'separator', '@', 'transform', @(x) [x, '!']);
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'prea!@++post');
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 2, 'truncate', '++', 'prefix', 'pre', 'postfix', 'post', 'separator', '@', 'transform', @(x) [x, '!']);
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'prea!@b!@++post');
            
            str = testCase.ofElements('a', 'b', 'c').joinToChar('limit', 3, 'truncate', '++', 'prefix', 'pre', 'postfix', 'post', 'separator', '@', 'transform', @(x) [x, '!']);
            testCase.assertTrue(ischar(str))
            testCase.assertEqual(str, 'prea!@b!@c!post');
        end
        
        function toList_on_empty_collection(testCase)
            list = testCase.ofElements().toList();
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function toList_on_collection(testCase)
            list = testCase.ofElements('a', 1, 'dog').toList();
            testCase.mustBeList(list);
            testCase.assertEqual(list.size(), 3);
            testCase.assertEqual(list.get(1), 'a');
            testCase.assertEqual(list.get(2), 1);
            testCase.assertEqual(list.get(3), 'dog');
        end
        
        function toMutableList_on_empty_collection(testCase)
            list = testCase.ofElements().toMutableList();
            testCase.mustBeMutableList(list);
            testCase.assertEqual(list.size(), 0);
        end
        
        function toMutableList_on_collection(testCase)
            list = testCase.ofElements('a', 1, 'dog').toMutableList();
            testCase.mustBeMutableList(list);
            testCase.assertEqual(list.size(), 3);
            testCase.assertEqual(list.get(1), 'a');
            testCase.assertEqual(list.get(2), 1);
            testCase.assertEqual(list.get(3), 'dog');
        end
        
        function toSet_on_empty_collection(testCase)
            set = testCase.ofElements().toSet();
            testCase.mustBeSet(set);
            testCase.assertEqual(set.size(), 0);
        end
        
        function toSet_on_collection(testCase)
            set = testCase.ofElements('a', 1, 'dog').toSet();
            testCase.mustBeSet(set);
            testCase.assertEqual(set.size(), 3);
            testCase.assertTrue(set.contains('a'));
            testCase.assertTrue(set.contains(1));
            testCase.assertTrue(set.contains('dog'));
        end
        
        function toMutableSet_on_empty_collection(testCase)
            set = testCase.ofElements().toMutableSet();
            testCase.mustBeMutableSet(set);
            testCase.assertEqual(set.size(), 0);
        end
        
        function toMutableSet_on_collection(testCase)
            set = testCase.ofElements('a', 1, 'dog').toMutableSet();
            testCase.mustBeMutableSet(set);
            testCase.assertEqual(set.size(), 3);
            testCase.assertTrue(set.contains('a'));
            testCase.assertTrue(set.contains(1));
            testCase.assertTrue(set.contains('dog'));
        end
        
        function toCellArray_on_empty_collection(testCase)
            cellArray = testCase.ofElements().toCellArray();
            testCase.mustBeCellArray(cellArray);
            testCase.assertEqual(numel(cellArray), 0);
        end
        
        function toCellArray_on_collection(testCase)
            cellArray = testCase.ofElements('a', 1, 'dog').toCellArray();
            testCase.mustBeCellArray(cellArray);
            testCase.assertEqual(size(cellArray), [1, 3]);
            
            testCase.assertEqual(cellArray{1}, 'a');
            testCase.assertEqual(cellArray{2}, 1);
            testCase.assertEqual(cellArray{3}, 'dog');
        end
    end
    
end
