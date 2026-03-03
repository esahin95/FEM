classdef FEMesh < handle        
    properties (Dependent)
        % Geometric dimensions
        nDims 

        % Geometry size
        nNodes
        nElems
        nLocal
        nFaces
        nPatch
    end
    
    properties (SetAccess=protected)
        % Geometry data
        Nodes
        Elements
        Faces
        Owners
        Patches
    end

    properties (SetAccess=protected, Abstract)
        % Integration schemes
        quadVol
        quadBnd
    end

    methods
        % Constructor
        function obj = FEMesh(options)
            % Initialize mesh data
            obj.init(options)

            % Initialize plot
            obj.draw()
        end

        % Update vertices
        update(obj, U)

        % Geometric dimensions
        function n = get.nDims(obj)
            n = size(obj.Nodes, 1);
        end

        % Number of nodes
        function n = get.nNodes(obj)
            n = size(obj.Nodes, 2);
        end

        % Number of elements
        function n = get.nElems(obj)
            n = size(obj.Elements, 2);
        end

        % Number of nodes per element
        function n = get.nLocal(obj)
            n = size(obj.Elements, 1);
        end

        % Number of boundary faces
        function n = get.nFaces(obj)
            n = size(obj.Faces, 2);
        end

        % Number of patches
        function n = get.nPatch(obj)
            n = numel(obj.Patches);
        end
    end

    methods (Abstract)
        % Draw mesh
        draw(obj)

        % Initialize mesh
        init(obj, options)

        % Precompute geometry
        precompute(obj)

        % Access derived geometry data
        [B, wdV] = comp(obj, gid, eid)
    end
end

