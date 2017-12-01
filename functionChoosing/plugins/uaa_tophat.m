function I = uaa_tophat(I)
% I = uaa_tophat(I)
% UAA_tophat runs a tophat filter on the image
%
% Inputs: Image
% Outputs: Image

global uaa
cl = class(I);
tfAll = eval([cl,'(zeros(size(I)))']);
for i=1:5
diskSize = uaa.imageInfo.smallestFeature / uaa.imageInfo.umPerPixel;
se=strel('disk',diskSize*i);
tophatFiltered = imtophat(I,se);
tfAll = tfAll + tophatFiltered;
end
% I = tophatFiltered;
I = tfAll;