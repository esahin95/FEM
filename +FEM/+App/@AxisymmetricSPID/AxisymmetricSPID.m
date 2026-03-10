classdef AxisymmetricSPID < FEM.App.Axisymmetric
    properties        
        % post processing variables
        TEPS 
        EPSR
        FSTS
        XVOL
    end

    properties (Access=private)
        alph
        diat
        vscl
    end

    methods
        function obj = AxisymmetricSPID(options)
            % Superclass constructor
            obj@FEM.App.Axisymmetric(options)

            % Process options
            numerics = options.numerics;
            obj.alph = numerics.alph;
            obj.diat = numerics.diat;
            obj.vscl = numerics.vscl;

            % post processing variables
            m = obj.mesh.nElems;
            obj.TEPS = zeros(1,m);
            obj.EPSR = zeros(1,m);
            obj.FSTS = zeros(1,m);
            obj.XVOL = zeros(1,m);
        end

        update(obj)

        init(obj)
    end

    methods (Access=protected)
        [ke, fe] = local(obj, eid)
    end
end 