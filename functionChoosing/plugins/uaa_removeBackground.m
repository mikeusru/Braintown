function [I2,BW] = uaa_removeBackground(I)
% [I2,BW] = uaa_removeBackground(I)
% UAA_REMOVEBACKGROUND removes the image background using an entropy filter
%
% Inputs: Image
% Outputs: Image, Binary Image
global uaa

nhood = ones(uaa.imageInfo.smallestFeature/uaa.imageInfo.umPerPixel + ~mod(uaa.imageInfo.smallestFeature/uaa.imageInfo.umPerPixel,2));
E = entropyfilt(I,nhood);
hf = figure('visible','off');
h = histogram(E);
val = h.Values;
edges = h.BinEdges;
delete(hf);
[pks,locs] = findpeaks(val,edges(1:end-1));
[~,locs2] = findpeaks(-val,edges(1:end-1));

[~,ind] = max(pks);
ind2 = find((locs2 - locs(ind)>0),1);
valleyAfterBackground = locs2(ind2);
level = valleyAfterBackground/max(E(:));
% BW = imextendedmax(E,mode(E(:)));
BW = im2bw(mat2gray(E),level);
I2 = I - mean(mean(I(~BW)));
I2(I2<0) = 0;
