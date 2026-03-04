classdef FEPatch < handle
    properties (Dependent)
        Nodes
        Faces
    end

    properties (Access=protected)
        % indices
        row
        col

        % Mesh
        mesh
    end
    
    properties (SetAccess=protected)
        % Global numbering
        nids
        fids
        comp
        dofs

        % Data
        type
        value
    end

    properties
        % values
        K
    end

    methods
        function obj = FEPatch(mesh, data, pid, nDim, comp)
            % Reference
            obj.mesh = mesh;
            
            % Data
            obj.comp = comp;
            obj.type = data.type;
            obj.value = data.value; 

            % Global face numbers for patch
            obj.fids = mesh.Patches(pid).faces;
            
            % Global node numbers for patch
            obj.nids = unique(obj.Faces(:));

            % global equation numbers
            LM = nDim * obj.Faces - (nDim - comp);
            [n, m] = size(LM);

            % degrees of freedom
            obj.dofs = unique(LM(:));

            % triplet row and column indizes
            obj.row = kron(ones(n,1), LM); 
            obj.col = kron(LM, ones(n,1));

            % allocate storage for stiffness matrices
            obj.K = zeros(n^2, m);
        end

        function N = get.Nodes(obj)
            N = obj.mesh.Nodes(:, obj.nids); 
        end

        function E = get.Faces(obj)
            E = obj.mesh.Faces(:, obj.fids); 
        end

        function M = sparse_like(obj, K)
            [n,m] = size(K);
            M = sparse(obj.row, obj.col, obj.K, n, m);
        end
    end
end