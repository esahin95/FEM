function update(obj, U)

% Superclass update
update@FEM.Geom.FEMesh(obj, U)

% update patches
obj.plt.Vertices = obj.Nodes';

% update boundary edges
for pid = 1:numel(obj.Patches)
    % Global node numbers
    fids = obj.Patches(pid).faces;
    nids = obj.Faces(:,fids);

    % Plot specification
    for fid = 1:numel(fids)
        coord = obj.Nodes(:,nids(:,fid));
        obj.bnd{pid}.plt(fid).XData = coord(1,:);
        obj.bnd{pid}.plt(fid).YData = coord(2,:);
    end
end