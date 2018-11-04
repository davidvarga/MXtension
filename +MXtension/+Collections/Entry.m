classdef Entry < handle
    
    properties
        Key;
        Value;
    end
    
    methods
        function obj = Entry(key, value)
            obj.Key = key;
            obj.Value = value;
        end
    end
    
end
