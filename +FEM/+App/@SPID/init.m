function init(obj)

% temporary
%obj.U.add(-[0.5; 1] .* obj.mesh.Nodes - obj.U.Internal)
% obj.U.Internal = [0.5; 1] .* obj.mesh.Nodes;

% refine solution
obj.mode = 'DI';
obj.update();

% switch back to NR
obj.mode = 'NR';