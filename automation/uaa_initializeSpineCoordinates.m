function uaa_initializeSpineCoordinates
global uaa
if ~sum(strcmp('SpineCoordinates',uaa.T.Properties.VariableNames))
    coords = cell(size(uaa.T,1),1);
    uaa.T.SpineCoordinates = coords;
end