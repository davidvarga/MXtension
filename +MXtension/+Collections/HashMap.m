classdef HashMap < MXtension.Collections.MutableMap
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    
    properties(Access = protected)
        InnerMap;
    end
    
    %% Factories
    methods(Static)
        function map = fromMap(map)
            % containers.Map, an instance of MXtension.Collections.Map or an instance of java.util.Map.
            
            map = MXtension.Collections.HashMap('map', map);
        end
        
        function map = ofEntries(varargin)
            
            
            map = MXtension.Collections.HashMap('entries', varargin);
        end
        
        
    end
    
    methods(Access = protected)
        function obj = HashMap(sourceType, source)
            
            if strcmp(sourceType, 'map')
                
                if isa(source, 'containers.Map')
                    keys = source.keys;
                    obj.InnerMap = containers.Map();
                    for i =1: numel(keys)
                        key = keys{i};
%                         entry = MXtension.Collections.Entry(key, source(key));
                        obj.InnerMap(key) = source(key);
                    end
                elseif isa(source, 'MXtension.Collections.Map')
                    obj = MXtension.Collections.MutableMap.fromMap(source.InnerMap);
                  
                elseif isa(source, 'java.util.Map')
                    obj.InnerMap = containers.Map();
                    iterator = source.keySet().iterator();
                    while iterator.hasNext()
                        key = iterator.next();
                        obj.InnerMap(key) = source.get(key);
                    end
                else
                    throw(MException('MXtension:IllegalArgumentException', 'The passed source map type is not supported.'));
                end
                
            elseif strcmp(sourceType, 'entries')
                obj.InnerMap = containers.Map();
                source = MXtension.listFrom(source);
                for i = 1:source.count()
                    entryOrPair = source.get(i);
                    if isa(entryOrPair, 'MXtension.Collections.Entry')
                        obj.InnerMap(entryOrPair.Key) = entryOrPair.Value;
                    elseif isa(entryOrPair, 'MXtension.Pair')
                        obj.InnerMap(entryOrPair.First) = entryOrPair.Second;
                    else
                        % TODO: IllegalArgument
                        error('IllegalArgument')
                    end
                    
                end
            else
                % TODO: IllegalArgument
                error('IllegalArgument')
            end
            
            
        end
    end
    
    methods
        
        
        function retSize = size(obj)
            retSize = obj.InnerMap.Count;
        end
        
        
        function set = keys(obj)
            set = MXtension.setOf(obj.InnerMap.keys);
        end
        
        
        function list = values(obj)
            list = MXtension.listOf(obj.InnerMap.values);
        end
        
        
        function [value, present] = get(obj, key)
            present = false;
            value = [];
            if obj.containsKey(key)
                present = true;
                value = obj.InnerMap(key);
            end
            
            
        end
        
       
        function entries = entries(obj)
            keys = obj.InnerMap.keys;
            entries = MXtension.mutableSetOf();
            for i = 1:numel(keys)
                entries.add(MXtension.Collections.Entry(keys{i}, obj.InnerMap(keys{i})));
            end
            entries = entries.toSet();
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
        

        

        
        function [value, present] = remove(obj, key)
            
            [value, present] = obj.get(key);
            if present
                obj.InnerMap.remove(key);
            end
        end
        
      

    end
    
end
