classdef (Abstract) List < MXtension.Collections.Collection
    % Typeless list interface.
    
    methods(Abstract)
        
        
        item = get(obj, index)
        
        
        % TODO: sortWith, sortBy
        
        
        % foldRightIndexed
        % foldIndexed
        
    end
    
    methods
        
        
        % Override
        function index = indexOfLast(obj, predicate)
            for index = obj.count():-1:1
                if predicate(obj.get(index))
                    return
                end
            end
            
            index = -1;
        end
        
        
        % Override
        function index = lastIndexOf(obj, element)
            % index: double = list.lastIndexOf(elem: Any): Returns the index of the last occurrence of the specified element in the list, or -1 if the specified element is not contained in the list.
            
            for index = obj.size():-1:1
                cElem = obj.get(index);
                if isequal(cElem, element)
                    return
                end
            end
            
            index = -1;
        end
        
        
        function result = zip(obj, otherList, varargin)
            MXtensionList = obj.fromCollection(otherList);
            outSize = min(obj.size(), MXtensionList.size());
            if nargin < 3
                transform = @(it, other) MXtension.Collections.Pair(it, other);
            else
                transform = varargin{1};
            end
            
            result = obj.take(outSize).mapIndexed(@(it, ind) transform(it, MXtensionList.get(ind)));
        end
    end
    
end