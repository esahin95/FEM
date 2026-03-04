function correct(obj)

fDoF = ones(size(obj.Internal), 'logical');
for thePatch = [obj.Boundary{:}]
    switch thePatch.type
        case 'fixedValue'
            % Set fixed value
            obj.Internal(thePatch.dofs) = thePatch.value;

            % Constrain degrees of freedom
            fDoF(thePatch.dofs) = false;
        
        case 'zeroGradient'
            continue

        case 'constantFriction'
            continue
            
        otherwise
            error('unknown patch type')
    end
end
obj.fDoF = fDoF(:);