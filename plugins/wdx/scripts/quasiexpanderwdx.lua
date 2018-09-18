-- quasiexpanderwdx.lua

local parts = 5

local separator = { -- patern (function split), field name, patern (function gsplit)
    {"([^%s]+)", "space",         nil},
    {"([^-]+)",  "-",             nil},
    {nil,        " - ",           nil}, -- uses field name as a pattern in gsplit
    {nil,        " - (2)", "%s+%-%s+"},
    {"([^/]+)",  "/",             nil},
}

function ContentGetSupportedField(FieldIndex)
    local submi = '';
    for i = 1, #separator do
        if (i > 1) then
            submi = submi .. '|';
        end
        submi = submi .. 'Filename (' .. separator[i][2] .. ')|';
        submi = submi .. 'FilenameWithExt (' .. separator[i][2] .. ')|';
        submi = submi .. 'Path (' .. separator[i][2] .. ')';
    end
    local num = FieldIndex + 1
    if (parts >= num) then
        return 'left ' .. num, submi, 8;
    elseif (num > parts) and (parts >= num - parts) then
        return 'right ' .. num - parts, submi, 8;
    end
    return '', '', 0; -- ft_nomorefields
end

function ContentGetValue(FileName, FieldIndex, UnitIndex, flags)
    local inv = false;
    local target = '';
    local num = FieldIndex + 1
    local snum = 1;
    local result = {};
    local tname = FileName;
    if (string.find(FileName, "[/\\]%.%.$")) then
        tname = string.sub(FileName, 1, - 3);
    end
    if (num > parts) then
        inv = true;
        num = FieldIndex - parts;
    end
    if (UnitIndex % 3  == 0) then
        target = tname:match("^.*[/\\](.+[^/\\])$");
        if (target ~= nil) then
            if (string.match(target, "(.+)%..+")) then
                target = string.match(target, "(.+)%..+");
            end
        else
            target = ''
        end
    elseif (UnitIndex % 3 == 1) then
        target = tname:match("^.*[/\\](.+[^/\\])$");
    elseif (UnitIndex % 3 == 2) then
        target = tname:match("(.*[/\\])");
    end
    for i = 1, UnitIndex do
        if (i % 3  == 0) then
            snum = snum + 1;
        end
    end
    if (separator[snum][1] ~= nil) then
        result = split(target, separator[snum][1]);
    elseif (separator[snum][3] ~= nil) then
        result = split_alt(target, separator[snum][3]);
    elseif (separator[snum][2] ~= nil) then
        result = split_alt(target, separator[snum][2], true);
    end
    if (inv == true) and (#result - num > 0) then
        return result[#result - num];
    elseif (inv == false) and (result[num] ~= nil) then
        return result[num];
    end
    return nil; -- invalid
end

function split(str, pat)
    local t = {};
    for str in string.gmatch(str, pat) do
        table.insert(t, str)
    end
    return t
end

-- https://stackoverflow.com/a/43582076

local function gsplit(text, pattern, plain)
    local splitStart, length = 1, #text
    return function ()
        if splitStart then
            local sepStart, sepEnd = string.find(text, pattern, splitStart, plain)
            local ret
            if not sepStart then
                ret = string.sub(text, splitStart)
                splitStart = nil
            elseif sepEnd < sepStart then
                ret = string.sub(text, splitStart, sepStart)
                if sepStart < length then
                    splitStart = sepStart + 1
                else
                    splitStart = nil
                end
            else
                ret = sepStart > splitStart and string.sub(text, splitStart, sepStart - 1) or ''
                splitStart = sepEnd + 1
            end
            return ret
        end
    end
end

function split_alt(text, pattern, plain)
    local ret = {}
    for match in gsplit(text, pattern, plain) do
        table.insert(ret, match)
    end
    return ret
end
