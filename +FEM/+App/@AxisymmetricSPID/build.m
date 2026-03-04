function [K, F] = build(obj)

% initialize residual
F = zeros(size(obj.U));

% elementwise assembly
for eid = 1:obj.mesh.nElems
    % global node numbers
    nids = obj.mesh.Elements(:,eid);

    % local assembly
    [ke, fe] = obj.local(eid);

    % global assembly
    obj.M(eid) = ke;
    F(:,nids) = F(:,nids) + reshape(fe, size(F, 1), []);
end

% reduce to sparse matrix
K = sparse(obj.M);
% [n, m] = size(K);

% reduce to sparse matrix
% Kb = sparse(obj.Mb, n, m);

% add contributions
% K = K + Kb;

% symmetrize
K = 0.5 * (K' + K); 

% Constrain fixed degrees of freedom
[K, F] = obj.U.reduce(K, F);