classdef FEElastic < FEM.App.FEProblem
    properties
        EPS 
        SIG
    end
    
    methods
        function obj = FEElastic(options)
            % Superclass constructor
            obj@FEM.App.FEProblem(options)

            % variables for post processing
            obj.EPS = zeros(1, obj.mesh.nElems);
            obj.SIG = zeros(1, obj.mesh.nElems);
        end
        
        [K,F] = build(obj)

        [ke, fe] = local(obj, elemID)

        neumann(obj, faceID, value)

        update(obj)
    end
end

