classdef (Abstract) Map < handle
    %UNTITLED11 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Abstract)
        retSize = size(obj);
        set = keys(obj);
        list = values(obj);
        entries = entries(obj);
        
        [value, present] = get(obj, key);
    end
    
    methods
        
        function [value, present] = getOrDefault(obj, key, defaultValue)
            [value, present] = obj.get(key);
            if ~present
                
                value = defaultValue;
                
            end
            
        end
        
        function boolean = isEmpty(obj)
            boolean = obj.size() == 0;
        end
        
        function boolean = isNotEmpty(obj)
            boolean = ~obj.isEmpty();
        end
        
        function boolean = none(obj, varargin)
            boolean = obj.entries.none(varargin{:});
        end
        
        function boolean = all(obj, varargin)
            boolean = obj.entries.all(varargin{:});
        end
        
        function boolean = any(obj, varargin)
            boolean = obj.entries.any(varargin{:});
        end
        
        function boolean = containsKey(obj, key)
            boolean = obj.keys().contains(key);
        end
        
        function boolean = containsValue(obj, value)
            boolean = obj.values.any(@(elem) isequal(elem, value));
        end
        
        function map = filter(obj, predicate)
            
            map = MXtension.Collections.ImmutableMap(obj.entries().filter(predicate));
        end
        
        function map = filterKeys(obj, predicate)
            map = obj.filter(@(entry) predicate(entry.Key));
        end
        
        function map = filterValues(obj, predicate)
            map = obj.filter(@(entry) predicate(entry.Value));
        end
        
        function retCount = count(obj, varargin)
            if nargin == 1
                retCount = obj.size();
            else
                retCount = obj.entries.count(varargin{:});
            end
        end
        
        function retCount = countKeys(obj, predicate)
            
            retCount = obj.keys.count(predicate);
            
        end
        
        function retCount = countValues(obj, predicate)
            
            retCount = obj.values.count(predicate);
            
        end
        
        
    end
    
end
