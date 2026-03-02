function update(obj)

% Iterate until convergence
for it = 1:obj.opt.numerics.maxIt
    % build linear system
    [K, F] = obj.build();

    % solve linear system
    dU = K \ F;

    % update current iteration
    enorm = norm(dU) / norm(obj.U(:));
    fnorm = norm(F);
    obj.U.add(dU);

    % check termination criteria
    if enorm < obj.opt.numerics.tol && fnorm < obj.opt.numerics.tol
        break
    end
end
fprintf('it: %i, fnorm: %.5e, enorm: %.5e\n', it, fnorm, enorm)