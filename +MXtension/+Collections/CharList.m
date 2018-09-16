classdef CharList < MXtension.Collections.List
    
    properties
        
    end
    
    methods
        function obj = CharList(varargin)
            obj = obj@MXtension.Collections.List(varargin{:});
            for i = 1:numel(collection)
                if ~ischar(obj.CellArray{i})
                    error('asdsa')
                end
            end
            
        end
        
        function acc = reduce(obj, fcn)
            acc = '';
            for i = 1:numel(obj.CellArray)
                acc = fcn(acc, obj.CellArray{i});
            end
        end
        
        function obj = sorted(obj)
            obj.CellArray = sort(obj.CellArray);
        end
        
    end
    
    
end