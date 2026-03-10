function update(obj)

% Iterate until convergence
for it = 1:obj.solver(obj.mode).maxIt
    % build linear system
    [K, F] = obj.build();

    % solve linear system
    dU = K \ F;

    % update current iteration
    enorm = norm(dU) / norm(obj.U);
    switch obj.mode
        case 'DI'
            fnorm = 0;
        case 'NR'
            fnorm = norm(F);
    end
    obj.U = obj.U + dU;

    % check termination criteria
    fprintf('it: %i, fnorm: %.5e, enorm: %.5e\n', it, fnorm, enorm)
    if enorm < obj.solver(obj.mode).tol && fnorm < obj.solver(obj.mode).tol
        break
    end
end