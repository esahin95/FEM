classdef Base < handle
    properties
        % Options
        opt
        
        % Mesh
        mesh

        % Material
        mat

        % Global matrices
        M
        Mb

        % Global solution
        U

        % Field name for post-processing
        fieldName

        % precomputed geometric data
        wdV
        XYP
    end
    
    methods
        function obj = Base(options)
            % Save options
            obj.opt = options;
            
            % Create mesh
            geometry = options.geometry;
            obj.mesh = FEM.Geom.(geometry.type)(geometry);

            % Create material
            material = options.material;
            obj.mat = FEM.Core.Materials.(material.type)(material);

            % Initialize global solution
            solution = options.solution;
            obj.U = FEM.Core.FEField(obj.mesh, solution);

            % Initialize global FE matrix
            obj.M  = FEM.Core.FEMatrix(obj.mesh.Elements, solution.nDims);
            obj.Mb = FEM.Core.FEMatrix(obj.mesh.Faces, solution.nDims);

            % Select post-processing element array
            obj.fieldName = solution.post;
        end

        run(obj)

        B = strmtx(gid, eid)
    end

    methods (Abstract)
        update(obj)
    end
end