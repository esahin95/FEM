classdef FEField < handle
    properties (SetAccess=protected)
        mesh
        Internal
        Boundary
        fDoF
    end

    properties (Dependent)
        nDim
    end
    
    methods
        function obj = FEField(mesh, options)
            % Reference to mesh
            obj.mesh = mesh;
            
            % Read initial field
            obj.read(FEM.Util.readControls(['0/' options.name]))
        end
        
        read(obj, data)

        correct(obj)

        varargout = size(obj, varargin)

        n = norm(obj, varargin)

        obj = plus(obj, U)

        [Kh, Fh] = reduce(obj, K, F)

        function n = get.nDim(obj)
            n = size(obj.Internal, 1);
        end
    end
end

