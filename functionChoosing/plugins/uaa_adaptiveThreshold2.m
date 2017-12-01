function [BW, I2] = uaa_adaptiveThreshold2(I)
% [BW, I2] = uaa_adaptiveThreshold2(I)
global uaa
% neighborhood set to 10µm
% I = uaa.T.Image{uaa.currentFrame}; %test

N = round(10 * 1/uaa.imageInfo.umPerPixel);
N = N + 1 - mod(N,2); %if even, add 1 to neighborhood to make it odd
% I2 = gpuArray(im2double(I));

I2 = mat2gray(im2double(I));
% I2 = imresize(I2,4); %standardize this

[level, EM] = multithresh(I2,2);
BWgeneral = imbinarize(I2,level(1)); %do this first to remove obviously low background pixels

% m = min(15,round(1/uaa.imageInfo.umPerPixel));

I2 = medfilt2(I2);

%took this out... maybe it's still necessary?
% I2 = gpuArray(adapthisteq(gather(I2)));


I2 = I2 - mean(I2(~BWgeneral));
% figure; imagesc(BW);

% I2(~BW) = 0;
T = adaptthresh(gather(I2),'NeighborhoodSize',[N,N]); 
BW = imbinarize(gather(I2),T);
BW(~BWgeneral) = 0;

%fill holes smaller than 0.5µm^2
artifactHoleArea = round((0.5 * 1/uaa.imageInfo.umPerPixel)^2);
BW_holes = imfill(BW,'holes');
BW_holes(BW) = 0;
BW_holes = BW_holes & ~bwareaopen(BW_holes,artifactHoleArea);
BW = BW | BW_holes;
I2(~BW) = 0;

uaa.imageAnalysis.uaa_adaptiveThreshold2{1} = I2;