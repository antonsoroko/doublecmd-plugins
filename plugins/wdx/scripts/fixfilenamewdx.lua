-- fixfilenamewdx.lua

local skipsysfiles = true  -- skip character, block or fifo files

local cmd = {
    {"echo", "| iconv -t latin1 | iconv -f cp1251 -t utf-8", "fix encoding"}, 
    
}

function ContentGetSupportedField(FieldIndex)
    if (cmd[FieldIndex + 1] ~= nil ) then
        if (cmd[FieldIndex + 1][3] ~= nil) then
            return cmd[FieldIndex + 1][3], "Filename|Filename.Ext|Path|Path with Filename.Ext", 8;
        else
            return cmd[FieldIndex + 1][1] .. " filename " .. cmd[FieldIndex + 1][2], "Filename|Filename.Ext|Path|Path with Filename.Ext", 8;
        end
    else
        return '', '', 0; -- ft_nomorefields
    end
end

function ContentGetValue(FileName, FieldIndex, UnitIndex, flags)
    local tname = FileName;
    if (string.find(FileName, "[/\\]%.%.$")) then
        tname = string.sub(FileName, 1, - 3);
    end
    if (UnitIndex == 0) then
        tname = getFilename(tname);
    elseif (UnitIndex == 1) then
        tname = string.match(tname, "^.*[/\\](.+[^/\\])$");
    elseif (UnitIndex == 2) then
        tname = string.match(tname, "(.*[/\\])");
    end
    if (tname ~= nil) then
        if (skipsysfiles == true) then
            local attr = SysUtils.FileGetAttr(FileName);
            if (attr < 0) or (math.floor(attr / 0x00000004) % 2 ~= 0) then
                return nil;
            end
        end
        local handle = io.popen(cmd[FieldIndex + 1][1] .. ' "' .. tname .. '" ' .. cmd[FieldIndex + 1][2]);
        output = handle:read("*a");
        handle:close();
        output = output:sub(1, - 2);
        if (output ~= '') then
            return output;
        else 
            return tname;
        end
    end
    return nil;
end 

function getFilename(str)
    local target = string.match(str, "^.*[/\\](.+[^/\\])$");
    if (target ~= nil) then
        if (string.match(target, "(.+)%..+")) then
            target = string.match(target, "(.+)%..+");
        end
    else
        target = nil;
    end
    return target;
end