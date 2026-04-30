classdef Thermal
    properties
        Cp
        kappa
    end
    
    methods
        function obj = Thermal(options)
            % material parameters
            obj.Cp = options.Cp;
            obj.kappa = options.kappa;
        end
    end
end