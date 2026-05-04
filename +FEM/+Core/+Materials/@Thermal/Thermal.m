classdef Thermal
    properties
        Cp
        kappa
        rho
    end

    properties(Dependent)
        % thermal diffusivity
        alpha
    end
    
    methods
        function obj = Thermal(options)
            % material parameters
            obj.Cp = options.Cp;
            obj.kappa = options.kappa;
            obj.rho = options.rho;
        end

        function a = get.alpha(obj)
            a = obj.kappa / (obj.rho * obj.Cp);
        end
    end
end