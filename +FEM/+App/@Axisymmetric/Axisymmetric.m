classdef Axisymmetric < FEM.App.Base        
    methods
        function obj = Axisymmetric(options)
            obj@FEM.App.Base(options)
        end
    end

    methods (Access=protected)
        % Integrate boundary patches
        [K, F] = fixedGradient(obj, thePatch)

        precompute(obj)
    end
end