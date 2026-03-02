function run(obj)

t = obj.opt.runTime.startTime;
while t < obj.opt.runTime.endTime
    % Current time
    t = t + obj.opt.runTime.deltaT;
    
    % Solve current time step
    obj.solve()

    % Post processing
    obj.mesh.color(obj.(fieldName))
    
    % Finish iteration
    fprintf("Finished iteration for time %.3f\n\n", t)
end