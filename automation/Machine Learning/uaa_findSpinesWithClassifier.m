function [xy,cind,xyBBox] = uaa_findSpinesWithClassifier(I,categoryClassifier)

global uaa

%find places to check for spines
%sliding windows takes a long time...
centroids = uaa_findSpineLocationsToTest(I);
boxWidth = 50;
boxHeight = 50;
siz = size(centroids,1);
boundingBoxes = [[centroids(:,1) - boxWidth/2, centroids(:,2)- boxHeight/2], repmat([boxWidth, boxHeight],siz,1)];


% imWidth = size(I,2);
% imHeight = size(I,1);

% stepSize = 10;

% boundingBoxes = uaa_createSlidingWindowRectangles(imWidth,imHeight,boxWidth,boxHeight,stepSize);

y = zeros(size(boundingBoxes,1),1);
% RGB = I;
% xy = zeros(1,4);
ind = [];
c = 1-gray;
cind = zeros(size(boundingBoxes,1),3);
scores = zeros(size(boundingBoxes,1),2);
for i=1:size(boundingBoxes,1)
    Ic = imcrop(I,boundingBoxes(i,:));
    Ic = uaa_readAndPreProcessImageForClassifier(Ic);
    imageFeatures = activations(uaa.ml.convnet, Ic, uaa.ml.featureLayer);
    [label, scores(i,:)] = predict(categoryClassifier,imageFeatures);
    labelIdx = strfind(categoryClassifier.ClassNames,label);
    y(i) = labelIdx;
    if labelIdx==2
%         pos = [slidingWindows(i,1) + boxWidth/2, slidingWindows(i,2) + boxHeight/2, 2];
        cind(i,:) = c(ceil(((1+scores(i,2)) * 64)),:);
%         disp(c(cind,:));
        ind = [ind, i];
%         RGB = insertShape(RGB,'Circle',pos,'LineWidth',1,'Color',c(cind,:));
    end
end

xy = boundingBoxes(ind,:);
[xy,selectedScore,ind2] = selectStrongestBbox(xy,scores(ind,2),'OverlapThreshold',.2);
% disp(scores(ind,2)');
% disp(selectedScore');
xyBBox = xy;
xy = [xy(:,1) + boxWidth/2, xy(:,2) + boxHeight/2];
cind = cind(ind,:);
cind = cind(ind2,:);
return
figure;
imagesc(I);
hold on
scatter(xy(:,1),xy(:,2),50,cind,'filled');
hold off
% figure;
% imshowpair(I,RGB,'montage')

