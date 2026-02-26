classdef FEQuadMesh < FEM.Geom.FEMesh2D    
    methods
        function obj = FEQuadMesh(opt)
            arguments
                opt.nex (1,1) double {mustBeInteger}
                opt.ney (1,1) double {mustBeInteger}
                opt.Lx (1,1) double {mustBePositive}
                opt.Ly (1,1) double {mustBePositive}
            end

            % Initial mesh
            obj.init(opt.nex, opt.ney, opt.Lx, opt.Ly)
    
            % Draw mesh
            obj.draw()
        end
        
        init(obj, nex, ney, Lx, Ly)
    end
end

