function list = emptyList()
% list: MXtension.Collections.List = emptyList() : Returns an empty read-only list.
list = MXtension.Collections.ImmutableList.ofElements();
end
