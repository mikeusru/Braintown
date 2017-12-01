function [perimDistFromSpineBackbone, pDImage, DistImage, paths_thinned] = uaa_calculatePerimDistFromSpineBackbone(pixelPosition, BW, thin, peakPixelInd)
% function perimDistFromSpineBackbone = uaa_calculatePerimDistFromSpineBackbone(pixelPosition, BW, thin, peakPixelInd)
% set perimeter pixels to distance from central line
% inputs: 
% pixelPosition (position of perimeter pixels)
% BW (entire binary image)
% thin (dendrite skeleton)
% peakPixelInd (index of central pixel)

if peakPixelInd==0
    perimDistFromSpineBackbone = [];
    pDImage = [];
    DistImage = [];
    paths_thinned = [];
    return
end


%need to be quasi-euclidean to do full distance between points
start = peakPixelInd;
D1 = bwdistgeodesic(BW,pixelPosition(start),'quasi-euclidean');
closestThinPoint = D1;
closestThinPoint(isnan(closestThinPoint) | ~thin) = inf;
[ind] = find(closestThinPoint == min(closestThinPoint(:)),1);
D = D1 + bwdistgeodesic(BW,ind,'quasi-euclidean'); 
D = round(D * 8) / 8;
D(isnan(D)) = inf;
paths = imregionalmin(D);
paths_thinned = bwmorph(paths, 'thin', inf);

perimImg = false(size(BW));
perimImg(pixelPosition) = true;
DistImage = bwdistgeodesic(BW,paths_thinned);
BWdistFromSpineBackbone = DistImage .* perimImg;
% perimDistFromSpineBackbone = false(size(BW));
% perimDistFromSpineBackbone(pixelPosition) = BWdistFromSpineBackbone(pixelPosition);
perimDistFromSpineBackbone = BWdistFromSpineBackbone(pixelPosition);

%create image for preview
pDImage = nan(size(BWdistFromSpineBackbone));
pDImage(pixelPosition) = perimDistFromSpineBackbone;
[rn,cn] = find(~isnan(pDImage));
pDImage = pDImage(min(rn):max(rn),min(cn):max(cn));
% figure; imagesc(pDImage);
