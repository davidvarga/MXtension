function list = emptyList(varargin)
    if nargin
        list = MXtension.Collections.List.ofSize(varargin{1});
    else
        list = MXtension.Collections.List.ofElements();
    end 
end

