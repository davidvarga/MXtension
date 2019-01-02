classdef ImmutableList < MXtension.Collections.List
    
    properties(Access = protected)
        CellArray;
    end
    
    %% Factories
    methods(Static)
        function list = fromCollection(collection)
            % Returns a new List containing the elements in the input collection while keeping the original order. The input collection must be the
            % type of a cell array, an instance of MXtension.Collections.List or an instance of java.util.Collection.
            
            list = MXtension.Collections.ImmutableList('collection', collection);
        end
        
        function list = ofElements(varargin)
            % Returns a new List containing the elements in the input arguments keeping the argument order.
            
            list = MXtension.Collections.ImmutableList('elements', varargin);
        end
    end
    
    methods(Access = protected)
        function obj = ImmutableList(sourceType, source)
            if strcmp(sourceType, 'elements')
                if isempty(source)
                    obj.CellArray = {};
                else
                    obj.CellArray = source;
                end
            elseif strcmp(sourceType, 'size')
                
                if iscell(source)
                    obj.CellArray = cell(1, source{1});
                    initSelector = source{2};
                    for i = 1:numel(obj.CellArray)
                        obj.CellArray{i} = initSelector(i);
                    end
                else
                    obj.CellArray = cell(1, source);
                end
                
            elseif strcmp(sourceType, 'collection')
                if iscell(source)
                    obj.CellArray = source;
                elseif isa(source, 'MXtension.Collections.List')
                    obj.CellArray = source.toCellArray();
                elseif isa(source, 'MXtension.Collections.Collection')
                    iterator = source.iterator();
                    obj.CellArray = {};
                    while iterator.hasNext()
                        obj.CellArray{end+1} = iterator.next();
                    end
                    
                elseif isa(source, 'java.util.Collection')
                    iterator = source.iterator();
                    obj.CellArray = cell(1, source.size());
                    index = 1;
                    while iterator.hasNext()
                        obj.CellArray{index} = iterator.next();
                        index = index + 1;
                    end
                else
                    throw(MException('MXtension:IllegalArgumentException', 'The passed collection type is not supported.'));
                end
            else
                throw(MException('MXtension:IllegalArgumentException', 'The passed source type argument is invalid.'));
            end
        end
    end
    
    methods
        function item = get(obj, index)
            obj.verifySuppliedIndexToRetrieve(index);
            
            item = obj.CellArray{index};
        end
        
        function size = size(obj)
            size = numel(obj.CellArray);
        end
    end
    
    methods
        function cellArray = toCellArray(obj)
            cellArray = obj.CellArray;
        end
    end
    
    
end