function singleIntensityLine = uaa_calculateSpineIntensityLine(startInd,thinPath, I, umPerPixel)
%first value can be length in µm of line, followed by standardized
%interpolated length of line in 20 units.
D = bwdistgeodesic(thinPath,startInd);
ind = find(thinPath);
[~,i] = sort(D(ind));
ind = ind(i);
singleIntensityLine = double(I(ind));
singleIntensityLine = singleIntensityLine - min(singleIntensityLine);
singleIntensityLine = singleIntensityLine/max(singleIntensityLine);
if length(singleIntensityLine) == 1
    singleIntensityLine = repmat(singleIntensityLine,1,2);
end
lineLength = umPerPixel * length(singleIntensityLine);
v = singleIntensityLine;
x = 1:length(singleIntensityLine);
xq = linspace(1,length(singleIntensityLine),20);
singleIntensityLine = [lineLength, interp1(x,v,xq)];
singleIntensityLine(isnan(singleIntensityLine)) = 0; %temporary bug fix

