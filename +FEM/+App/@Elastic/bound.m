function fe = bound(obj, fid, value)

% global node numbers
nids = obj.msh.Edges(:,fid);

% coordinates
x = obj.msh.Nodes(:,nids);

% segment
ds = x(:,1) - x(:,2);

% element length
l = norm(ds);

% quadrature
fe = zeros(numel(nids) * obj.nDim, 1);
for gaussID = obj.mesh.quadBnd.regular()
    % integrand
    g = kron(obj.mesh.quadBnd.val(gaussID), value);

    % radius
    r = x(1,:) * obj.mesh.quadBnd.val(gaussID);

    % modified volume element
    wda = obj.mesh.quadBnd.weight(gaussID) * r * 0.5 * l;

    % accumulation
    fe = fe + wda * g;
end