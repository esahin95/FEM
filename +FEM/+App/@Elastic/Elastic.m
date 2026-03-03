classdef Elastic < FEM.App.Base
    properties (SetAccess=protected)
        EPS 
        SIG
    end
    
    methods
        function obj = Elastic(options)
            % Superclass constructor
            obj@FEM.App.Base(options)

            % variables for post processing
            obj.EPS = zeros(1, obj.mesh.nElems);
            obj.SIG = zeros(1, obj.mesh.nElems);
        end

        update(obj)
    end

    methods (Access=private)
        [K, F] = build(obj)

        [ke, fe] = local(obj, eid)

        [ke, fe] = bound(obj, fid, value)
    end
end

