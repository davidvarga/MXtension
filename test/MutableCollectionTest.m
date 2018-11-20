classdef (Abstract) MutableCollectionTest < CollectionTest & matlab.unittest.TestCase
    

    methods(Access = protected, Sealed)
   
        
        function mustBeIterator(obj, iterator)
            obj.assertTrue(isa(iterator, 'MXtension.Collections.Iterators.Iterator'));
            obj.assertTrue(isa(iterator, 'MXtension.Collections.Iterators.MutableIterator'));
        end
        
      
       

    end
    

end
