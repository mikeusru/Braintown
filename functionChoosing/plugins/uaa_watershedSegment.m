function [segmentedImage,fullImage] = uaa_watershedSegment(I,BW,BWdendrite)
% [segmentedImage,fullImage] = uaa_watershedSegment(I,BW,BWdendrite)
% UAA_watershedSegment finds dendritic spines using watershed segmentation
%
% Inputs: Original Image, Spines Only Binary Image, Dendrite Binary Image
% Outputs: Segmented Image, Full Image

global uaa

imSize = size(I);
I2 = I;
I2(~BW) = 0;
% I2(BWdendrite) = 0;
% mask_em = imextendedmax(I2,100);
% mask_em = imfill(mask_em, 'holes');
% mask_em = bwmorph(mask_em,'erode');
mask_em = imregionalmax(I2);
mask_em = bwmorph(mask_em,'shrink',inf);

I_eq_c = imcomplement(I);
I_mod = imimposemin(I_eq_c, ~BW | mask_em);
L = watershed(I_mod);
segmentedImage = label2rgb(L);
Lo=imdilate(~L,ones(round(imSize(1:2)/150))); %make sure lines are visible
fullImage = imoverlay(I, Lo, [1 0 0]);
