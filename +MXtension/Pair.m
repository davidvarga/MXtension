classdef Pair < handle

    properties (SetAccess = protected)
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
