%% Header
% Clear workspace
close all hidden
clc

% set interpreter to latex
set(0,'defaultTextInterpreter','latex','defaultAxesTickLabelInterpreter','latex','defaultLegendInterpreter','latex')

% run main
main()

%% Main Start
function main()

%% Problem setup

% Geometry
nex = 5;
ney = 5;
Lx = 1;
Ly = 1;

% Material
E = 30450;
nu = 0.3;

% Time
startTime = 0;
endTime = 1;
deltaT = 1;

% Numerics
maxit = 20;
tol = 1e-5;

% Process
du = -0.1;

% Post-processing
field = 'EPS';

% Matrix for assembly
Bfl = [1 0 0; 
       0 0 0; 
       0 0 1; 
       0 1 0; 
       0 0 0; 
       0 1 0; 
       0 0 0; 
       1 0 0];

%% Create quadrilateral mesh

% Grid coordinates
[X, Y] = meshgrid(linspace(0, Lx, 1+nex), linspace(0, Ly, 1+ney));
Nodes = [X(:) Y(:)]';
[nDim, nNodes] = size(Nodes);

% Implicit node numbering
IDs = reshape(1:nNodes, size(X));

% Element connectivity
Elements = reshape(IDs(1:end-1, 1:end-1), 1, []) + [0 1+ney 2+ney 1]';
[nLocal, nElems] = size(Elements);

% Boundary faces
Faces = sort([...
    IDs(1:end-1,1)' IDs(1:end-1,end)' IDs(end,1:end-1) IDs(1,1:end-1); ...
    IDs(2:end,1)'   IDs(2:end,end)'   IDs(end,2:end)   IDs(1,2:end) ...
]);

% Boundary edge owners
% Owners = [1:ney (nElems - ney + 1):nElems ney:ney:nElems 1:ney:(1 + nElems - ney)];

% Boundary patches
name = {'left', 'right', 'top', 'bottom'};
nFaces = {ney, ney, nex, nex};
startFace = {1, ney+1, 2*ney+1, 2*ney+nex+1};
fids = cell(1,numel(name));
for i = 1:numel(name)
    fids{i} = startFace{i}:(startFace{i} + nFaces{i} - 1);
end
Patches = struct('name', name, 'faces', fids);

% draw elements
figure('visible', 'on');
plt = patch( ...
    'Vertices', Nodes', ...
    'Faces', Elements', ...
    'FaceColor', 'flat', ...
    'CData', zeros(nElems, 1), ...
    'EdgeColor', 'k', ...
    'HandleVisibility', 'off' ...
);
axis equal
xlim([0 1.5])
ylim([0 1.2])
clim([0 0.5])
hold on

% draw patches
C = colororder;
bnd = cell(1, numel(Patches));
for pid = 1:numel(Patches)
    % Global node numbers
    fids = Patches(pid).faces;
    nids = Faces(:,fids);

    % Plot specification
    spec = cell(2, numel(fids));
    for fid = 1:numel(fids)
        coord = Nodes(:,nids(:,fid));
        spec{1,fid} = coord(1,:);
        spec{2,fid} = coord(2,:);
    end
    bnd{pid}.spec = spec;

    % Draw plots
    bnd{pid}.plt = plot(spec{:}, 'LineWidth', 2, 'Color', C(pid,:));
end
hold off

%% Quadrature rules

% Volume quadrature
quadVol = FEM.Quad.Quadrilateral();

% Boundary quadrature
% quadBnd = FEM.Quad.Simpson();

%% Precompute geometry

% Initialization
wdV = zeros(size(quadVol), nElems);
XYP = zeros(nLocal, nDim + 1, size(quadVol), nElems);
precompute()

%% Compute stiffness

% stiffness matrix
C = E/(1+nu)/(1-2*nu) * ...
    [1-nu   nu   nu 0; 
       nu 1-nu   nu 0; 
       nu   nu 1-nu 0; 
        0    0    0 0.5*(1-2*nu)];

%% Initialize solution

% Initialize
U = zeros(size(Nodes));
fDoF = ones(size(U), 'logical');

% Correct boundary conditions
for thePatch = Patches
    switch thePatch.name
        case 'top'
            % Face ids
            fids = thePatch.faces;

            % Node ids
            nids = Faces(:,fids);
            nids = unique(nids(:));

            % Set values
            U(2,nids) = du;

            % Set degrees of freedom
            fDoF(2,nids) = false;
    end
end
fDoF = fDoF(:);

