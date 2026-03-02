classdef FEField < handle
    properties
        mesh
        Internal
        Boundary
        fDoF
    end
    
    methods
        function obj = FEField(mesh, options)
            % Reference to mesh
            obj.mesh = mesh;
            
            % Read initial field
            obj.read(FEM.Util.readControls(['0/' options.name]))
        end
        
        read(obj, data)

        correctBoundaryConditions(obj)

        size(obj)
    end
end

