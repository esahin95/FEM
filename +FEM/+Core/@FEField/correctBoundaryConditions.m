function correctBoundaryConditions(obj)

fDoF = ones(size(obj.Internal), 'logical');
for thePatch = obj.mesh.Patches
    % Boundary condition data
    data = obj.Boundary.(thePatch.name);

    % Boundary nodes
    fids = thePatch.startFace:(thePatch.startFace + thePatch.nFaces - 1);
    nodes = obj.mesh.Faces(:,fids);
    nodes = unique(nodes(:));
    
    % Correct boundary conditions for components
    for i = 1:numel(data)
        switch data(i).type
            case 'fixedValue'
                % Set fixed value
                obj.Internal(i,nodes) = data(i).value;

                % Constrain degrees of freedom
                fDoF(i,nodes) = false;
            
            case 'zeroGradient'
                continue

            case 'constantFriction'
                continue
                
            otherwise
                error('unknown patch type')
        end
    end
end
obj.fDoF = fDoF(:);