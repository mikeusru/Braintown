function [imageRegions,Dperim] = uaa_findPerimDistFromDendrite(thin,BW)
% [imageRegions,Dperim] = uaa_findPerimDistFromDendrite(thin,BW)
%note: the peak shape of true vs false spines can be a good machine
%learning feature
% global uaa
global uaa
D = double(bwdistgeodesic(BW,thin));
D(~isfinite(D)) = 0;
perim = bwperim(BW);
Dperim = D;
Dperim(~perim) = 0;
imageRegions = regionprops(perim,'PixelIdxList');
for i=1:length(imageRegions)
    imageRegions(i).Image = false(size(perim));
    imageRegions(i).Image(imageRegions(i).PixelIdxList) = true;
    removeArea = false(size(perim));
    firstPixelInd = find(imageRegions(i).Image,1);
    removeArea(firstPixelInd) = 1;
    SE = ones(3);
    removeArea = imdilate(removeArea,SE);
%     uaa.test.removeArea = removeArea;
    snippedImage = imageRegions(i).Image;
    snippedImage(removeArea) = 0;
    endPts = bwmorph(snippedImage,'endpoints');
%     totalDist = bwdistgeodesic(imageRegions(i).Image,find(endPts,1));
    imageRegions(i).x = bwdistgeodesic(snippedImage,find(endPts,1));
    imageRegions(i).x = imageRegions(i).x + 1;
%     disp(max((isfinite(totalDist(removeArea)))));
%     imageRegions(i).x(~removeArea) = imageRegions(i).x(~removeArea) + max(max(totalDist(removeArea)));
%     imageRegions(i).x(removeArea) = totalDist(removeArea);
    y_idx = [Dperim(snippedImage),find(snippedImage)];
    [~,ind ] = sort(imageRegions(i).x(isfinite(imageRegions(i).x)));
    y_idx = y_idx(ind,:);
    imageRegions(i).y = y_idx(:,1);
    imageRegions(i).ind = y_idx(:,2);
end    

% uaa.temp.imageRegions = imageRegions;
uaa.T.PerimRegions{uaa.currentFrame,1} = imageRegions;