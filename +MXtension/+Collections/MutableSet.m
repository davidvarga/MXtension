classdef (Abstract) MutableSet < MXtension.Collections.Set & MXtension.Collections.MutableCollection

    methods (Abstract)
       % changed: logical = add(element: Any) - Adds the specified element to the set. Returns true if the set was changed, false otherwise.
        modified = add(obj, element) 
        
    end   
end

