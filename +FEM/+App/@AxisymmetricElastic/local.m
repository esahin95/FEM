function [ke, fe] = local(obj, eid)

% global node numbers
nids = obj.mesh.Elements(:,eid);

% local quantities
ue = obj.U.Internal(:,nids);

% Initialize element matrices
fe = zeros(numel(ue), 1);
ke = zeros(numel(ue), numel(ue));

% Quadrature rule
quad = obj.mesh.quadVol;

for gid = quad.regular()
    % geometry data
    [B, wdV] = obj.comp(gid, eid);
    
    % strains
    eps = B * ue(:);
    
    % accumulate element force
    fe = fe - B' * obj.mat.stress(eps) * wdV;
    
    % accumulate element stiffness
    ke = ke + B' * obj.mat.stiff(eps) * B * wdV;
end

for gid = quad.reduced()
    % geometry data
    [B, ~] = obj.comp(gid, eid);
    
    % strains
    eps = B * ue(:);

    % stresses
    sig = obj.mat.stress(eps);

    % post processing quantities
    obj.EPS(eid) = sqrt(eps' * (2/3*[1 1 1 0.5]' .* eps));
    obj.SIG(eid) = sqrt(sig' * (3/2*[1 1 1 2.0]' .* sig));
end