classdef MutableEntry < MXtension.Collections.Entry
    %UNTITLED7 Summary of this class goes here
    %   Detailed explanation goes here
    
 
    
    methods
        function obj = MutableEntry(key, value)
            obj@MXtension.Collections.Entry(key, value)
        end
        
        function oldValue = setValue(obj, value)
            oldValue = obj.Value;
            obj.Value = value;
        end
    end
    
end

