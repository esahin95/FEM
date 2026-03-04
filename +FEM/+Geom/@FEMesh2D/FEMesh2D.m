classdef FEMesh2D < FEM.Geom.FEMesh
    properties (Access=private)
        % Plot data
        fig
        plt
        bnd
    end

    methods   
        % Plot mesh
        draw(obj)

        % update plot
        update(obj, U)

        % Change patch colors
        function color(obj, C)
            obj.plt.CData = C;
        end

        % Show figure
        function show(obj)
            figure(obj.fig)
        end
    end
end

