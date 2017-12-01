function uaa_cropSpinesForTrain(posBoxSize,negBoxSize,ind)
% crop out image regions based on given spine coordinates
%ind is an optional numerical index which idicates which individual files
%to calculate
global uaa

if nargin<3
    ind = 1:size(uaa.T,1);

    SpineImages = cell(size(uaa.T,1),1);
    BoundingBoxes = cell(size(uaa.T,1),1);
    NoSpineImages = cell(size(uaa.T,1),1);
    uaa.T.SpineImages = SpineImages;
    uaa.T.BoundingBoxes = BoundingBoxes;
    uaa.T.NoSpineImages = NoSpineImages;


end
ind = ind(:)';

stepSize = round(posBoxSize / 3);
% pixel distance between boxes for sliding window algorithm

% add spines to dataset
% if ~sum(strcmp('SpineImages',get(uaa.T,'VarNames')))
% end


% create bounding box ROIs

for i=ind
    for j=1:size(uaa.T.SpineCoordinates{i},1)
        rect = [uaa.T.SpineCoordinates{i}(j,1) - posBoxSize/2,uaa.T.SpineCoordinates{i}(j,2) - posBoxSize/2, posBoxSize, posBoxSize];
        uaa.T.BoundingBoxes{i}{j} = rect;
        Ispine = imcrop(uaa_getCurrentImageFrame(i),rect);
        uaa.T.SpineImages{i}{j}=Ispine;
    end
end

% create negative training examples from remaining image set using sliding
% windows
for i=ind
    slidingWindows = uaa_createSlidingWindowRectangles(size(uaa_getCurrentImageFrame(i),2),size(uaa_getCurrentImageFrame(i),1),negBoxSize,negBoxSize,stepSize);
    ind2 = true(size(slidingWindows,1),1);
    for j=1:length(uaa.T.BoundingBoxes{i})
        % remove rectangles that overlap w/ spine images
        area = rectint(slidingWindows,uaa.T.BoundingBoxes{i}{j});
        ind2(area>0) = false;
    end
    slidingWindows = slidingWindows(ind2,:);
    for k = 1:size(slidingWindows,1)
        NoSpineImg = imcrop(uaa_getCurrentImageFrame(i),slidingWindows(k,:));
        uaa.T.NoSpineImages{i}{k} = NoSpineImg;
    end
end
nPos = cellfun(@length,uaa.T.SpineImages(ind,:),'UniformOutput',false);
nPos = sum([nPos{:}]);
nNeg = cellfun(@length,uaa.T.NoSpineImages(ind,:),'UniformOutput',false);
nNeg = sum([nNeg{:}]);

disp([num2str(nPos), ' Positive and ', num2str(nNeg), ' Negative Training Examples Created']);



% % plot boxes to image
% figure; imagesc(uaa.T.Image{i});
% hold on
% for q=1:size(slidingWindows,1)
%     rectangle('Position',slidingWindows(q,:),'EdgeColor',rand(1,3));
% end
% for r = 1:length(uaa.T.BoundingBoxes{i})
%     
% end
% hold off