classdef Map < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        InnerMap;
    end
    
    methods
        function obj = Map(inputMap)
            if isa(inputMap, 'containers.Map')
                obj.InnerMap = inputMap;
            else
                % TODO: now only entry
                obj.InnerMap = containers.Map();
                for i= 1:inputMap.count()
                    entry = inputMap.get(i);
                    obj.InnerMap(entry.Key) = entry.Value;
                end
            end
        end
        
        function retSize = size(obj)
            retSize = obj.InnerMap.Count;
        end
        
        function boolean = isEmpty(obj)
            boolean = obj.InnerMap.isempty;
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
        
        % TODO: Set!
        function list = keys(obj)
            list = MXtension.listOf(obj.InnerMap.keys);
        end
        
        function boolean = containsKey(obj, key)
           boolean = obj.InnerMap.isKey(key); 
        end
        
        function list = values(obj)
            list = MXtension.listOf(obj.InnerMap.values);
        end
        
         function boolean = containsValue(obj, value)
           boolean = obj.values.any(@(elem) isequal(elem, value));
        end
        
        function obj = clear(obj)
           obj.InnerMap = containers.Map(); 
        end
        
        function obj = put(obj, key, value)
           obj.InnerMap(key) = value; 
        end
        
        function obj = set(obj, key, value)
           obj.put(key, value);
        end
        
        function obj = putAll(obj, map)
            if isa(map, 'containers.Map')
                tempMap = MXtension.Collections.Map(map);
                obj.putAll(tempMap);
            elseif isa(map, 'MXtension.Collections.Map')
                % TODO: map.entries.foreach
                entries = map.entries;
                for i = 1:entries.size()
                    cEntry = entries.get(i);
                    obj.put(cEntry.Key, cEntry.Value);
               
                end
                
            else
                % TODO: Error
            end
        end
        
        function [value, present] = get(obj, key)
            [value, present] = obj.getOrDefault(key, []);
        end
        
        function [value, present] = getOrDefault(obj, key, defaultValue)
           present = false;
           value = defaultValue;
            if obj.containsKey(key)
               present = true;
               value = obj.InnerMap(key);
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
        
        function [value, present] = remove(obj, varargin)
            
           [value, present] = obj.get(key);
           if present
              obj.InnerMap.remove(key); 
           end
        end
        
        function boolean = removeEntry(obj, varargin)
           if nargin == 2
              % MXtension.Collections.Entry 
              % TODO: implement
           elseif nargin == 3
               % key + value
               key = varargin{1};
               value = varargin{2};
               
               boolean = false;
               [currentValue, present] = obj.get(key);
               if present
                  if isequal(currentValue, value)
                      boolean = true;
                     obj.InnerMap.remove(key); 
                  end
               end
           else
               % TODO: Error!
           end
            
        end
        
        function entries = entries(obj)
            keys = obj.InnerMap.keys;
            entries = MXtension.emptyList();
            for i = 1:numel(keys)
               entries.add(MXtension.Collections.Entry(keys{i}, obj.InnerMap(keys{i}))); 
            end
        end
        
        function map = filter(obj, predicate)
   
            map = MXtension.Collections.Map(obj.entries().filter(predicate));
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

