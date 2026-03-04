function read(obj, data)

% Internal field
u = reshape(str2double(strsplit(data.internal.values, ' ')), [], 1);
obj.Internal = repmat(u, 1, obj.mesh.nNodes);

% Initialize free degrees of freedom
obj.fDoF = ones(numel(obj.Internal), 1, 'logical');

% Number of patches
nDim = obj.nDim;
nPatch = obj.mesh.nPatch;

% Read boundary conditions
cond = struct('type', cell(nDim, nPatch), 'value', cell(nDim, nPatch));
for pid = 1:nPatch
    % Patch name
    name = obj.mesh.Patches(pid).name;
    
    % Patch boundary condition data
    bc = data.(name);
    types = strsplit(bc.types, ' ');
    values = str2double(strsplit(bc.values, ' '));

    % Add to structure
    for comp = 1:nDim
        cond(comp, pid).type = types{comp};
        cond(comp, pid).value = values(comp);
    end
end

% Boundary field
obj.Boundary = cell(nDim, obj.mesh.nPatch);
for pid = 1:nPatch 
    for comp = 1:nDim
        % Boundary data
        bc = cond(comp, pid);

        % Generate patch
        obj.Boundary{comp, pid} = FEM.Core.FEPatch(obj.mesh, bc, pid, nDim, comp);
    end
end
obj.correct()