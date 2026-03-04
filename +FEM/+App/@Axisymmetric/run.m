function run(obj)

tic

% Pre-Solve 
obj.init()
fprintf("Finished initialization\n\n")

t = obj.startTime;
while t < obj.endTime
    % Current time
    t = t + obj.deltaT;
    
    % Update solution
    obj.update()

    % Post processing
    obj.mesh.color(obj.(obj.field))
    drawnow limitrate

    % Update mesh
    obj.mesh.update(obj.U.Internal * obj.deltaT)
    obj.precompute()
    
    % Finish iteration
    fprintf("Finished iteration for time %.3f\n\n", t)
end

toc