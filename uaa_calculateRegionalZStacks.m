function uaa_calculateRegionalZStacks(zProjectionRanges)
global uaa

% zProjectionRanges = 10;

if isfield(uaa,'useImageDatastore') && uaa.useImageDatastore
    Ids = readall(uaa.imds);
else
    Ids = uaa.T.Image;
end

Ir = cell(size(Ids,1),length(zProjectionRanges));
for j=1:length(zProjectionRanges)
    for i = 1 : size(Ids,1)
        indMin = max(i-floor(zProjectionRanges(j)/2),1);
        indMax = min(indMin+(zProjectionRanges(j)-1),size(Ids,1));
        ind = indMax-(zProjectionRanges(j)-1) : indMax;
        Ir{i,j} = Ids{i};
        for k = ind
            Ir{i,j} = max(Ir{i,j},Ids{k});
        end
    end
end

uaa.T.ImageRegional = Ir;