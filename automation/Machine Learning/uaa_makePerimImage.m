function perimImage = uaa_makePerimImage(imSize,perimDistPixels,pixelPosition)
%make image of upright spine (or non-spine region)
global uaa
if iscell(perimDistPixels)
    perimCells = {};
    i_ind = 1 : size(perimDistPixels);
    returnCells = true;
else
    i_ind = 1;
    pixelPosition = {pixelPosition};
    perimDistPixels = {perimDistPixels};
    perimCells = {};
    returnCells = false;
end
ii=1;
for i = i_ind
    %spine Box Size (for perim image) is 3x3µm
    spineBoxSize = round(1/uaa.imageInfo.umPerPixel * 3);
    
    perimImage = zeros(imSize);
    perimImage(pixelPosition{i}) = perimDistPixels{i};
    BWpixels = false(imSize);
    BWpixels(pixelPosition{i}) = true;
%     CC = bwconncomp(perimImage,8);
%     stats = regionprops(CC,'BoundingBox');
    %crop image
    [rc,cc] = find(perimImage); 
    rc = min(rc) : max(rc);
    cc = min(cc) : max(cc); 
    perimImage = perimImage(rc,cc);
    BWpixels = BWpixels(rc,cc);
%     perimImage = imcrop(perimImage,stats.BoundingBox);
    [endY,endX] = find(bwmorph(BWpixels,'endpoints'));
    if length(endY) ~=2
        perimImage = [];
        continue
    end
    angl = rad2deg(atan(diff(endY)/diff(endX)));
    [~,maxInd] = max(perimImage(:));
    [maxY, maxX] = ind2sub(size(perimImage),maxInd);
%     negDirection = mean([maxY;maxX]) - mean([endY;endX]);
    negDirection = mean(endY) - maxY;
    if negDirection == 0
        perimImage = [];
        continue
    end
    angl = angl * (negDirection > 0) + (180 + angl) * (negDirection < 0);
    perimImage = imrotate(perimImage,angl);
    siz = size(perimImage);
    padSizePre = [ceil((spineBoxSize-siz(1))/2),ceil((spineBoxSize-siz(2))/2)];
    padSizePost = [floor((spineBoxSize-siz(1))/2),floor((spineBoxSize-siz(2))/2)];
    if padSizePre(1) + padSizePost(1) < 0
        perimImage = perimImage(abs(padSizePre(1))+1 :end - abs(padSizePost(1)),:);
        padSizePre(1) = 0;
        padSizePost(1) = 0;
    end
    if padSizePre(2) + padSizePost(2) < 0
        perimImage = perimImage(:,abs(padSizePre(2))+1 :end - abs(padSizePost(2)));
        padSizePre(2) = 0;
        padSizePost(2) = 0;
    end
    
    perimImage = padarray(perimImage,padSizePre,0,'pre');
    perimImage = padarray(perimImage,padSizePost,0,'post');
    perimCells{ii,1} = perimImage;
    ii = ii + 1;
end

if returnCells
    perimImage = perimCells;
end