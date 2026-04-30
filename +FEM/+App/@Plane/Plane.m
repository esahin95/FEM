classdef Plane < FEM.App.Base
    properties (Access=protected)
        wdV
        XYP
    end
    
    methods
        function obj = Plane(options)
            obj = obj@FEM.App.Base(options);
        end
    end

    methods (Access=protected)
        precompute(obj)
    end
end

