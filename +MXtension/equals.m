function equals = equals(a, b)

if isnumeric(a) && ~isnumeric(b) || ~isnumeric(a) && isnumeric(b)
    equals = false;
    return;
end

if isa(a, 'handle') && isa(b, 'handle')
    equals = a == b;
    return;
end

equals = isequal(a, b);
end
