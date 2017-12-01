function BWborder = uaa_findImageBorder(I,ratio)
%% BWborder = uaa_findImageBorder(I)
% creates binary image BWborder where border pixels are true. border is 1µm
% or 1/4 of original image, whichever is smaller
% I is the input image
% ratio (optional) allows you to change the border thickness, e.g.,
% ratio = 0.5 will give a border that is 0.5µm or 1/8 of the image

if nargin<2
    ratio=1;
end
global uaa
%find original image indices (before drift correct)
[row,col] = find(I);
rowInd = min(row) : max(row);
colInd = min(col) : max(col);
%create border
rowBorder = ceil(ratio * min([1 * 1/uaa.imageInfo.umPerPixel, length(rowInd)/4]));
colBorder = ceil(ratio * min([1 * 1/uaa.imageInfo.umPerPixel, length(colInd)/4]));
BWborder = false(size(I));
BWborder(rowInd([1:rowBorder, end-rowBorder+1:end]),:) = true;
BWborder(:,colInd([1:colBorder, end-colBorder+1:end])) = true;