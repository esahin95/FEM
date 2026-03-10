classdef Axisymmetric < handle
    properties (Constant, Access=private)
        % matrix for assembly
        Bfl = [1 0 0; 
               0 0 0; 
               0 0 1; 
               0 1 0; 
               0 0 0; 
               0 1 0; 
               0 0 0; 
               1 0 0];
    end
    
    properties (Access=private)
        wdV
        XYP
    end

    properties (SetAccess=protected)        
        % Mesh
        mesh

        % Material
        mat

        % Global matrices
        M

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
        function obj = Axisymmetric(options)
            % Process options 
            runTime = options.runTime;
            obj.startTime = runTime.startTime;
            obj.endTime = runTime.endTime;
            obj.deltaT = runTime.deltaT;
            
            % Create mesh
            geometry = options.geometry;
            obj.mesh = FEM.Geom.(geometry.type)(geometry);
            
            % Precompute geometry
            [n, m] = size(obj.mesh.Elements);
            obj.wdV = zeros(size(obj.mesh.quadVol), m);
            obj.XYP = zeros(n, obj.mesh.nDim + 1, size(obj.mesh.quadVol), m);
            obj.precompute()

            % Create material
            material = options.material;
            obj.mat = FEM.Core.Materials.(material.type)(material);

            % Initialize global solution
            solution = options.solution;
            obj.U = FEM.Core.FEField(obj.mesh, solution);

            % Initialize global FE matrix
            obj.M  = FEM.Core.FEMatrix(obj.mesh, obj.U);

            % Select post-processing element array
            obj.field = solution.field;

            % solver parameters
            obj.solver = dictionary;
            obj.solver('DI') = struct('maxIt', 200, 'tol', 5e-4);
            obj.solver('NR') = struct('maxIt',  20, 'tol', 1e-5);
            obj.mode = 'DI';
        end

        precompute(obj)

        % Access derived geometry data
        function [B, wdV] = comp(obj, gid, eid)
            B = reshape(obj.Bfl * obj.XYP(:,:,gid,eid)', 4, []);
            wdV = obj.wdV(gid,eid);
        end

        run(obj)
    end

    methods (Access=protected)
        % Build global matrices
        [K, F] = build(obj)

        % Integrate boundary patches
        [K, F] = fixedGradient(obj, thePatch)
        [K, F] = fixedValue(obj, thePatch)
        [K, F] = zeroGradient(obj, thePatch)
    end

    methods (Abstract)
        update(obj)

        init(obj)
    end

    methods (Abstract, Access=protected)
        [ke, fe] = local(obj, eid)
    end
end