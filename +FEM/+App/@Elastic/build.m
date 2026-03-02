function [K, F] = build(obj)

% initialize residual
F = zeros(size(obj.U));

% elementwise assembly
for elemID = 1:obj.mesh.nElems
    % global node numbers
    nodes = obj.mesh.Elements(:,elemID);

    % local assembly
    [ke, fe] = obj.local(elemID);

    % global assembly
    obj.M(elemID) = ke;
    F(:,nodes) = F(:,nodes) + reshape(fe, size(F, 1), []);
end
%obj.M.K

% reduce to sparse matrix
K = sparse(obj.M);

% symmetrize
K = 0.5 * (K' + K);

% correct for neumann boundary conditions
for patch = obj.mesh.Patches
    data = obj.U.Boundary.(patch.name);

    for i = 1:numel(data)
        switch data(i).type
            case 'fixedGradient'
                value = data(i).value;

                % Face wise assembly
                faces = patch.startFace:(patch.startFace + patch.nFaces - 1);
                for faceID = faces
                    % global node numbers
                    nodes = obj.mesh.Faces(:,faceID);
        
                    % local assembly
                    fe = obj.neumann(faceID, value);
        
                    % global assembly
                    F(i,nodes) = F(i,nodes) + reshape(fe, 1, []);
                end
        end
    end
end

% Constrain fixed degrees of freedom
F = F(obj.U.fDoF);
K = K(obj.U.fDoF,obj.U.fDoF);

%full(K(1:4,1:4))