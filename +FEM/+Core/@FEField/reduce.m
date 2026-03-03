function [Kh, Fh] = reduce(obj, K, F)

% Reduce constrained degrees of freedom
Fh = F(obj.fDoF);
Kh = K(obj.fDoF, obj.fDoF);