classdef FEMesh2D < FEM.Geom.FEMesh
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
        % precomputed geometric data
        wdV
        XYP

        % Plot data
        fig
        plt
        bnd
    end

    methods   
        function obj = FEMesh2D(options)
            obj@FEM.Geom.FEMesh(options)

            % Precompute geometry
            obj.wdV = zeros(size(obj.quadVol), obj.nElems);
            obj.XYP = zeros(obj.nLocal, size(obj.Nodes, 1) + 1, size(obj.quadVol), obj.nElems);
            obj.precompute();
        end

        % Plot mesh
        draw(obj)

        % Change patch colors
        color(obj, C)

        % update plot
        update(obj, U)

        % Precompute geometry
        precompute(obj)

        % Access derived geometry data
        [B, wdV] = comp(obj, gid, eid)

        % Show figure
        function show(obj)
            figure(obj.fig)
        end
    end
end

