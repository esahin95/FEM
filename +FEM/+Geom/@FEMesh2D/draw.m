function draw(obj)

% draw elements
obj.fig = figure('visible', 'off');
obj.plt = patch( ...
    'Vertices', obj.Nodes', ...
    'Faces', obj.Elements', ...
    'FaceColor', 'flat', ...
    'CData', zeros(obj.nElems, 1), ...
    'EdgeColor', 'k', ...
    'HandleVisibility', 'off' ...
);
axis equal
hold on
xlim([0 max(obj.Nodes(1,:)) * 1.5])
ylim([0 max(obj.Nodes(2,:)) * 1.2])

% draw patches
C = colororder;
obj.bnd = cell(1, numel(obj.Patches));
for patchID = 1:numel(obj.Patches)
    thePatch = obj.Patches(patchID);
    faces = thePatch.startFace:(thePatch.startFace + thePatch.nFaces - 1);
    nodes = [obj.Faces(1,faces) obj.Faces(2,faces(end))];
    coord = obj.Nodes(:, nodes);
    obj.bnd{patchID} = plot(coord(1,:), coord(2,:), 'LineWidth', 2, 'Color', C(patchID,:));
end
legend(obj.Patches.name)