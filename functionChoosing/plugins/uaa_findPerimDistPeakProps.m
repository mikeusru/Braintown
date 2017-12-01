function tempOutput = uaa_findPerimDistPeakProps(imageRegions,BW,thin)
% tempOutput = uaa_findPerimDistPeakProps(imageRegions,BW,thin)
global uaa

pixelPerimRegion = round(1/uaa.imageInfo.umPerPixel * 5);
pixelPerimRegion = pixelPerimRegion + 1 - mod(pixelPerimRegion,2); %add 1 if even value
if isempty(gcp('nocreate'))
    parpool('local');
end
allpDImages = cell(length(imageRegions),1);
allpDImagesFull = cell(length(imageRegions),1);
featureExtractors = uaa.featureExtractors;
I = uaa.fxnChoosing.tbl.OutputData{1};
umPerPixel = uaa.imageInfo.umPerPixel;
for k = 1:size(imageRegions,1)
    fprintf('\nk = %d\n',k);
    
    pD = imageRegions(k).y;
    pD_peaks = bwmorph(imregionalmax(pD),'shrink',inf);
    if length(pD) < pixelPerimRegion
        locs = [];
    else
        locs = find(pD_peaks);
    end
    imageRegions(k).peakLocations = locs;
    searchZone = true(size(pD));
%     tempReg = imageRegions(k);
    ind = imageRegions(k).ind;
    perimDistFromDendritePixels = cell(size(locs));
    perimDistFromSpineBackbonePixels = perimDistFromDendritePixels;
    intensityLines = perimDistFromDendritePixels;
    pixelInd = cell(size(locs));
    pDImages = cell(length(locs),length(imageRegions));
    pDImagesFull = cell(length(locs),length(imageRegions));
    parfor i=1:length(locs)
        fprintf('i = %d, ',i);
        [~,~,shiftedAroundPixelInd] = uaa_expandAroundPixel(locs(i),searchZone,pixelPerimRegion);
        if featureExtractors.pdfsb
            [pD_SpineBackbone, pDImage, pDImageFull, thinPath] = uaa_calculatePerimDistFromSpineBackbone(ind(shiftedAroundPixelInd), BW, thin, round(length(shiftedAroundPixelInd)/2));
            perimDistFromSpineBackbonePixels{i} = pD_SpineBackbone;
            pDImages{i} = pDImage;
            pDImagesFull{i} = pDImageFull;
        end
        if featureExtractors.sttdbil
            singleIntensityLine = uaa_calculateSpineIntensityLine(locs(i),thinPath,I,umPerPixel);
            intensityLines{i} = singleIntensityLine;
        end
        pD_Dendrite = pD(shiftedAroundPixelInd);
        perimDistFromDendritePixels{i} = pD_Dendrite;
        pixelInd{i} = shiftedAroundPixelInd;
    end
    imageRegions(k).spinePixelInd = pixelInd;
    imageRegions(k).perimDistFromDendritePixels = perimDistFromDendritePixels;
    if featureExtractors.pdfsb
        allpDImages{k} = pDImages;
        imageRegions(k).perimDistFromSpineBackbonePixels = perimDistFromSpineBackbonePixels;
        allpDImagesFull{k} = pDImagesFull;
    end
    if featureExtractors.sttdbil
        imageRegions(k).intensityLines = intensityLines;
    end
end
uaa.T.PerimRegions{uaa.currentFrame,1} = imageRegions;
tempOutput = 0;
% preview images
return
allpDImages = [allpDImages,allpDImagesFull];
allpDImages = allpDImages(~cellfun(@isempty,allpDImages));
allpDImages = [allpDImages{:}];
allpDImages = allpDImages(:);
allpDImages = allpDImages(~cellfun(@isempty,allpDImages));
% X = randperm(length(allpDImages),10);
% figure; imdisp(allpDImages(X));
figure; imdisp(allpDImages(1:min(round(length(allpDImages)/2),30)));
figure; imdisp(allpDImages(round(length(allpDImages)/2):min(length(allpDImages),60)))

% delete(gcp('nocreate'));
% 
% figure; hold on;
% for i=1:length(imageRegions(k).perimDistFromDendritePixels)
%     plot(imageRegions(k).perimDistFromDendritePixels{i});
% end
% figure; hold on;
% for i=1:length(imageRegions(k).perimDistFromSpineBackbonePixels)
%     plot(imageRegions(k).perimDistFromSpineBackbonePixels{i});
% end
