function [Kh, Fh] = reduce(obj, K, F)

Fh = reshape(F(obj.fDoF), [], 1);
Kh = K(obj.fDoF, obj.fDoF);