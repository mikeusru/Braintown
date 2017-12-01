function [looseSpineStats,BWnoBlobs,BWBlobs] = uaa_findBlobsWithSNR(BW,I,spineSearchZone)
% [looseSpineStats,BWnoBlobs,BWBlobs] = uaa_findBlobsWithSNR(BW,I,spineSearchZone)
%find blobs
%detached spines
% expect spine blobs to be 0.25 - 2 µm^2
global uaa
spineMax = round((2 * 1/uaa.imageInfo.umPerPixel)^2);
spineMin = round((.25 * 1/uaa.imageInfo.umPerPixel)^2);

% 
% I = gpuArray(I);
% I2 = I;
% I2(~spineSearchZone) = 0;
% % figure; imshow(I2);
% %use 10µm neighborhood for adaptive thresholding
% T = adaptthresh(gather(I2),'NeighborhoodSize',2*round(5*1/uaa.imageInfo.umPerPixel)+1);
% BW2 = imbinarize(gather(I2),T);
% % figure; imshow(BW2);
% % figure; imshow(BW);

BW(~spineSearchZone) = 0;
I(~spineSearchZone) = 0;



%avoid perimeter pinching
BWpadded = bwmorph(BW,'majority');

BWpadded = bwmorph(BWpadded ,'open');
BWpadded = bwmorph(BWpadded ,'close');
BWpadded = bwmorph(BWpadded ,'open'); %does this mess things up? testing
% endpts = bwmorph(BWpadded,'endpoints');
% locations = bwmorph(BWpadded & ~endpts, 'shrink', inf);
% [r,c] = find(locations);
% locations = [r,c];
% BWpadded = imfill(endpts,locations,4);
branchpts = bwmorph(BWpadded,'branchpoints');
branchpts = bwmorph(branchpts,'diag');
BWpadded = bwmorph(branchpts,'thicken',1);
% BWpadded = bwmorph(BWpadded,'diag');

%% Show result of smoothing 
% figure(100);
% ax = gca;
% imshowpair(BW,BWpadded,'montage', 'parent', ax);
%%

BWnoBlobs = bwareaopen(BWpadded,spineMax);
looseSpines = BWpadded &~BWnoBlobs;
looseSpines = bwareaopen(looseSpines,spineMin);

% figure; imshow(looseSpines);

%figure out whether to use I or a different one for this
noise = im2double(I);
noise(BWpadded) = nan;
% noise = noise(:);

stats = regionprops(looseSpines,'PixelIdxList','BoundingBox');

BWBlobs = looseSpines;
looseSpineStats = stats;
uaa.T.DetachedSpines{uaa.currentFrame,1} = BWBlobs;
uaa.T.AttachedSpines{uaa.currentFrame,1} = BWnoBlobs;

if isempty(stats)
    return
elseif length(stats) > 2
    BWBlobs = zeros(size(I));
    for i=1:length(stats)
        bbox = [stats(i).BoundingBox(1) - stats(i).BoundingBox(3)/2, stats(i).BoundingBox(2) - stats(i).BoundingBox(4)/2, stats(i).BoundingBox(3)*2, stats(i).BoundingBox(4)*2];
        y = imcrop(noise,bbox);
        y = y(~isnan(y));
        stats(i).snr = snr(I(stats(i).PixelIdxList),y(1:length(stats(i).PixelIdxList)));
    end
    
    %% separate blobs based on SRN.
    % this part needs clustering for bigger images and maybe something else for
    % smaller ones
    idx = kmeans([stats.snr]',2);
    % figure; scatter(1:length(stats),[stats.snr],idx * 20);
    if mean([stats(idx==1).snr]) > mean([stats(idx==2).snr])
        idx = idx==1;
    else
        idx = idx==2;
    end
    
    looseSpineStats = stats(idx);
    
    for i=1:length(looseSpineStats)
        BWBlobs(looseSpineStats(i).PixelIdxList) = 1;
    end
    BWBlobs = bwlabel(BWBlobs);
end
uaa.T.DetachedSpines{uaa.currentFrame,1} = BWBlobs;
uaa.T.AttachedSpines{uaa.currentFrame,1} = BWnoBlobs;
return
%display results
% figure; imshow(I);
looseSpineBW = false(size(I));
looseSpineBW(vertcat(stats(idx==1).PixelIdxList)) = true;
mask = looseSpineBW;
IO = imoverlay(I,mask,'red');
looseSpineBW = false(size(I));
looseSpineBW(vertcat(stats(idx==2).PixelIdxList)) = true;
mask = looseSpineBW;
IO = imoverlay(IO,mask,'blue');
figure; imshow(IO);
% for i=1:length(stats(idx==1))
