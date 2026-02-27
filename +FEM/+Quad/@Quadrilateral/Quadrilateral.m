classdef Quadrilateral < FEM.Quad.Base
    methods
        function obj = Quadrilateral()
            %GAUSSINTEGRATE2D Construct an instance of this class
            
            % gaussian quadrature points
            tmp = 1/sqrt(3);
            xq = [0 -tmp  tmp tmp -tmp; 
                  0 -tmp -tmp tmp  tmp];

            % weights for reduced and regular points
            obj.weights = [4. 1. 1. 1. 1.];
            obj.nRed = 1;
            obj.nTot = numel(obj.weights);
            
            % shape function parameters for quadrilaterals
            coef = [-1 -1; 
                     1 -1; 
                     1  1; 
                    -1  1];
            
            % shape function values
            obj.values = .25 * (1 + coef(:,1) * xq(1,:)) .* (1 + coef(:,2) * xq(2,:));
            
            % shape function derivatives
            obj.derivs = zeros(size(coef, 1), 2, size(xq, 2));
            obj.derivs(:,1,:) = .25 * coef(:,1) .* (1 + coef(:,2) * xq(2,:));
            obj.derivs(:,2,:) = .25 * (1 + coef(:,1) * xq(1,:)) .* coef(:,2);
        end
    end
end