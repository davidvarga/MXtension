classdef IndexedValue < handle
    
    
    properties
        Index;
        Value;
    end
    
    methods
        function obj = IndexedValue(index, value)
            obj.Index = index;
            obj.Value = value;
        end
        
    end
end
