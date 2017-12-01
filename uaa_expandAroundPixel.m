function	[aroundPixelInd,offset,shiftedAroundPixelInd] = uaa_expandAroundPixel(loc,searchZone,pixelPerimRegion)

%loc is index of pixel inside searchZone
centerPixelPositionInd = find(searchZone);
centerPixelPositionInd = centerPixelPositionInd(loc);
%offset arrays so this pixel is in the center to avoid carryover
offset = ceil(length(searchZone)/2 - centerPixelPositionInd);
aroundPixelInd = false(size(searchZone));

%keep only center pixels
centerPixelPositionInd = centerPixelPositionInd + offset;
hw = floor(pixelPerimRegion/2);
centerNonSpineInd = centerPixelPositionInd-hw : centerPixelPositionInd + hw;
aroundPixelInd(centerNonSpineInd) = true;
aroundPixelInd = circshift(aroundPixelInd,-offset); %ind needs to be offset again to match original vector structure
shiftedAroundPixelInd = zeros(size(aroundPixelInd));
shiftedAroundPixelInd(aroundPixelInd) = find(aroundPixelInd);
shiftedAroundPixelInd = circshift(shiftedAroundPixelInd, offset);
shiftedAroundPixelInd(shiftedAroundPixelInd==0) = [];