function [K, F] = fixedGradient(obj, thePatch)

K = [];
F = zeros(size(obj.U));

% Face wise assembly
for i = 1:thePatch.nFaces
    % global node numbers
    nids = thePatch.Faces(:,i);

    % local assembly ---------------------------

    % coordinates
    xe = obj.mesh.Nodes(:,nids);
    
    % element length
    l = norm(xe(:,1) - xe(:,2));
    
    % init element matrices
    fe = zeros(numel(nids), 1);
    
    % quadrature
    quad = obj.mesh.quadBnd;
    for gid = quad.regular()
        % integrand
        g = quad.val(gid) * thePatch.value;
    
        % radius
        r = xe(1,:) * quad.val(gid);
    
        % modified volume element
        wda = quad.weight(gid) * r * 0.5 * l;
    
        % accumulation
        fe = fe + wda * g;
    end

    % ------------------------------------------

    % global assembly
    F(thePatch.comp, nids) = F(thePatch.comp, nids) + fe';
end