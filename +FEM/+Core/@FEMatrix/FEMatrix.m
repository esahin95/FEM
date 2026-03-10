classdef FEMatrix < handle

    properties (Access=protected)
        % Mesh
        mesh
        
        % indices
        row
        col
    end

    properties
        % values
        K
    end
    
    methods
        function obj = FEMatrix(mesh, U)
            obj.mesh = mesh;
            nDim = U.nDim;

            % global equation numbers
            LM = repelem(nDim * mesh.Elements, nDim, 1);
            for d=1:nDim - 1
                LM(d:nDim:end,:) = LM(d:nDim:end,:) - (nDim - d);
            end
            [n, m] = size(LM);
            
            % triplet row and column indizes
            obj.row = kron(ones(n,1), LM); 
            obj.col = kron(LM, ones(n,1));
            
            % allocate storage for stiffness matrices
            obj.K = zeros(n^2, m);
        end

        function obj = subsasgn(obj, S, k)
            % assign element matrix
            obj.K(:,S.subs{1}) = k(:);
        end
        
        function M = sparse(obj, varargin)
            M = sparse(obj.row, obj.col, obj.K, varargin{:});
        end
    end
end