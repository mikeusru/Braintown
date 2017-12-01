function [BW, Istack2] = uaa_adaptiveThresholdForZstack(Istack)
% [BW, Istack2] = uaa_adaptiveThresholdForZstack(Istack)
global uaa

if nargin<1
    Istack = uaa_getAllImageFrames;
end
% neighborhood set to 10µm

N = round(10 * 1/uaa.imageInfo.umPerPixel);
N = N + 1 - mod(N,2); %if even, add 1 to neighborhood to make it odd

fprintf('%s\n','Depth Intensity Correction...');
Istack = uaa_depthIntensityCorrection(Istack);

fprintf('%s\n','Global Threshold Computation...');
[counts,~] = cellfun(@imhist, Istack,'UniformOutput',false);
counts = sum([counts{:}],2);
TGeneral = otsuthresh(counts);

%standardize this
fprintf('%s\n','Resizing Images...');
Istack2 = cellfun(@(x) imresize(x,4),Istack,'UniformOutput',false);
fprintf('%s\n','Calculating Binary Images...');
BWgeneral = cellfun(@(x) imbinarize(x,TGeneral*.2),Istack2,'UniformOutput',false);
fprintf('%s\n','2D Median Filtering...');
Istack2 = cellfun(@medfilt2,Istack2,'UniformOutput',false);

%not sure if this is necessary
Istack2 = cellfun(@(x,y) x - mean(x(~y)),Istack2,BWgeneral,'UniformOutput',false);

fprintf('%s\n','Adaptive Threshold Binarization...');
T = cellfun(@(x) adaptthresh(x,'NeighborhoodSize',[N,N]),Istack2,'UniformOutput',false); 
BW = cellfun(@imbinarize,Istack2,T,'UniformOutput',false);
BW = cellfun(@(x,y) x.*y, BW, BWgeneral,'UniformOutput',false);

%fill holes smaller than 0.5µm^2
fprintf('%s\n','Filling In Artifact Holes...');
artifactHoleArea = round((0.5 * 1/uaa.imageInfo.umPerPixel)^2);
BW_holes = cellfun(@(x) imfill(x,'holes').*~x, BW, 'UniformOutput', false);
BW_holes = cellfun(@(x) x & ~bwareaopen(x,artifactHoleArea), BW_holes, 'UniformOutput', false);
BW = cellfun(@(x,y) x | y, BW, BW_holes,'UniformOutput', false);

fprintf('%s\n','Binary Mask Filtering...');
Istack2 = cellfun(@(x,y) x.*y, Istack2, BW, 'UniformOutput', false);
fprintf('%s\n\n','Adaptive Thresholding Done');

% uaa.imageAnalysis.uaa_adaptiveThreshold2{1} = I2;


