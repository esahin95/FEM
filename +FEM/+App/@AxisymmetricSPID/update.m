function update(obj)

for step = 1:obj.solver(obj.mode).maxIt
    % build linear system
    [K, F] = obj.build();

    % solve linear system
    dU = K \ F;

    % velocity update
    enorm = norm(dU) / norm(obj.U);
    fnorm = norm(F);
    obj.U = obj.U + dU;

    % check termination criteria
    fprintf('it: %i, fnorm: %.5e, enorm: %.5e\n', step, fnorm, enorm)
    if enorm < obj.solver(obj.mode).tol && fnorm < obj.solver(obj.mode).tol
        break
    end
end