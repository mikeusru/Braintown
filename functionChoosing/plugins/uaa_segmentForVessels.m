function [image, ib, gradmag, Io, Ioc, Iobrcbr, fgm4] = uaa_segmentForVessels(I)
% [image, ib, gradmag, Io, Ioc, Iobrcbr, fgm4] = uaa_segmentForVessels(I)
% UAA_SEGMENTFORVESSELS segments images to find blood vessels.
%
% Inputs: Image
% Outputs: Binary Image
ib = ~imbinarize(I,'adaptive');
% imshow(ib);
% ibd = ~imdilate(~ib,strel('square',7));
% imagesc(ibd);
% ibs = bwareafilt(ibd,[20,700]);
% imagesc(ibs)

image = imcomplement(mat2gray(I));
y1 = 2*image - imdilate(image, strel('square',7));
y1(y1<0) = 0;
y1(y1>1) = 1;
gradmag = imdilate(y1, strel('square',7)) - y1;
% y2 = imdilate(y1, strel('square',7));
% imshow(gradmag);

se = strel('disk',7);
Io = imopen(image,se);
% f = figure; imshow(Io), title('Opening (Io)');

Ie = imerode(image,se);
Iobr = imreconstruct(Ie,image);
% f(end+1) = figure; imshow(Iobr); title('Opening-by-reconstruction (Iobr)');

Ioc = imclose(Io, se);
% f(end+1) = figure; imshow(Ioc), title('Opening-closing (Ioc)');

Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
% f(end+1) = figure;
% imshow(Iobrcbr), title('Opening-closing by reconstruction (Iobrcbr)');

fgm = imregionalmax(Iobrcbr);
% f(end+1) = figure;
% imshow(fgm), title('Regional maxima of opening-closing by reconstruction (fgm)')

% I2 = image;
% I2(fgm) = 1;
% f(end+1) = figure
% imshow(I2), title('Regional maxima superimposed on original image (I2)')

se2 = strel(ones(3,3));
fgm2 = imclose(fgm, se2);
fgm3 = imerode(fgm2, se2);
fgm4 = bwareaopen(fgm3, 20);
% I3 = image;
% I3(fgm4) = 1;
% f(end+1) = figure
% imshow(I3)
% title('Modified regional maxima superimposed on original image (fgm4)')

% [imHeight, imWidth] = size(I);
% boxSide = 100;
% slidingWindows = uaa_createSlidingWindowRectangles(imWidth,imHeight,boxSide-1,boxSide-1,20);
%     imageParts = struct([]);
% trueCoords = uaa.T.SpineCoordinates{uaa.currentFrame};