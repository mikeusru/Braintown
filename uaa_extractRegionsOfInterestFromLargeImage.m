function uaa_extractRegionsOfInterestFromLargeImage

global uaa

zoomOriginal = 1;
zoomTarget = 30;
imageOriginal = uaa_getCurrentImageFrame;
fullSize = size(imageOriginal) * zoomTarget / zoomOriginal;
gridSize = (256 / max(fullSize)) * fullSize;
gridOriginalSize = round((256 / max(fullSize)) * size(imageOriginal));
% ca = uaa_imageToGrid(imageOriginal,gridOriginalSize(1),gridOriginalSize(2));

[BW, I] = uaa_adaptiveThreshold2(imageOriginal);
BW = bwareaopen(BW,4);
stats = regionprops(BW,'BoundingBox');
ROIs = cellfun(@(x) imcrop(imageOriginal,x),{stats.BoundingBox},'UniformOutput',false);


for i = 1:length(ROIs)
    ca(i).ImageGrid = uaa_imageToGrid(ROIs{i},gridOriginalSize(1),gridOriginalSize(2));
end