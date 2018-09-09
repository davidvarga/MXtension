classdef DoubleList < MXtension.Collections.List
    
    properties
  
    end
    
    methods
        function obj = DoubleList(varargin)
           obj = obj@MXtension.Collections.List(varargin{:}); 
            for i = 1:numel(obj.CellArray)
                if ~isa(obj.CellArray{i}, 'double')
                   error('asdsa') 
                end
            end
        end
        
        function acc = reduce(obj, fcn)
            acc = obj.fold(0, fcn);
        end
        
        function result = sum(obj)
            result = obj.reduce(@(acc, elem) acc + elem);
        end
        
        function obj = sorted(obj)
            temp = [];
            for i = 1:numel(obj.CellArray)
                temp(end+1) = obj.CellArray{i};
            end
            temp = sort(temp);
            temp2 = {};
            for i = 1:numel(temp)
                temp2{end+1} = temp(i);
            end
           obj.CellArray = temp2; 
        end
        
        function cellArray = toCellArray(obj)
            cellArray = obj.CellArray;
        end
        
    end
    
    
end