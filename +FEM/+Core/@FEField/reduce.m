function [Kh, Fh] = reduce(obj, K, F)

Fh = F(obj.fDoF);
Kh = K(obj.fDoF, obj.fDoF);