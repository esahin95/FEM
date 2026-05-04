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
            switch obj.mode
                case 'elements'
                    obj.plt.CData = C;
                case 'nodes'
                    obj.plt.FaceVertexCData = C(:);
                otherwise
                    error('Unknown mode for drawing')
            end
        end

        % Show figure
        function show(obj)
            figure(obj.fig)
        end
    end
end

