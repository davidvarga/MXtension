function list = emptyList(varargin)
if nargin
    list = MXtension.Collections.ImmutableList.ofSize(varargin{1});
else
    list = MXtension.Collections.ImmutableList.ofElements();
end
end
