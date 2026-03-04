function precompute(obj)

% References
mesh = obj.mesh;
quad = mesh.quadVol;

% Iterate over elements
for eid = 1:mesh.nElems
    % global node numbers
    nodes = mesh.Elements(:,eid);

    % node coordinates
    xe = mesh.Nodes(:,nodes);
    
    for gid = 1:size(quad)
        % jacobian
        J = xe * quad.grad(gid);
        detJ = det(J);

        % radius
        r = xe(1,:) * quad.val(gid);

        % transformed derivatives
        obj.XYP(:,:,gid,eid) = [quad.grad(gid)/J quad.val(gid)/r];

        % modified volume element
        obj.wdV(gid, eid) = quad.weight(gid) * r * detJ;
    end
end