function run(obj)

tic

% Pre-Solve 
obj.init()
fprintf("Finished initialization\n\n")

obj.time = obj.startTime;
while obj.time < obj.endTime
    % Save old time level
    obj.oldU.replace(obj.U);
    
    % Current time
    obj.time = obj.time + obj.deltaT;
    
    % Update solution
    obj.update()

    % Post processing
    obj.mesh.color(obj.(obj.field))
    drawnow limitrate

    % Update mesh
    obj.moveMesh()
    
    % Finish iteration
    fprintf("Finished iteration for time %.3f\n\n", obj.time)
end

toc