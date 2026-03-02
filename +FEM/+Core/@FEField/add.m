function add(obj, U)

sz = size(U);

if all(size(U) == size(obj.Internal))
    obj.Internal = obj.Internal + U;
elseif all(size(U) == [sum(obj.fDoF) 1])
    obj.Internal(obj.fDoF) = obj.Internal(obj.fDoF) + U;
else
    error('Incompatible size for FEField')
end