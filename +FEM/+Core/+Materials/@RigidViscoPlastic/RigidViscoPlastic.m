classdef RigidViscoPlastic
    properties
        % Material parameters
        zamm
        zamB
        zamC
        zamn
    end
    
    methods
        function obj = RigidViscoPlastic(options)
            obj.zamm = options.m;
            obj.zamB = options.B;
            obj.zamC = options.C;
            obj.zamn = options.n;
        end
        
        function fsts = flowStress(obj, teps, psr)
            % flow stress
            fsts = (psr .^ obj.zamm) .* (teps .^ obj.zamn) * obj.zamB + obj.zamC;
        end

        function stsr = stressRate(obj, teps, psr)            
            % stress rate
            stsr = (psr .^ (obj.zamm - 1)) .* (teps .^ obj.zamn) * obj.zamB * obj.zamm;
        end
    end
end

