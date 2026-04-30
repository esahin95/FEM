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

% Patchwise assembly
for thePatch = [obj.U.Boundary{:}]
    [Kb, Fb] = obj.(thePatch.type)(thePatch);

    % Add contributions
    if ~isempty(Kb), K = K + Kb; end
    if ~isempty(Fb), F = F + Fb; end
end

% Constrain fixed degrees of freedom
[K, F] = obj.U.reduce(K, F);

% symmetrize
K = 0.5 * (K' + K); 