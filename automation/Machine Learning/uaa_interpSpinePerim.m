function [xq, yi] = uaa_interpSpinePerim(y)
%% yi = uaa_interpSpinePerim(y)
% interpolates the input y to 100 datapoints
% y is a 5µm segment of pixels
% xq is 5µm in 100 points
% yi is y in 100 points
% units of yi are 0.1µm

global uaa


pixelPerimRegion = round(1/uaa.imageInfo.umPerPixel * 5);
pixelPerimRegion = pixelPerimRegion + 1 - mod(pixelPerimRegion,2); %add 1 if even value
perimRatio = uaa.imageInfo.umPerPixel * 10;
x = linspace(1,5,pixelPerimRegion);
xq = linspace(1,5,100);

if isempty(y)
    yi = y;
    return
end

if iscell(y)
    yi = cell(size(y));
    for i=1:size(y,1)
        if isempty(y{i})
            yi{i} = y{i};
        else
            yi{i} = interp1(x,y{i},xq)';
            yi{i} = yi{i} * perimRatio;
            yi{i} = yi{i} - min(yi{i});
        end
    end
else
    yi = interp1(x,y,xq)';
    yi = yi * perimRatio;
    yi = yi - min(yi);
end


