function update(obj)

% Iterate until convergence
for it = 1:obj.solver(obj.mode).maxIt
    % build linear system
    [K, F] = obj.build();

    % solve linear system
    U = K \ F;

    % update current iteration
    enorm = norm(obj.U + (-U)) / norm(U);
    fnorm = 0;
    obj.U.replace(U);

    % check termination criteria
    fprintf('it: %i, fnorm: %.5e, enorm: %.5e\n', it, fnorm, enorm)
    if enorm < obj.solver(obj.mode).tol && fnorm < obj.solver(obj.mode).tol
        break
    end
end

% Post processing
obj.TCorner = [obj.TCorner [obj.time; U(end)]];
obj.T = obj.U.Internal;