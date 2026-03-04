function init(obj, options)
% Read in constants
nex = options.nex;
ney = options.ney;
Lx  = options.Lx;
Ly  = options.Ly;


% Grid coordinates
[X, Y] = meshgrid(linspace(0, Lx, 1+nex), linspace(0, Ly, 1+ney));
obj.Nodes = [X(:) Y(:)]';

% Implicit node numbering
IDs = reshape(1:obj.nNodes, size(X));

% Element connectivity
obj.Elements = reshape(IDs(1:end-1, 1:end-1), 1, []) + [0 1+ney 2+ney 1]';

% Boundary faces
obj.Faces = sort([...
    IDs(1:end-1,1)' IDs(1:end-1,end)' IDs(end,1:end-1) IDs(1,1:end-1); ...
    IDs(2:end,1)'   IDs(2:end,end)'   IDs(end,2:end)   IDs(1,2:end) ...
]);

% Boundary edge owners
obj.Owners = [...
    1:ney ...
    (obj.nElems - ney + 1):obj.nElems ...
    ney:ney:obj.nElems ...
    1:ney:(1 + obj.nElems - ney)...
];

% Boundary patches
name = {'left', 'right', 'top', 'bottom'};
nFaces = {ney, ney, nex, nex};
startFace = {1, ney+1, 2*ney+1, 2*ney+nex+1};
fids = cell(1,numel(name));
for i = 1:numel(name)
    fids{i} = startFace{i}:(startFace{i} + nFaces{i} - 1);
end
obj.Patches = struct('name', name, 'faces', fids);