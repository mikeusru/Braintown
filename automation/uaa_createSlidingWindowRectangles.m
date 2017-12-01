function slidingWindows = uaa_createSlidingWindowRectangles(imWidth,imHeight,boxWidth,boxHeight,stepSize)
% Create sliding window position vectors
boxWidth = round(boxWidth);
boxHeight = round(boxHeight);
% slidingWindows = [];
% ii=0;
x = [1:stepSize:imWidth-boxWidth]';
sx = length(x);
y = [1:stepSize:imHeight - boxHeight]';
sy = length(y);
x = repmat(x,[sy,1]);
y = repmat(y,[1,sx])';
y = y(:);
slidingWindows = [x,y,repmat([boxWidth,boxHeight],[length(x),1])];