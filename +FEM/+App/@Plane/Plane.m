classdef Plane < FEM.App.Base    
    methods
        function obj = Plane(options)
            obj = obj@FEM.App.Base(options);
        end
    end

    methods (Access=protected)
        precompute(obj)
    end
end

