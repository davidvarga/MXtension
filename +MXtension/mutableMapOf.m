function map = mutableMapOf(varargin)
% varargin: Pair or Entry
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

map = MXtension.Collections.HashMap.ofEntries(varargin{:});
end
