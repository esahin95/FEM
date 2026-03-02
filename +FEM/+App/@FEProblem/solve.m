function solve(obj)

for it = 1:obj.opt.numerics.maxIt
    % build linear system
    [K, F] = obj.build();

    % solve linear system
    U = K \ F;

    % update current solution
    
end