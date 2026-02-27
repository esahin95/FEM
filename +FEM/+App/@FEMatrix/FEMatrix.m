classdef FEMatrix < handle

    properties
        % indices
        row
        col

        % values
        K
    end
    
    methods
        function obj = FEMatrix(mesh, options)
            % global equation numbers
            nDim = options.nDim;
            LM = repelem(nDim * mesh.Elements, nDim, 1);
            for d=1:nDim - 1
                LM(d:nDim:end,:) = LM(d:nDim:end,:) - (nDim - d);
            end
            nle = nDim * mesh.nLocal;
            
            % triplet row and column indizes
            obj.row = kron(ones(nle,1), LM); 
            obj.col = kron(LM, ones(nle,1));
            
            % allocate storage for stiffness matrices
            obj.K = zeros(nle ^ 2, mesh.nElems);
        end

        function obj = subsasgn(obj, S, k)
            % assign element matrix
            obj.K(:,S.subs{1}) = k(:);
        end
        
        function M = sparse(obj)
            M = sparse(obj.row, obj.col, obj.K);
        end
    end
end