% Solution fields
S.EPS = zeros(1,nElems);
S.SIG = zeros(1,nElems);


%% FE matrix setup

% global equation numbers
LM = repelem(nDim * Elements, nDim, 1);
for d=1:nDim - 1
    LM(d:nDim:end,:) = LM(d:nDim:end,:) - (nDim - d);
end
n = size(LM, 1);

% triplet row and column indizes
row = kron(ones(n,1), LM); 
col = kron(LM, ones(n,1));

% allocate storage for stiffness matrices
KE = zeros(n^2, nElems);

% % allocate space for global matrices
% K = sparse(row, col, KE);
% F = zeros(size(U(:)));

%% RUN

tic
t = startTime;
while t < endTime
    % Current time
    t = t + deltaT;
    
    % Update solution
    update()

    % Post processing
    plt.CData = S.(field);
    drawnow limitrate

    % Update mesh
    plt.Vertices = (Nodes + U)';
    for pid = 1:numel(Patches)
        % Global node numbers
        fids = Patches(pid).faces;
        nids = Faces(:,fids);
    
        % Plot specification
        for fid = 1:numel(fids)
            coord = Nodes(:,nids(:,fid)) + U(:,nids(:,fid));
            bnd{pid}.plt(fid).XData = coord(1,:);
            bnd{pid}.plt(fid).YData = coord(2,:);
        end
    end
    
    % Finish iteration
    fprintf("Finished iteration for time %.3f\n\n", t)
end
toc

%% Local functions
    function precompute()    
        % Iterate over elements
        for eid = 1:nElems
            % global node numbers
            nodes = Elements(:,eid);
        
            % node coordinates
            xe = Nodes(:,nodes);
            
            for gid = 1:size(quadVol)
                % jacobian
                J = xe * quadVol.grad(gid);
                detJ = det(J);
        
                % radius
                r = xe(1,:) * quadVol.val(gid);
        
                % transformed derivatives
                XYP(:,:,gid,eid) = [quadVol.grad(gid)/J quadVol.val(gid)/r];
        
                % modified volume element
                wdV(gid, eid) = quadVol.weight(gid) * r * detJ;
            end
        end
    end

    function update()
        % Iterate until convergence
        for it = 1:maxit
            % build linear system
            [K, F] = build();
        
            % solve linear system
            dU = zeros(size(U));
            dU(fDoF) = K \ F;
        
            % residuals
            enorm = norm(dU(:)) / norm(U(:));
            fnorm = norm(F);

            % update solution
            U = U + dU;
        
            % check termination criteria
            fprintf('it: %i, fnorm: %.5e, enorm: %.5e\n', it, fnorm, enorm)
            if enorm < tol && fnorm < tol
                break
            end
        end
    end

    function [K, F] = build()
        % initialize residual
        F = zeros(size(U));
        
        % elementwise assembly
        for eid = 1:nElems
            % global node numbers
            nids = Elements(:,eid);
        
            % local quantities
            ue = U(:,nids);
            
            % Initialize element matrices
            ne = numel(ue);
            fe = zeros(ne, 1);
            ke = zeros(ne, ne);
            
            % Build element matrices
            for gid = quadVol.regular()
                % geometry data
                B = reshape(Bfl * XYP(:,:,gid,eid)', 4, []);
                w = wdV(gid,eid);
                
                % strains
                eps = B * ue(:);
                
                % accumulate element force
                fe = fe - B' * (C * eps) * w;
                
                % accumulate element stiffness
                ke = ke + (B' * C * B) * w;
            end
            
            % Compute solution fields
            for gid = quadVol.reduced()
                % geometry data
                B = reshape(Bfl * XYP(:,:,gid,eid)', 4, []);
                
                % strains
                eps = B * ue(:);
            
                % stresses
                sig = C * eps;
            
                % post processing quantities
                obj.EPS(eid) = sqrt(eps' * (2/3*[1 1 1 0.5]' .* eps));
                obj.SIG(eid) = sqrt(sig' * (3/2*[1 1 1 2.0]' .* sig));
            end
        
            % global assembly
            KE(:,eid) = ke(:);
            F(:,nids) = F(:,nids) + reshape(fe, nDim, []);
        end
        
        % reduce to sparse matrix
        K = sparse(row, col, KE);
        
        % symmetrize
        K = 0.5 * (K' + K);
        
        % Constrain fixed degrees of freedom
        F = F(fDoF);
        K = K(fDoF,fDoF);
    end

%% Main End
end