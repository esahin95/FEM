classdef SPID < FEM.App.Base
    properties
        % solver parameters
        solver
        typ
        
        % post processing variables
        TEPS 
        EPSR
        FSTS
        XVOL
    end

    methods
        function obj = SPID(options)
            % Superclass constructor
            obj@FEM.App.Base(options)

            % solver parameters
            obj.solver = dictionary;
            obj.solver('DI') = struct('maxiter', 200, 'tol', 5e-4);
            obj.solver('NR') = struct('maxiter', 20, 'tol', 1e-5);
            obj.typ = 'DI';

            % post processing variables
            obj.TEPS = zeros(1,msh.nElems);
            obj.EPSR = zeros(1,msh.nElems);
            obj.FSTS = zeros(1,msh.nElems);
            obj.XVOL = zeros(1,msh.nElems);
        end
    end
end 