function options = readControls(fname)
arguments
    fname (1,:) char = 'system/controlDict'
end

% Open controlDict file
fid = fopen(fname,'r');

% Read blocks
options = struct();
level = 0;
while ~feof(fid)
    % Read line
    line = strtrim(fgetl(fid));

    % Ignore empty lines and comments
    if isempty(line) || startsWith(line,'%')
        continue
    end

    % Change level
    switch line
        case '{'
            level = level + 1;
            subOptions = struct();
            continue
        case '}'
            level = level - 1;
            options.(word) = subOptions;
            continue
    end

    % New block
    if regexp(line, '^\w+$', 'once')
        word = line;
        continue
    end

    % Read options
    tokens = regexp(line,'(\w+)\s+([^;]+);','tokens');
    if ~isempty(tokens)
        key = tokens{1}{1};
        value = strtrim(tokens{1}{2});
        num = str2double(value);
        if ~isnan(num)
            subOptions.(key) = num;
        else
            subOptions.(key) = value;
        end
    end
end

% Close file
fclose(fid);