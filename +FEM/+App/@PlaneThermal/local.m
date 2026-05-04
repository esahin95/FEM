function [ke, fe] = local(obj, eid)

c1 = 1;
c2 = 1;
r = @(t) c1*exp(-c2*t);

% global node numbers
nids = obj.mesh.Elements(:,eid);

% local quantities
ue = obj.U.Internal(:,nids);
ue0 = obj.oldU.Internal(:,nids);

% Initialize element matrices
fe = zeros(numel(ue), 1);
ke = zeros(numel(ue), numel(ue));

% Quadrature rule
quad = obj.mesh.quadVol;

for gid = quad.regular()
    % geometry data
    N  = quad.val(gid);
    DN = obj.XYP(:,1:end-1,gid, eid);
    wdV = obj.wdV(gid, eid);
    
    % reciprocal time step size
    rDt = 1 / obj.deltaT;

    % accumulate element force
    fe = fe + (N * N') * (rDt * ue0(:) + r(obj.time)) * wdV;
    
    % accumulate element stiffness
    ke = ke + (rDt * (N * N') + obj.mat.alpha * (DN * DN')) * wdV;
end

% for gid = quad.reduced()
%     % post processing quantities
%     obj.T(eid) = ue * quad.val(gid);
% end