function [singleNonSpinePerimDistPixels, nonSpinePixelPos, ind, locs] = uaa_identifyNonSpinesInData(allPerimSpineInd, pD, pixelPosition, ignoreDataHere)

global uaa

locs = [];

%capture 5µm along perimeter for non-spine training data
pixelPerimRegion = round(1/uaa.imageInfo.umPerPixel * 5);

%remove data from ignoreDataHere region;
ignoreDataInd = ignoreDataHere(pixelPosition);
nonSpineSearchZone = ~ignoreDataInd & ~allPerimSpineInd;

if length(pixelPosition) < pixelPerimRegion || isempty(find(nonSpineSearchZone,1))
    singleNonSpinePerimDistPixels = [];
    nonSpinePixelPos = [];
    ind = nonSpineSearchZone;
    return
end

if length(pD(nonSpineSearchZone)) < 3
    ind = {};
    nonSpinePixelPos = {};
    singleNonSpinePerimDistPixels = {};
    return
end

%identify peaks in non-spine data
pD_peaks = imregionalmax(pD .* nonSpineSearchZone);
pD_peaks = bwmorph(pD_peaks,'shrink',inf);
locs = find(pD_peaks);

% [~,locs] = findpeaks(pD(nonSpineSearchZone));

nonSpinePixelPos = cell(size(locs));
ind = cell(size(locs));
singleNonSpinePerimDistPixels = cell(size(locs));
nonSpineSearchZone = true(size(pD));
for i=1:length(locs)
    [ind{i},~,shiftedAroundPixelInd] = uaa_expandAroundPixel(locs(i),nonSpineSearchZone,pixelPerimRegion);
    singleNonSpinePerimDistPixels{i} = pD(shiftedAroundPixelInd);
    nonSpinePixelPos{i} = pixelPosition(shiftedAroundPixelInd);
end