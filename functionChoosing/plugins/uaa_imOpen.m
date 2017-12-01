function I = uaa_imOpen(I)
% I = uaa_imOpen(I)
% UAA_IMOPEN morphologically opens the image
%
% Inputs: Image
% Outputs: Image
global uaa
diskSize = uaa.imageInfo.smallestFeature / uaa.imageInfo.umPerPixel / 2;

SE=strel('disk',diskSize);
I = imopen(I, SE);
