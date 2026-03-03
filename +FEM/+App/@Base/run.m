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

    % Update mesh
    obj.mesh.update(obj.U.Internal * obj.deltaT)
    
    % Post processing
    obj.mesh.color(obj.(obj.field))
    
    % Finish iteration
    fprintf("Finished iteration for time %.3f\n\n", t)
end

toc