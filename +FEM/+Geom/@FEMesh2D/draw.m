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

% draw patches
C = colororder;
obj.bnd = cell(1, numel(obj.Patches));
for pid = 1:numel(obj.Patches)
    % Global node numbers
    fids = obj.Patches(pid).faces;
    nids = obj.Faces(:,fids);

    % Plot specification
    spec = cell(2, numel(fids));
    for fid = 1:numel(fids)
        coord = obj.Nodes(:,nids(:,fid));
        spec{1,fid} = coord(1,:);
        spec{2,fid} = coord(2,:);
    end
    obj.bnd{pid}.spec = spec;

    % Draw plots
    obj.bnd{pid}.plt = plot(spec{:}, 'LineWidth', 2, 'Color', C(pid,:));
end
hold off