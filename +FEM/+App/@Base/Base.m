classdef Base < handle
    properties (SetAccess=protected)        
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
        field

        % solver parameters
        solver
        mode
    end

    properties (Access=private)
        startTime
        endTime
        deltaT
    end
    
    methods
        function obj = Base(options)
            % Process options 
            runTime = options.runTime;
            obj.startTime = runTime.startTime;
            obj.endTime = runTime.endTime;
            obj.deltaT = runTime.deltaT;
            
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
            obj.field = solution.field;

            % solver parameters
            obj.solver = dictionary;
            obj.solver('DI') = struct('maxIt', 200, 'tol', 5e-4);
            obj.solver('NR') = struct('maxIt',  20, 'tol', 1e-5);
            obj.mode = 'DI';
        end

        run(obj)
    end

    methods (Abstract)
        update(obj)

        init(obj)
    end
end