function update(obj, U)

% Update mesh
obj.Nodes = obj.Nodes + U;

% Recompute mesh
obj.precompute()