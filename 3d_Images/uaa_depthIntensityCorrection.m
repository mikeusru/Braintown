function J = uaa_depthIntensityCorrection(I)
%UAA_DEPTHINTENSITYCORRECTION normalizes the contrast in a 3D image stack
%using relative maximum values
% I (optional) is an input cell array of images. If I is present, the
% resulting output is not saved to uaa.T.Image;
% Output: J, the cell array of images

global uaa

if nargin<1
    I = uaa_getAllImageFrames;
end

maxInt = double(cellfun(@max,cellfun(@max,I,'UniformOutput',false)));
minInt = double(cellfun(@min,cellfun(@min,I,'UniformOutput',false)));
% figure
% plot(maxInt)
x = 1:length(maxInt);
p = polyfit(x',maxInt,1);
y = polyval(p,x);
J = cellfun(@mat2gray,I,mat2cell([minInt,y'],ones(length(minInt),1),2),'UniformOutput',false);
% siz = size(J{1});
% a = reshape([J{:}],siz(1),siz(2),[]);

if nargin<1
    uaa.T.Image(:) = J;
end

uaa_updateGUI;
uaa_changeFrame(2);