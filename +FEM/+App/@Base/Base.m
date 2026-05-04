classdef Base < handle
    properties (Constant, Access=protected)
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

    properties (SetAccess=protected)        
        % Mesh
        mesh

        % Precomuted geometry data
        wdV
        XYP

        % Material
        mat

        % Global matrices
        M

        % Global solution
        U
        oldU

        % Field name for post-processing
        field

        % solver parameters
        solver
        mode
    end

    properties (Access=protected)
        startTime
        endTime
        deltaT
        time
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
            obj.oldU = FEM.Core.FEField(obj.mesh, solution);

            % Initialize global FE matrix
            obj.M  = FEM.Core.FEMatrix(obj.mesh, obj.U);

            % Select post-processing element array
            obj.field = solution.field;

            % solver parameters
            obj.solver = dictionary;
            obj.solver('DI') = struct('maxIt', 200, 'tol', 5e-4);
            obj.solver('NR') = struct('maxIt',  20, 'tol', 1e-5);
            obj.mode = 'DI';

            % Precompute geometry
            [n, m] = size(obj.mesh.Elements);
            obj.wdV = zeros(size(obj.mesh.quadVol), m);
            obj.XYP = zeros(n, obj.mesh.nDim + 1, size(obj.mesh.quadVol), m);
            obj.precompute()
        end

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
        [K, F] = fixedValue(obj, thePatch)
        [K, F] = zeroGradient(obj, thePatch)

        function moveMesh(obj)
            obj.mesh.update(obj.U.Internal * obj.deltaT)
            obj.precompute()
        end
    end

    methods (Abstract, Access=protected)
        update(obj)

        init(obj)

        [ke, fe] = local(obj, eid)

        precompute(obj)
    end
end