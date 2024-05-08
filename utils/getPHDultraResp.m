function resp = getPHDultraResp(scomObj,cmd)
%resp = getPHDultraResp(scomObj,cmd) Returns the response of the pump for a
%given command
%   Detailed explanation goes here

cbMode  = scomObj.BytesAvailableFcnMode;
cbBytes = scomObj.BytesAvailableFcnCount;
cbFH    = scomObj.BytesAvailableFcn;

configureCallback(scomObj,'off');

scomObj.flush('input');
scomObj.writeline(cmd);
pause(.05);
try
    resp = scomObj.read(scomObj.NumBytesAvailable,'char');
    ME = [];
catch ME
end

switch cbMode
    case 'off'
        % already off...
    case 'byte'
        configureCallback(scomObj,'byte',cbBytes,cbFH);
    case 'terminator'
        configureCallback(scomObj,'terminator',cbFH);
    otherwise, error('bug');
end

if ~isempty(ME), rethrow(ME); end

end