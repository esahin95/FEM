function update(obj, U)

% Superclass update
update@FEM.Geom.FEMesh(obj, U)

% update patches
obj.plt.Vertices = obj.Nodes';

% update boundary edges
for patchID = 1:numel(obj.Patches)
    thePatch = obj.Patches(patchID);

    faces = thePatch.startFace:(thePatch.startFace + thePatch.nFaces - 1);

    nodes = [obj.Faces(1,faces) obj.Faces(2,faces(end))];

    coord = obj.Nodes(:, nodes);

    obj.bnd{patchID}.XData = coord(1,:);
    obj.bnd{patchID}.YData = coord(2,:);
end