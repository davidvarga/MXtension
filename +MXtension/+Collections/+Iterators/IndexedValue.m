classdef IndexedValue < handle
    
    properties(SetAccess = protected)
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
