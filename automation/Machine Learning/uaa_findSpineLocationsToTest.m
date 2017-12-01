function centroids = uaa_findSpineLocationsToTest(I)

% BW = imbinarize(I,'adaptive');
%% Binarize Image
I2 = adapthisteq(I);
I2 = gpuArray(im2uint8(I2));
I2 = medfilt2(I2);
T = adaptthresh(gather(I2),'NeighborhoodSize',2*floor(size(I)/3)+1); %this maybe should be standardized better
BW = imbinarize(gather(I2),T);
% BW = imbinarize(gather(I2));

%%
BW = imbinarize(gather(I2),'adaptive','sensitivity',.9);
se = strel('disk',3);
% I2 = imopen(I2,se);
I2(~BW) = 0;
% figure; imagesc(I2);
BW2 = imregionalmax(I2);
stats = regionprops(BW2,'Centroid');
centroids = vertcat(stats.Centroid);
return
% BW2 = bwmorph(BW2,'shrink',inf);
% figure; imagesc(BW2);
% stats = regionprops(BW);

[~,ind] = sort([stats.Area],'descend');
stats = stats(ind);
minArea = stats(11).Area;
BW = bwareaopen(BW,minArea);

% stats = stats(1:10);
boundingBoxes = vertcat(stats.BoundingBox);
I2 = medfilt2(I);
BW = imregionalmax(I2);

