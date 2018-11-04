classdef (Abstract) Iterator < handle
    
    methods(Abstract)
        hasNext = hasNext(obj);
        nextElement = next(obj);
        
    end
    
end
