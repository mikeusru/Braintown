function Iall = uaa_im2bwRepeat(I)
% Iall = uaa_im2bwRepeat(I)
%UAA_IM2BWREPEAT creates a 10-level composite of binary images using
%different thresholds
%
% Inputs: Binary Image
% Outputs: Binary Image
global uaa
% minSpineArea = (uaa.imageInfo.umPerPixel*2)^2;

m = min(min(I));
Iall = zeros(size(I));
for i=1:5
    BW=im2bw(I,(graythresh(I)/i));
%     BW(Iall~=0) = 0;
%     BW = bwareaopen(BW,minSpineArea);
    Iall = Iall + BW;
end
