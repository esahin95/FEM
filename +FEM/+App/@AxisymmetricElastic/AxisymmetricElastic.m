classdef AxisymmetricElastic < FEM.App.Axisymmetric
    properties (SetAccess=protected)
        EPS 
        SIG
    end
    
    methods
        function obj = AxisymmetricElastic(options)
            % Superclass constructor
            obj@FEM.App.Axisymmetric(options)

            % variables for post processing
            obj.EPS = zeros(1, obj.mesh.nElems);
            obj.SIG = zeros(1, obj.mesh.nElems);
        end

        update(obj)
    end

    methods (Access=protected)
        [ke, fe] = local(obj, eid)
    end
end

