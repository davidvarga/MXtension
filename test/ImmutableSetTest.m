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
        
       
        
      
    end
end