classdef Entry < handle
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
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
