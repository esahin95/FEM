function read(obj, data)

% Internal field
u = reshape(str2double(strsplit(data.internal.values, ' ')), [], 1);
obj.Internal = repmat(u, 1, obj.mesh.nNodes);

% Initialize free degrees of freedom
obj.fDoF = zeros(numel(obj.Internal), 1, 'logical');

% Boundary field
obj.Boundary = struct();
for patch = obj.mesh.Patches    
    % Extract types and values
    boundaryCondition = data.(patch.name);
    types = strsplit(boundaryCondition.types, ' ');
    values = num2cell(str2double(strsplit(boundaryCondition.values, ' ')));
    
    % Create patch
    obj.Boundary.(patch.name) = struct('type', types, 'value', values);
end
obj.correctBoundaryConditions()