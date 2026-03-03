function [K, F] = build(obj)

% initialize residual
F = zeros(size(obj.U));

% elementwise assembly
for eid = 1:obj.mesh.nElems
    % global node numbers
    nids = obj.mesh.Elements(:,eid);

    % local assembly
    [ke, fe] = obj.local(eid);

    % global assembly
    obj.M(eid) = ke;
    F(:,nids) = F(:,nids) + reshape(fe, size(F, 1), []);
end

% reduce to sparse matrix
K = sparse(obj.M);

% % Boundary contributions
% for thePatch = obj.mesh.Patches
%     % Boundary condition data
%     data = obj.U.Boundary.(thePatch.name);
% 
%     % Iterate over components
%     for i = 1:numel(data)
%         switch data(i).type
%             case 'constantFriction'
%                 value = data(i).value;
% 
%                 % Face wise assembly
%                 fids = thePatch.startFace:(thePatch.startFace + thePatch.nFaces - 1);
%                 for fid = fids
%                     % global node numbers
%                     nids = obj.mesh.Faces(:,fid);
% 
%                     % local assembly
%                     [keb, feb] = obj.bound(fid, value);
% 
%                     % global assembly
%                     obj.Mb(fid) = keb;
%                     F(i,nids) = F(i,nids) + reshape(feb, 1, []);
%                 end
% 
%             case 'zeroGradient'
%                 continue
% 
%             case 'fixedValue'
%                 continue
% 
%             otherwise
%                 error('Unknown boundary patch type for %s, %d', thePatch.name, i)
%         end
%     end
% end

% reduce to sparse matrix
Kb = sparse(obj.Mb);

% add contributions
K = K + Kb;

% symmetrize
K = 0.5 * (K' + K); 

% Constrain fixed degrees of freedom
[K, F] = obj.U.reduce(K, F);