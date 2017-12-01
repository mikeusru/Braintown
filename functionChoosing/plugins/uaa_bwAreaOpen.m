function BW = uaa_bwAreaOpen(BW)
% BW = uaa_bwAreaOpen(BW)
% UAA_bwAreaOpen removes small objects from the image
%
% Inputs: Binary Image
% Outputs: Binary Image

global uaa
% BW=im2bw(I,(graythresh(I)));

smallestFeature = uaa.imageInfo.smallestFeature / uaa.imageInfo.umPerPixel;
BW = bwareaopen(BW, smallestFeature);
