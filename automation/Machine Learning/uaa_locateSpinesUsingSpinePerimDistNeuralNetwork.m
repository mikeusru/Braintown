function [labeledSpineEdgesThick, pos, Y] = uaa_locateSpinesUsingSpinePerimDistNeuralNetwork(imageRegions)
% [labeledPerim, labeledSpineEdgesThick, pos] = uaa_locateSpinesUsingSpinePerimDistNeuralNetwork(imageRegions)
global uaa
if nargin<1
    imageRegions = uaa.T.PerimRegions{uaa.currentFrame,1};
end

net = uaa.ml.net;
% BWborder = uaa_findImageBorder(uaa.T.Image{uaa.currentFrame});
% ignoreDataHere = uaa.T.DetachedSpines{uaa.currentFrame,1} | BWborder;

% pixelPerimRegion = round(1/uaa.imageInfo.umPerPixel * 5);
% pixelPerimRegion = pixelPerimRegion + 1 - mod(pixelPerimRegion,2); %add 1 if even value

Y = cell(size(imageRegions));
labeledPerim = zeros(size(imageRegions(1).x));
labeledSpineEdges = zeros(size(imageRegions(1).x));

for k = 1:size(imageRegions,1)
    pD = imageRegions(k).y;
    labeledSpines = zeros(size(pD));
    spineEdges = false(size(pD));
%     if length(pD) < pixelPerimRegion
%         locs = [];
%     else
%         [~,locs] = findpeaks(pD);
%     end
    %     locs = find(pD);
%     searchZone = true(size(pD));
    locs = imageRegions(k).peakLocations;
    Y2 = zeros(length(imageRegions(k).perimDistFromDendritePixels),2);
    for i=1:length(locs)
%         [~,~,shiftedAroundPixelInd] = uaa_expandAroundPixel(locs(i),searchZone,pixelPerimRegion);
%         testPerimPixels = pD(shiftedAroundPixelInd);
        [~, yi] = uaa_interpSpinePerim(imageRegions(k).perimDistFromDendritePixels{i});
        [~, yyi] = uaa_interpSpinePerim(imageRegions(k).perimDistFromSpineBackbonePixels{i});
        intensityLine = imageRegions(k).intensityLines;
        y = [yi;yyi;intensityLine{i}'];
        Y2(i,:) = net(y);
        labeledSpines(imageRegions(k).spinePixelInd{i}) = max(labeledSpines(imageRegions(k).spinePixelInd{i}), + Y2(i,1));
        if Y2(i,1) > 0.5 
            spineEdges(locs(i)) = 1;
        end
    end
%     imageRegions(k).labeledSpines = labeledSpines;
    Y{k} = Y2;
    labeledPerim(imageRegions(k).ind) = labeledSpines;
    labeledSpineEdges(imageRegions(k).ind) = spineEdges;
end

% figure; imshow(labeledPerim,'InitialMagnification',300);
[row,col] = find(labeledSpineEdges);
pos = [col,row,repmat(round(1/uaa.imageInfo.umPerPixel / 2),length(col),1)];
SE = strel('disk',round(1/uaa.imageInfo.umPerPixel / 2));
labeledSpineEdgesThick = imdilate(labeledSpineEdges,SE);

% labeledSpineEdgesThick = insertShape(zeros(size(labeledSpineEdges)),'FilledCircle',pos,'Opacity',1);
% labeledSpineEdgesThick = bwmorph(labeledSpineEdges,'thicken',round(1/uaa.imageInfo.umPerPixel / 2));
% previewImage = insertShape(gather(uaa.imageAnalysis.uaa_adaptiveThreshold2{1}),'circle',pos,'color','red');
% previewImage = imoverlay(previewImage, uaa.T.DetachedSpines{uaa.currentFrame,1},'yellow');
% previewImage = imoverlay(labeledPerim,labeledSpineEdgesThick,'red');
% figure; imshow(previewImage,'InitialMagnification',300);
