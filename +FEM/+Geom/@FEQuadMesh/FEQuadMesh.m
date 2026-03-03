classdef FEQuadMesh < FEM.Geom.FEMesh2D   
    properties (Constant)
        type = 'Quadrilateral'
    end

    properties (SetAccess=protected)
        quadVol = FEM.Quad.Quadrilateral()
        quadBnd = FEM.Quad.Simpson()
    end
    
    methods    
        init(obj, options)
    end
end

