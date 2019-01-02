classdef (Abstract) Iterator < handle
    
    methods(Abstract)
        % Returns true if the iteration has more elements.
        hasNext = hasNext(obj);
        % Returns the next element in the iteration.
        nextElement = next(obj);
    end
    
end
