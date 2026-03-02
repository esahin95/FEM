classdef FEProblem < handle
    properties
        % Options
        opt
        
        % Mesh
        mesh

        % Global matrices
        M
        Mb

        % Global solution
        U
    end

    properties(Abstract)
        % Field name for post-processing
        fieldName
    end
    
    methods
        function obj = FEProblem(options)
            % Save options
            obj.opt = options;
            
            % Create mesh
            subOptions = options.geometry;
            obj.mesh = FEM.Geom.(subOptions.type)(subOptions);

            % Initialize global solution
            subOptions = options.solution;
            obj.U = FEM.Core.FEField(obj.mesh, subOptions);

            % Initialize global FE matrix
            obj.M  = FEM.Core.FEMatrix(obj.mesh.Elements, subOptions.nDims);
            obj.Mb = FEM.Core.FEMatrix(obj.mesh.Faces, subOptions.nDims);

            % Select post-processing element array
            obj.fieldName = subOptions.post;
        end

        run(obj)
    end

    methods (Abstract)
        
    end
end