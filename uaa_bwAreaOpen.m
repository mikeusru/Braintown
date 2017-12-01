function BW = uaa_bwAreaOpen(BW)
% UAA_bwAreaOpen removes small objects from the image
%
% Inputs: Binary Image
% Outputs: Binary Image

global uaa
% BW=im2bw(I,(graythresh(I)));

smallestFeature = 2* (uaa.imageInfo.smallestFeature / uaa.imageInfo.umPerPixel) ^2;
BW = bwareaopen(BW, smallestFeature);
