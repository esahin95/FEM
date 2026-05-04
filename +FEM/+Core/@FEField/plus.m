function obj = plus(obj, U)

if all(size(U) == size(obj.Internal))
    obj.Internal = obj.Internal + U;

elseif all(size(U) == [sum(obj.fDoF) 1])
    sz = size(obj.Internal(obj.fDoF));
    obj.Internal(obj.fDoF) = obj.Internal(obj.fDoF) + reshape(U, sz);
    
else

    error('Incompatible size for FEField')
end