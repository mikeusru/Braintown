function [singleSpinePerimDistPixels, pixelPosition, ind, ignore, spineTipInd, loc] = uaa_identifySpineInBox(imSize,boundingBox,pD,pixelPosition,ignoreSpinesHere)
%% [singleSpinePerimDistPixels, pixelPosition, ind] = uaa_identifySpineInBox(imSize,boundingBox,pD,pixelPosition,ignoreSpinesHere)
%
% function finds the relevant spine distance measurements from the perimeter
% distance pD using the bounding box boundingBox
% imSize is the image mxn image size
% boundingBox is the 4-element position vector
% pD is a vector of pixel distances from the dendrite backbone
% pixelPosition is a vector with the same size as pD indicating the relative
% position of each pixel in the image of size imSize
% ignoreSpinesHere is a logical matrix indicating pixels which, if
% overlapping with bounding box, mean the bounding box shouldn't be
% counted. this occurs because the spine is either on the border or
% detached.
%
% Outputs:
% singleSpinePerimDistPixels is a vector of spine pixel distances from the
% dendrite backbone
% pixelPositon (output) is shortened vector of pixel position values
% ind is the index of the spine pixels relative to the original pD and
% pixelPosition values
% ignore indicates if the spine overlaps the ignoreSpinesHere box
% spineTipInd is the index of the spine pixels identifying the tip of the
% spine. These would accurately describe the central position of the spine
global uaa

%capture 5µm along perimeter for spine
pixelPerimRegion = round(1/uaa.imageInfo.umPerPixel * 5);
%capture 1µm to get spine tip
pixelTipPerimRegion = round(1/uaa.imageInfo.umPerPixel * 1);

ignore = false;

%identify pixels in bounding box
[row,col] = ind2sub(imSize,pixelPosition);
xv = [boundingBox(1), boundingBox(1) + boundingBox(3)];
xv = [xv,flip(xv),boundingBox(1)];
yv = [boundingBox(2), boundingBox(2) + boundingBox(4)];
yv = [yv;yv];
yv=[yv(:)',boundingBox(2)];

%identify pixels in box
ind = inpolygon(col,row,xv,yv);
spineTipInd = false(size(ind));
%Center on pixel furthest away from dendrite
[~,loc] = max(pD(ind));
centerPixelPositionInd = find(ind);
centerPixelPositionInd = centerPixelPositionInd(loc);

if length(pixelPosition) < pixelPerimRegion || isempty(find(ind,1))
    singleSpinePerimDistPixels = [];
    pixelPosition = [];
    return
end

%offset arrays so this pixel is in the center to avoid carryover
offset = round(length(pixelPosition)/2 - centerPixelPositionInd);
pixelPosition = circshift(pixelPosition,offset);
pD = circshift(pD,offset);
ind(:) = false;

% ind = circshift(ind,offset);

%keep only center pixels
centerPixelPositionInd = centerPixelPositionInd + offset;
hw = floor(pixelPerimRegion/2);
htw = floor(pixelTipPerimRegion/2);
centerSpineInd = centerPixelPositionInd-hw : centerPixelPositionInd + hw;
tipSpineInd = centerPixelPositionInd-htw : centerPixelPositionInd + htw;
singleSpinePerimDistPixels = pD(centerSpineInd);
pixelPosition = pixelPosition(centerSpineInd);
ind(centerSpineInd) = true;
spineTipInd(tipSpineInd) = true;
ind = circshift(ind,-offset); %ind needs to be offset again to match original vector structure
spineTipInd = circshift(spineTipInd,-offset); 


%check if boundingBox hits ignore area
[r,c] = find(ignoreSpinesHere);
edgeInd = inpolygon(c,r,xv,yv);
if ~isempty(find(edgeInd,1))
%     singleSpinePerimDistPixels = [];
%     pixelPosition = [];
%     ind = false(size(pD));
    ignore = true;
end