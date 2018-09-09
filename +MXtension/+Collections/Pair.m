classdef Pair < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        First;
        Second;
    end
    
    methods
        function obj = Pair(first, second)
           obj.First = first;
           obj.Second = second;
        end
    end
    
end

