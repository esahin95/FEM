function init(obj, options)
% read in constants
nex = options.nex;
ney = options.ney;
Lx  = options.Lx;
Ly  = options.Ly;


% grid coordinates
[X, Y] = meshgrid(linspace(0, Lx, 1+nex), linspace(0, Ly, 1+ney));
obj.Nodes = [X(:) Y(:)]';

% implicit node numbering
IDs = reshape(1:obj.nNodes, size(X));

% element connectivity
obj.Elements = reshape(IDs(1:end-1, 1:end-1), 1, []) + [0 1+ney 2+ney 1]';

% boundary edges
obj.Faces = sort([...
    IDs(1:end-1,1)' IDs(1:end-1,end)' IDs(end,1:end-1) IDs(1,1:end-1); ...
    IDs(2:end,1)'   IDs(2:end,end)'   IDs(end,2:end)   IDs(1,2:end) ...
]);

% boundary edge owners
obj.Owners = [...
    1:ney ...
    (obj.nElems - ney + 1):obj.nElems ...
    ney:ney:obj.nElems ...
    1:ney:(1 + obj.nElems - ney)...
];

% boundary patches
name = {'left', 'right', 'top', 'bottom'};
nFaces = {ney, ney, nex, nex};
startFace = {1, ney+1, 2*ney+1, 2*ney+nex+1};
obj.Patches = struct('name', name, 'nFaces', nFaces, 'startFace', startFace);