classdef FEMesh2D < FEM.Geom.FEMesh
    properties
        % Plot data
        fig
        plt
        bnd
    end

    methods   
        % Plot mesh
        draw(obj)

        % Change patch colors
        color(obj, C)
    end
end

