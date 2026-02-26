function options = readDict(fname)

fid = fopen(fname,'r');

options = struct();

while ~feof(fid)
    line = strtrim(fgetl(fid));

    if isempty(line) || startsWith(line,'%')
        continue
    end


    if regexp(line, '^\w+$', 'once')
        addBlock(data, fid)

        % word = line;
        % level = 0;
        % 
        % % check if new block
        % line = strtrim(fgetl(fid));
        % switch line
        %     case '{'
        %         level = level + 1;
        %     case '}'
        %         level = level - 1;
        % end
        % 
        % options.(line) = struct();
        % while true && ~feof(fid)
        %     line = strtrim(fgetl(fid));
        %     if line == "}"
        %         break
        %     end
        % end
    end

    tokens = regexp(line,'(\w+)\s+([^;]+);','tokens');

    if ~isempty(tokens)
        key = tokens{1}{1};
        value = strtrim(tokens{1}{2});
        num = str2double(value);
        if ~isnan(num)
            options.(key) = num;
        else
            options.(key) = value;
        end
    end
end

fclose(fid);