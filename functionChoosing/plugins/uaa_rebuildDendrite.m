function rebuiltDendrite = uaa_rebuildDendrite(BWdendriteSkeleton,BW)
% rebuiltDendrite = uaa_rebuildDendrite(BWdendriteSkeleton,BW)
% UAA_rebuildDendrite Rebuilds the dendrite, branch by branch, using the
% dendrite skeleton and an binary image of the neuron
%
% Inputs: Binary Dendrite Skeleton, Binary Image
% Outputs: Binary Image

global uaa
maxDendriteDiameter = 1/uaa.imageInfo.umPerPixel * 2;

siz = size(BW);
BWbranch=bwmorph(BWdendriteSkeleton,'branchpoints');
BWbranch = bwmorph(BWbranch,'dilate');
BWnoBranch=BWdendriteSkeleton;
BWnoBranch(BWbranch)=0;
CC = bwconncomp(BWnoBranch);
r = regionprops(CC,'Image','BoundingBox');
rebuiltDendrite = false(size(BW));
ObjCell = cell(size(r));
for i=1:length(r)
    bb_i=ceil(r(i).BoundingBox);
    idx_x=[bb_i(1)-maxDendriteDiameter/2 bb_i(1)+bb_i(3)+maxDendriteDiameter/2];
    idx_y=[bb_i(2)-maxDendriteDiameter/2 bb_i(2)+bb_i(4)+maxDendriteDiameter/2];
    if idx_x(1)<1, idx_x(1)=1; end
    if idx_y(1)<1, idx_y(1)=1; end
    if idx_x(2)>siz(2), idx_x(2)=siz(2); end
    if idx_y(2)>siz(1), idx_y(2)=siz(1); end
    ObjCell{i}=BW(idx_y(1):idx_y(2),idx_x(1):idx_x(2));
    dendritePart = imopen(ObjCell{i},r(i).Image);
    rebuiltDendrite(idx_y(1):idx_y(2),idx_x(1):idx_x(2)) = rebuiltDendrite(idx_y(1):idx_y(2),idx_x(1):idx_x(2)) + dendritePart;
end
rebuiltDendrite(~BW) = 0;