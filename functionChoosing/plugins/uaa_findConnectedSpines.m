function imageRegions = uaa_findConnectedSpines(thin,BW)
% imageRegions = uaa_findConnectedSpines(thin,BW)
%note: the peak shape of true vs false spines can be a good machine
%learning feature
% global uaa


% spineMinWidth = round(.25 * 1/uaa.imageInfo.umPerPixel);
% spineMinHeight = round(.25 * 1/uaa.imageInfo.umPerPixel);

%fix problems which cause pinching perimeter
BWpadded = imdilate(BW,ones(3));
% BWpadded = imclose(BW,ones(4)); 
% BWpadded = imopen(BWpadded,ones(2));
D = double(bwdistgeodesic(BWpadded,thin));
D(~isfinite(D)) = 0;
perim = bwperim(BWpadded);
% perimInd = find(perim);
Dperim = D;
Dperim(~perim) = 0;
imageRegions = regionprops(perim,'PixelIdxList');
% 
% [PL,num] = bwlabel(perim);
% RGB = label2rgb(PL);
% figure; imshow(RGB);
%break connection at first pixel, then do bwdistgeodesic using first
%endpoint pixel value as seed
% bwDistPeakImage = false(size(thin));
for i=1:length(imageRegions)
    imageRegions(i).Image = false(size(perim));
    imageRegions(i).Image(imageRegions(i).PixelIdxList) = true;
    removeArea = false(size(perim));
    firstPixelInd = find(imageRegions(i).Image,1);
    removeArea(firstPixelInd) = 1;
    removeArea = imdilate(removeArea,ones(3));
%     imageRegions(i).PixelIdxList(1) = 0;
    imageRegions(i).Image(removeArea) = 0;
    endPts = bwmorph(imageRegions(i).Image,'endpoints');
    imageRegions(i).x = bwdistgeodesic(imageRegions(i).Image,find(endPts,1));
    y_idx = [Dperim(imageRegions(i).Image),find(imageRegions(i).Image)];
    [~,ind ] = sort(imageRegions(i).x(isfinite(imageRegions(i).x)));
    y_idx = y_idx(ind,:);
    imageRegions(i).y = y_idx(:,1);
    imageRegions(i).ind = y_idx(:,2);
%     pixelValues(:,1) = movmean(pixelValues(:,1),3);
%     if size(y_idx,1) > 3
%         [~,locs] = findpeaks(y_idx(:,1),'MinPeakWidth',spineMinWidth,'MinPeakProminence',spineMinHeight);
%         [~,locs] = findpeaks(pixelValues(:,1));
%         peakLocations = y_idx(locs,2);
%         bwDistPeakImage(peakLocations) = true;
        %     O = imoverlay(BW,bwDistPeakImage,'red');
        %     imshow(O)
%     end
end    

% O = imoverlay(BW,bwDistPeakImage,'red');
% figure; imshow(O)
% 
% [pks,locs] = findpeaks(D(perimInd));
% pksImg = false(size(I));
% pksImg(perimInd(locs)) = true;
% 
% IO = imoverlay(I,pksImg,'red');
% figure; imshow(IO);