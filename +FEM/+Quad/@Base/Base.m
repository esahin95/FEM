classdef Base
    
    properties (Access=protected)
        nTot
        nRed
        weights
        values 
        derivs
    end
    
    methods
        function x = val(obj, gaussID)
            x = obj.values(:, gaussID);
        end

        function x = grad(obj, gaussID)
            x = obj.derivs(:,:,gaussID);
        end

        function w = weight(obj, gaussID)
            w = obj.weights(gaussID);
        end

        function n = size(obj)
            n = obj.nTot;
        end

        function idx = regular(obj)
            idx = obj.nRed+1:obj.nTot;
        end

        function idx = reduced(obj)
            idx = 1:obj.nRed;
        end
    end

end