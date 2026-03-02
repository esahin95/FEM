classdef FEMatrix < handle

    properties
        % indices
        row
        col

        % values
        K
    end
    
    methods
        function obj = FEMatrix(T, nDims)
            % global equation numbers
            LM = repelem(nDims * T, nDims, 1);
            for d=1:nDims - 1
                LM(d:nDims:end,:) = LM(d:nDims:end,:) - (nDims - d);
            end
            nle = nDims * size(T, 1);
            
            % triplet row and column indizes
            obj.row = kron(ones(nle,1), LM); 
            obj.col = kron(LM, ones(nle,1));
            
            % allocate storage for stiffness matrices
            obj.K = zeros(nle ^ 2, size(T, 2));
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