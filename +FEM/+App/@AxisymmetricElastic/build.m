function [K, F] = build(obj)

% initialize residual
F = zeros(size(obj.U));

% elementwise assembly
for eid = 1:obj.mesh.nElems
    % global node numbers
    dofs = obj.mesh.Elements(:,eid);

    % local assembly
    [ke, fe] = obj.local(eid);

    % global assembly
    obj.M(eid) = ke;
    F(:,dofs) = F(:,dofs) + reshape(fe, size(F, 1), []);
end

% reduce to sparse matrix
K = sparse(obj.M);

% symmetrize
K = 0.5 * (K' + K);

% Boundary contributions
for thePatch = [obj.U.Boundary{:}]
    switch thePatch.type
        case 'fixedGradient'
            value = thePatch.value;

            % Face wise assembly
            for fid = thePatch.fids
                % global node numbers
                dofs = thePatch.dofs;
    
                % local assembly
                fe = obj.bound(fid, value);
    
                % global assembly
                F(dofs) = F(dofs) + reshape(fe, 1, []);
            end

        case 'zeroGradient'
            continue

        case 'fixedValue'
            continue

        otherwise
            error('Unknown boundary patch type for %s, %d', thePatch.name)
    end
end

% Constrain fixed degrees of freedom
F = F(obj.U.fDoF);
K = K(obj.U.fDoF,obj.U.fDoF);