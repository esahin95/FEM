classdef Elastic
    properties
        E
        nu
        C
    end
    
    methods
        function obj = Elastic(options)
            % material parameters
            obj.E = options.E;
            obj.nu = options.nu;
            
            % stiffness matrix
            obj.C = obj.E/(1+obj.nu)/(1-2*obj.nu) * ...
                    [1-obj.nu   obj.nu   obj.nu 0; 
                       obj.nu 1-obj.nu   obj.nu 0; 
                       obj.nu   obj.nu 1-obj.nu 0; 
                            0        0        0 0.5*(1-2*obj.nu)];
        end
        
        function sig = stress(obj, eps, varargin)
            sig = obj.C * eps;
        end

        function C = stiff(obj, varargin)
            C = obj.C;
        end
    end
end