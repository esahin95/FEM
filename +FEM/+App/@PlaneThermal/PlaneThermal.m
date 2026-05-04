classdef PlaneThermal < FEM.App.Plane
    properties (SetAccess=protected)
        T
        TCorner
    end
    
    methods
        function obj = PlaneThermal(options)
            % Superclass constructor
            obj@FEM.App.Plane(options)

            % Save corner temperature
            obj.TCorner = [];
        end

        function y = TCorner.get(obj)
            y = obj.TCorner;
        end
    end

    methods (Access=protected)
        init(obj)
        
        update(obj)

        [ke, fe] = local(obj, eid)

        function moveMesh(~)
            % Do nothing
        end
    end
end