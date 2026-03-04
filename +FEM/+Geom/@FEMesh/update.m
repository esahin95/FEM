function update(obj, U, mode)
arguments
    obj,
    U,
    mode (1,:) char = 'increment'
end

% Update mesh
switch mode
    case 'increment'
        obj.Nodes = obj.Nodes + U;

    case 'total'
        obj.Nodes = U;

    otherwise
        error('Unknown mode for node update')
end