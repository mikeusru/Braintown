function [thin,spineSearchZone] = uaa_findDendriteUsingEndpoints(BW)
% [thin,spineSearchZone] = uaa_findDendriteUsingEndpoints(BW)
% Dendrite extraction adapted from Cheng et al, 2007
% Inputs: 
% (BW) - Binary mask of dendrite
%
% Outputs: 
% (thin) - Binary mask of dendrite spine backbone
% (spineSearchZone) - Binary mask of region which may possibly
%   include dendritic spines
global uaa
%M is max spine length
% spines are max 3µm long and dendrites are max 2µm wide
M = round(4 * 1/uaa.imageInfo.umPerPixel);

thin = bwmorph(BW,'thin',inf);

%fix small loops that are < 0.5µm^2
artifactHoleArea = round((0.5 * 1/uaa.imageInfo.umPerPixel)^2);
holes = imfill(thin,'holes');
holes(thin) = 0;
holes = holes & ~bwareaopen(holes,artifactHoleArea);
thin = thin | holes;
thin = bwmorph(thin,'thin','inf');

thin = bwareaopen(thin,M); %preemptively remove all segments shorter than max spine length

% figure; imagesc(thin);
stats = regionprops(thin,'Image','BoundingBox','PixelList');

%use some original image for this instead...
BWborder = uaa_findImageBorder(uaa.fxnChoosing.tbl.OutputData{1},0.5);
% a parfor loop can be used here to analyze all regions in parallel
if isempty(gcp('nocreate'))
    parpool('local');
end
ls = length(stats);
thin2 = {stats.Image};
ColInd = cell(ls,1);
RowInd = cell(ls,1);
statsImage = {stats.Image};
PixelList = {stats.PixelList};
parfor k = 1 : ls
    %%

    fprintf('Thinning Dendrite Segment #%d', k);
    BWBlank = false(size(statsImage{k}));
    RowInd{k} = min(PixelList{k}(:,2)) : max(PixelList{k}(:,2));
    ColInd{k} = min(PixelList{k}(:,1)) : max(PixelList{k}(:,1));
    miniBorder = BWborder(RowInd{k},ColInd{k});
    for m=1:M
        removedSegments = BWBlank;
        for j=1:m
            endpts = bwmorph(thin2{k},'endpoints');
            endpts(miniBorder) = false;
            removedSegments(endpts) = true;
            thin2{k}(removedSegments) = false;
        end
        restoreSegments = bwareafilt(removedSegments,[m,m]);
        restoreSegments(miniBorder) = restoreSegments(miniBorder) | removedSegments(miniBorder);
        thin2{k}(restoreSegments) = true;
    end
%     toc
    %%
    % correct branchpoint kinks in backbone
    branchp = bwmorph(statsImage{k},'branchpoints');
    branchp = imdilate(branchp, ones(round(M/4)));
    perim = bwperim(branchp);
    kinks = perim & thin2{k};
    statsBranch = regionprops(branchp,'PixelIdxList');
    
    kinkSmoothBoxes = false(size(thin2{k}));
    kinkSmooth = kinkSmoothBoxes;
    for i=1:length(statsBranch)
        if sum(sum(kinks(statsBranch(i).PixelIdxList))) ==2 %if there are two pixels, connect them
            ind1 = statsBranch(i).PixelIdxList(kinks(statsBranch(i).PixelIdxList));
            [X,Y] = ind2sub(size(thin2{k}),ind1);
            kinkSmooth = uaa_drawConnectingLine(kinkSmooth,X(1),Y(1),X(2),Y(2));
            kinkSmoothBoxes(statsBranch(i).PixelIdxList) = true;
        end
    end
    thin2{k}(kinkSmoothBoxes) = 0;
    thin2{k}(kinkSmooth) = true;
end

for k = 1:length(stats)
    thin(RowInd{k}, ColInd{k}) = thin2{k};
end

%% expand dendrite
% SE = strel('disk',M + round(d/2));
SE = strel('disk',M);

spineSearchZone = imdilate(thin,SE);
%%
uaa.T.thin{uaa.currentFrame,1} = thin;
uaa.T.spineSearchZone{uaa.currentFrame,1} = spineSearchZone;
   

end


