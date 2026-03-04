function [ke,fe] = bound(obj, fid, thePatch)

% Global node numbers
nids = obj.mesh.Faces(:,fid);

% Face owner
own = obj.mesh.Owners(fid);

% local quantities
xe = obj.mesh.Nodes(:,nids);
ue = obj.U.Internal(:,nids);

% init element matrices
fe = zeros(numel(nids), 1);
ke = zeros(numel(nids), numel(nids));

% tangent vector
tb = diff(xe');

% boundary length
lb = norm(tb);

% normalize tangent
tb = tb / lb;
tr = tb(thePatch.comp);

% relative velocity
ur = ue(thePatch.comp,:);

% modified friction factor
fac = thePatch.value * lb / pi * obj.FSTS(own) / sqrt(3);

% simpson rule
quad = obj.mesh.quadBnd;
for gid = quad.regular()
    % shape function values
    Nb = quad.val(gid);
    
    % radius
    r = xe(1,:) * Nb;

    % extended tangent
    Tb = Nb * tr;

    % sliding velocity
    vs = ur * Tb;

    % modified weight
    wda = fac * r * quad.weight(gid);

    % linearized friction
    switch obj.mode
        case 'NR'
            f = atan(vs / obj.vscl) * wda;
            df = obj.vscl / (obj.vscl^2 + vs^2) * wda;
        case 'DI'
            if abs(vs) / obj.vscl <= 1e-3
                df = 1 / obj.vscl * wda;
            else
                df = atan(vs / obj.vscl) / vs * wda;
            end
            f = df * vs;
    end

    % add contributions
    ke = ke + (Tb * Tb') * df;
    fe = fe - Tb * f;
end