function [ke, fe] = local(obj, eid)

% global node numbers
nids = obj.mesh.Elements(:,eid);

% local quantities
ue = obj.U.Internal(:,nids);

% init element matrices
fe = zeros(numel(ue), 1);
ke = zeros(numel(ue), numel(ue));

I = [1 1 1 0];
D = 2/3 * [1 1 1 0.5]';
for gid = obj.mesh.quadVol.regular()
    % geometry data
    [B, wdV] = obj.comp(gid, eid);

    % eliminate dilatational component
    B(1:3,:) = B(1:3,:) - I * B / 3;

    % strain rate matrix 
    Q = B' * (D .* B);
    Qv = Q * ue(:);
    
    % plastic strain rate
    psr = B * ue(:);
    
    % effective plastic strain rate squared
    epsr2 = psr' * (D .* psr);

    % bounded effective strain rate
    bepsr = max(sqrt(epsr2), obj.alph);

    % flow stress factor
    fsts = obj.mat.flowStress(obj.TEPS(eid), bepsr);
    fac1 = fsts / bepsr;

    % stress rate factor
    stsr = obj.mat.stressRate(obj.TEPS(eid), bepsr);
    if epsr2 <= obj.alph^2 || all(obj.mode == 'DI')
        fac2 = 0;
    else
        fac2 = (stsr - fac1) / epsr2;
    end

    % accumulate element matrices
    ke = ke + (fac1 * Q + fac2 * (Qv * Qv')) * wdV;
    fe = fe - fac1 * Qv * wdV;
end

for gid = obj.mesh.quadVol.reduced()
    % geometry data
    [B, wdV] = obj.comp(gid, eid);
    
    % strains
    psr = B * ue(:);

    % effective plastic strain rate squared
    epsr2 = psr' * (D .* psr);

    % volumetric strain rate
    C = I * B;
    xvol = C * ue(:);

    % accumulate element matrices
    ke = ke + obj.diat * (C' * C) * wdV;
    fe = fe - obj.diat * C' * xvol * wdV;
    
    % save strain rates
    obj.EPSR(eid) = sqrt(epsr2);
    obj.XVOL(eid) = xvol;

    % save flow stress 
    obj.FSTS(eid) = obj.mat.flowStress(obj.TEPS(eid), obj.EPSR(eid));
end