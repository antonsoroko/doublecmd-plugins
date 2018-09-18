-- exiftoolwdx.lua

local cmd = "exiftool"

local fields = {
    {"Machine Type", 8}, 
    {"Time Stamp", 8}, 
    {"PE Type", 8}, 
    {"OS Version", 8}, 
    {"Subsystem", 8}, 
    {"Subsystem Version", 8}, 
    {"File Version Number", 8}, 
    {"Product Name", 8}, 
    {"Product Version Number", 8}, 
    {"Company Name", 8}, 
    {"File Description", 8}, 
    {"Internal Name", 8}, 
    {"File Version", 8}, 
    {"Comments", 8}, 
    {"Original File Name", 8}, 
    {"File OS", 8}, 
    {"Object File Type", 8}, 
    {"CPU Architecture", 8}, 
    {"CPU Type", 8}, 
    {"CPU Byte Order", 8}, 
    {"File Subtype", 8}, 
    {"File Flags", 8}, 
    {"File Flags Mask", 8}, 
    {"Linker Version", 8}, 
    {"Code Size", 8}, 
    {"Initialized Data Size", 8}, 
    {"Uninitialized Data Size", 8}, 
    {"Entry Point", 8}, 
    {"Language Code", 8}, 
    {"Character Set", 8}, 
    {"Legal Copyright", 8}, 
    {"Legal Trademarks", 8}, 
    {"Private Build", 8}, 
    {"Product Version", 8}, 
    {"Special Build", 8}, 
    {"Image Version", 8}, 
    {"Title", 8}, 
    {"Subject", 8}, 
    {"Author", 8}, 
    {"Keywords", 8}, 
    {"Last Modified By", 8}, 
    {"Create Date", 8}, 
    {"Modify Date", 8}, 
    {"Last Printed", 8}, 
    {"Revision Number", 8}, 
    {"Total Edit Time", 8}, 
    {"Pages", 2}, 
    {"Words", 2}, 
    {"Characters", 2}, 
    {"Lines", 2}, 
    {"Paragraphs", 2}, 
    {"Characters With Spaces", 2}, 
    {"Char Count With Spaces", 2}, 
    {"Internal Version Number", 2}, 
    {"Company", 8}, 
    {"Software", 8}, 
    {"App Version", 8}, 
    {"Code Page", 8}, 
    {"Title Of Parts", 8}, 
    {"Heading Pairs", 8}, 
    {"Security", 8}, 
    {"Scale Crop", 8}, 
    {"Links Up To Date", 8}, 
    {"Shared Doc", 8}, 
    {"Tag PID GUID", 8}, 
    {"Comp Obj User Type", 8}, 
    {"PDF Version", 8}, 
    {"Page Count", 2}, 
    {"Producer", 8}, 
    {"Creator", 8}, 
    {"JFIF Version", 8}, 
    {"GIF Version", 8}, 
    {"SVG Version", 8}, 
    {"Resolution Unit", 8}, 
    {"X Resolution", 2}, 
    {"Y Resolution", 2}, 
    {"Image Width", 2}, 
    {"Image Height", 2}, 
    {"Color Resolution Depth", 2}, 
    {"Bit Depth", 2}, 
    {"Bits Per Sample", 2}, 
    {"Color Components", 2}, 
    {"Frame Count", 2}, 
    {"Encoding Process", 8}, 
    {"Y Cb Cr Sub Sampling", 8}, 
    {"Image Size", 8}, 
    {"Megapixels", 8}, 
    {"Background Color", 8}, 
    {"Animation Iterations", 8}, 
    {"XMP Toolkit", 8}, 
    {"Creator Tool", 8}, 
    {"Has Color Map", 8}, 
    {"Instance ID", 8}, 
    {"Document ID", 8}, 
    {"Derived From Instance ID", 8}, 
    {"Derived From Document ID", 8}, 
    {"Color Type", 8}, 
    {"Compression", 8}, 
    {"Filter", 8}, 
    {"Interlace", 8}, 
    {"Pixel Units", 8}, 
    {"Pixels Per Unit X", 8}, 
    {"Pixels Per Unit Y", 8}, 
    {"Publisher", 8}, 
    {"Comment", 8}, 
    {"Xmlns", 8}, 
    {"Volume Name", 8}, 
    {"Volume Block Count", 2}, 
    {"Volume Block Size", 2}, 
    {"Root Directory Create Date", 8}, 
    {"Data Preparer", 8}, 
    {"Volume Create Date", 8}, 
    {"Volume Modify Date", 8}, 
    {"Boot System", 8}, 
    {"Volume Size", 8}, 
    {"Artist", 8}, 
    {"Album", 8}, 
    {"Genre", 8}, 
    {"Duration", 8}, 
    {"MPEG Audio Version", 2}, 
    {"Audio Layer", 2}, 
    {"Audio Bitrate", 8}, 
    {"Sample Rate", 2}, 
    {"Channel Mode", 8}, 
    {"MS Stereo", 8}, 
    {"Intensity Stereo", 8}, 
    {"Copyright Flag", 8}, 
    {"Original Media", 2}, 
    {"Emphasis", 8}, 
    {"ID3 Size", 8}, 
    {"Fiction Book Xmlns", 8}, 
    {"Fiction Book Description Title%-info Author First%-name", 8, "Author First name"}, 
    {"Fiction Book Description Title%-info Author Middle%-name", 8, "Author Middle name"}, 
    {"Fiction Book Description Title%-info Author Last%-name", 8, "Author Last name"}, 
    {"Fiction Book Description Title%-info Book%-title", 8, "Book title"}, 
    {"Fiction Book Description Title%-info Annotation P", 8, "Annotation"}, 
    {"Fiction Book Description Title%-info Date", 8, "Date"}, 
    {"Fiction Book Description Title%-info Lang", 8, "Lang"}, 
    {"Fiction Book Description Title%-info Genre", 8, "Genre"}, 
    {"Fiction Book Description Document%-info Author First%-name", 8, "Document-info Author First name"}, 
    {"Fiction Book Description Document%-info Author Middle%-name", 8, "Document-info Author Middle name"}, 
    {"Fiction Book Description Document%-info Author Last%-name", 8, "Document-info Author Last name"}, 
    {"Fiction Book Description Document%-info Author Nickname", 8, "Document-info Author Nickname"}, 
    {"Fiction Book Description Document%-info Author Email", 8, "Document-info Author Email"}, 
    {"Fiction Book Description Document%-info Program%-used", 8, "Program used"}, 
    {"Fiction Book Description Document%-info Date", 8, "Document Date"}, 
    {"Fiction Book Description Document%-info Id", 8, "Document Id"}, 
    {"Fiction Book Description Document%-info Version", 8, "Document Version"}, 
    {"Fiction Book Description Publish%-info Book%-name", 8, "Publish info Book name"}, 
    {"Fiction Book Description Publish%-info Publisher", 8, "Publisher"}, 
    {"Fiction Book Description Publish%-info City", 8, "City"}, 
    {"Fiction Book Description Publish%-info Year", 2, "Year"}, 
    {"Fiction Book Description Publish%-info Isbn", 8, "ISBN"}, 
    {"Fiction Book Body Section Section Annotation P", 8, "Annotation"}, 
    {"Description", 8}, 
    {"Contributor", 8}, 
    {"Language", 8}, 
    {"Identifier", 8}, 
    {"Compressed Size", 2}, 
    {"Uncompressed Size", 2}, 
    {"Zip Compressed Size", 2}, 
    {"Zip Uncompressed Size", 2}, 
    {"Operating System", 8}, 
    {"Packing Method", 8}, 
    {"Zip Required Version", 8}, 
    {"Zip Bit Flag", 8}, 
    {"Zip Compression", 8}, 
    {"Zip CRC", 8}, 
    {"Flags", 8}, 
    {"Extra Flags", 8}, 
    {"File Attributes", 8}, 
    {"Target File Size", 2}, 
    {"Run Window", 8}, 
    {"Hot Key", 8}, 
    {"Target File DOS Name", 8}, 
    {"Relative Path", 8}, 
    {"Local Base Path", 8}, 
    {"Working Directory", 8}, 
    {"Command Line Arguments", 8}, 
    {"Icon File Name", 8}, 
}

