classdef ImmutableMap < MXtension.Collections.Map
    properties(Access = protected)
        InnerMap;
    end
    
    methods(Static)
        function map = fromMap(map)
            map = MXtension.Collections.ImmutableMap('map', map);
        end
        
        function map = ofEntries(varargin)
            map = MXtension.Collections.ImmutableMap('entries', varargin);
        end
    end
    
    methods(Access = protected)
        function obj = ImmutableMap(sourceType, source)
            if strcmp(sourceType, 'map')
                if isa(source, 'containers.Map')
                    keys = source.keys;
                    obj.InnerMap = containers.Map();
                    keyType = '';
                    for i = 1:numel(keys)
                        key = keys{i};
                        if isempty(keyType)
                            keyType = class(key);
                            obj.InnerMap = containers.Map('KeyType', keyType, 'ValueType', 'any');
                        end
                        obj.InnerMap(key) = source(key);
                    end
                elseif isa(source, 'MXtension.Collections.Map')
                    obj.InnerMap = source.InnerMap;
                elseif isa(source, 'java.util.Map')
                    obj.InnerMap = containers.Map();
                    iterator = source.keySet().iterator();
                    while iterator.hasNext()
                        key = iterator.next();
                        obj.InnerMap(key) = source.get(key);
                    end
                else
                    % TODO: IllegalArgument
                    error('IllegalArgument')
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
                        throw(MException('MXtension:IllegalArgumentException', 'The passed source map type is not supported.'));
                    end
                    
                end
            else
                throw(MException('MXtension:IllegalArgumentException', 'The passed source type argument is invalid.'));
            end
            
            
        end
    end
    
    methods
        function retSize = size(obj)
            retSize = obj.InnerMap.Count;
        end
        
        function set = keys(obj)
            set = MXtension.setFrom(obj.InnerMap.keys);
        end
        
        function list = values(obj)
            list = MXtension.listFrom(obj.InnerMap.values);
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
    end
    
end
