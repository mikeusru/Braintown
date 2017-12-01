function I = uaa_gaussfilt(I)
% I = uaa_gaussfilt(I)
% UAA_GAUSSFILT runs a gaussian filter on the image using the smallest
% relevant pixel size
%
% Inputs: Image
% Outputs: Image

global uaa
sig = uaa.imageInfo.smallestFeature / uaa.imageInfo.umPerPixel / 4;
I=imgaussfilt(I,sig);