local filename = ''
local output = ''

function ContentGetSupportedField(FieldIndex)
    if (fields[FieldIndex + 1] ~= nil ) then
        if (fields[FieldIndex + 1][3] ~= nil ) then
            return fields[FieldIndex + 1][3], "default|first match", fields[FieldIndex + 1][2];
        else
            return fields[FieldIndex + 1][1], "default|first match", fields[FieldIndex + 1][2];
        end
    end
    return '', '', 0; -- ft_nomorefields
end

function ContentGetDefaultSortOrder(FieldIndex)
    return 1; --or -1
end

function ContentGetDetectString()
    return 'EXT="*"'; -- return detect string
end

function ContentGetValue(FileName, FieldIndex, UnitIndex, flags)
    if (filename ~= FileName) then
        local attr = SysUtils.FileGetAttr(FileName);
        if (attr < 0) or (math.floor(attr / 0x00000004) % 2 ~= 0) or (math.floor(attr / 0x00000010) % 2 ~= 0) then
            return nil;
        end
        local handle = io.popen(cmd .. ' "' .. FileName .. '"', 'r');
        output = handle:read("*a");
        handle:close();
        filename = FileName;
    end
    if (UnitIndex == 0) then
        return getval(fields[FieldIndex + 1][1]);
    elseif (UnitIndex == 1) then
        if (fields[FieldIndex + 1][3] ~= nil ) then
            local hname = getname(FieldIndex + 1);
            local i = 1;
            while (fields[i] ~= nil) do
                if samename(i, hname, fields[FieldIndex + 1][2]) then
                    if (getval(fields[i][1])) then
                        return getval(fields[i][1]);
                    end
                end
                i = i + 1;
            end
        else
            return getval(fields[FieldIndex + 1][1]);
        end
    end    
    return nil; -- invalid
end

function getval(str)
    if (output ~= nil) then
        return output:match("\n" .. str .. "%s*:%s([^\n]+)");
    end
    return nil;
end

function getname(num)
    if (fields[num][3] ~= nil) then
        return fields[num][3];
    else
        return fields[num][1];
    end
    return nil;
end

function samename(i, str, t)
    if (fields[i][2] == t) then
        if (fields[i][1] == str) and (fields[i][3] == nil) then
            return true;
        elseif (fields[i][3] == str) then
            return true;
        end
    end
    return nil;
end
