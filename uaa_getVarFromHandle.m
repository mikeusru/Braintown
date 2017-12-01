function varName = uaa_getVarFromHandle(handleName)

global uaa

if ~isempty(strfind(handleName,'Slider'))
    handleName=handleName(1:end-6);
elseif ~isempty(strfind(handleName,'re1')) || ~isempty(strfind(handleName,'re2'))
    if ~isempty(strfind(handleName,'gbr'))
        handleName=handleName(1:end-2);
    else
        handleName=handleName(1:end-3);
    end
elseif ~isempty(strfind(handleName,'vEdit'))
        handleName=handleName(1:end-5);
end

switch handleName
    case {'imex','mic','mbwao'}
        varName='mask_em';
    case 'gbr'
        varName='Ig';
    case 'tfd'
        varName='bw2';
    case 'bw3io'
        varName='bw3';
    case 'bw4ao'
        varName='bw4';
    case {'msl','bw5ao'}
        varName='bw5';
    case 'bw6imc'
        varName='bw6';
    case 'bw7ao'
        varName='bw7';
end    