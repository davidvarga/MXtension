classdef ArrayListReverseIterator < MXtension.Collections.Iterator
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Access = private)
        ArrayListRef = [];
        Index;
        
    end
    
    methods
        function obj = ArrayListReverseIterator(arrayList)
            % TODO: throw error if class is worng
            obj.ArrayListRef = arrayList;
            obj.Index = obj.ArrayListRef.size() + 1;
        end
        
        
        function hasNext = hasNext(obj)
            try
                obj.ArrayListRef.get(obj.Index-1);
                hasNext = true;
            catch
                hasNext = false;
                
            end
        end
        function nextElement = next(obj)
            try
                nextElement = obj.ArrayListRef.get(obj.Index-1);
                obj.Index = obj.Index - 1;
                
            catch
                % TODO: throw NoSuchElementException
                error('NoSuchElementException')
            end
        end
        
        function obj = remove(obj)
            try
                obj.ArrayListRef.removeAt(obj.Index);
                obj.Index = obj.Index;
            catch
                % TODO: throw NoSuchElementException
                error('IllegalState')
            end
        end
    end
    
    
end
