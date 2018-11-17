classdef MutableMap < MXtension.Collections.Map
    %UNTITLED12 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Abstract)
        obj = clear(obj);
        obj = put(obj, key, value);
        obj = set(obj, key, value);
        [value, present] = remove(obj, varargin);
    end
    
    methods
        
        function obj = putAll(obj, map)
            tempMap = MXtension.Collections.ImmutableMap.fromMap(map);
            
            iterator = tempMap.entries.iterator();
            while iterator.hasNext()
                cEntry = iterator.next();
                obj.put(cEntry.Key, cEntry.Value);
                
            end
        end
        
        function value = getOrPut(obj, key, defaultValue)
            [currentValue, present] = obj.get(key);
            
            if ~present
                obj.put(key, defaultValue);
                value = defaultValue;
            else
                value = currentValue;
            end
        end
        
        function boolean = removeEntry(obj, varargin)
            if nargin == 2
                entry = varargin{1};
                key = entry.Key;
                value = entry.Value;
                
            elseif nargin == 3
                % key + value
                key = varargin{1};
                value = varargin{2};
                
                
            else
                % TODO: Error!
                error('IllegalArgument')
            end
            
            boolean = false;
            [currentValue, present] = obj.get(key);
            if present
                if MXtension.equals(currentValue, value)
                    
                    boolean = true;
                    obj.remove(key);
      
                end
            end
            
        end
        
        
    end
    
end
