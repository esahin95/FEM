classdef PlaneThermal < FEM.App.Plane
    properties (SetAccess=protected)
        T
    end
    
    methods
        function obj = PlaneThermal(options)
            % Superclass constructor
            obj@FEM.App.Plane(options)

            % variables for post processing
            obj.T = zeros(1, obj.mesh.nElems);
        end
    end

    methods (Access=protected)
        init(obj)
        
        update(obj)

        [ke, fe] = local(obj, eid)
    end
end