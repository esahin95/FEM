classdef Simpson < FEM.Quad.Base
    methods
        function obj = Simpson()
            % quadrature points for simpson rule
            xq = linspace(-1,1,5);
            
            % weights for reduced and regular points
            obj.weights  = 1/6 * [1 4 2 4 1];
            obj.nRed = 0;
            obj.nTot = numel(obj.weights);
            
            % shape function parameters
            coef = [-1; 
                     1];
            
            % shape function values
            obj.values = 0.5 * (1 + coef * xq);

            % shape function derivatives
            obj.derivs = zeros(size(coef, 1), 1, size(xq, 2));
            obj.derivs(:,1,:) = 0.5 * coef * ones(size(xq));
        end
    end
end