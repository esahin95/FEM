function init(obj)

% Set solver to Direct Iteration
obj.mode = 'DI';

obj.solver('DI').maxIt = 1;