function [K, F] = build(obj)

% Initialize residual
F = zeros(size(obj.U));

% elementwise assembly
for elemID = 1:obj.mesh.nElems
    % global node numbers
    e = obj.mesh.Elements(:,elemID);

    % local assembly
    [ke, fe] = obj.local(elemID);

    % global assembly
    obj.M(elemID) = ke;
    F(:,e) = F(:,e) + reshape(fe, obj.nDim, []);
end

% reduce to sparse matrix
K = sparse(obj.M);

% symmetrize
K = 0.5 * (K' + K);

% correct for neumann boundary conditions
for patch = obj.mesh.Patches
    data = obj.U.Boundary.(patch.name);

    % check for neumann boundary
    for i = 1:numel(data)
        switch data(i).type
            case 'fixedGradient'
                % Faces for patch
                faces = patch.startFace:(patch.startFace + patch.nFaces - 1);

                for faceID = faces
                    % global node numbers
                    nodes = obj.mesh.Faces(:,faceID);
        
                    % local assembly
                    fe = obj.neumann(faceID, data(i).value);
        
                    % global assembly
                    F(i,nodes) = F(i,nodes) + reshape(fe, 1, []);
                end
            otherwise
                continue
        end
    end
end

% Constrain degrees of freedom
F = F(obj.U.fDoF);
K = K(obj.U.fDoF, obj.U.fDoF);