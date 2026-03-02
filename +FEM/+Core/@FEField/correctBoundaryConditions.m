function correctBoundaryConditions(obj)

for patch = obj.mesh.Patches
    % Boundary condition data
    data = obj.Boundary.(patch.name);

    % Boundary nodes
    faces = patch.startFace:(patch.startFace + patch.nFaces - 1);
    nodes = obj.mesh.Faces(:, faces);
    
    % Correct boundary conditions for components
    fDoF = reshape(obj.fDoF, size(obj.Internal));
    for i = 1:numel(data)
        switch data(i).type
            case 'fixedValue'
                % Set fixed value
                obj.Internal(i,nodes) = data(i).value;

                % Constrain degrees of freedom
                fDoF(i,nodes) = false;
            case 'zeroGradient'
                % Unconstrain degrees of freedom
                fDoF(i,nodes) = true;
            otherwise
                error('unknown patch type')
        end
    end
    obj.fDoF = fDoF(:);
end