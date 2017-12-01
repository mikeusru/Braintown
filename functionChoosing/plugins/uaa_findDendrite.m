function BW2 = uaa_findDendrite(BW)
%  BW2 = uaa_findDendrite(BW)
%UAA_FINDDENDRITE thins the image and repeatedly removes short branches
%less than 10µm long
%
% Inputs: Binary Image
% Outputs: Binary Image
global uaa
BW = logical(BW);
maxSpineLength = 1/uaa.imageInfo.umPerPixel;
minDendriteDiameter = 1/uaa.imageInfo.umPerPixel / 4;

BW = imopen(BW,strel('disk',minDendriteDiameter));
BW2=bwmorph(BW,'thin',Inf);
seed=false(size(BW2));
hD=figure; %to monitor progress...
hDa=axes('Parent',hD);
for i=1:5
    BW2=bwmorph(BW2,'spur',1); %remove single pixels leftover from enlarged branchpoint image
    BW2 = bwmorph(BW2,'close');
    BW2 = bwmorph(BW2,'fill');
    BW2=bwmorph(BW2,'thin',Inf);
    BWbranch=bwmorph(BW2,'branchpoints');
    BWbranch = bwmorph(BWbranch,'dilate');
    BWnoBranch=BW2;
    BWnoBranch(BWbranch)=0;
    BW2end=bwmorph(BW2,'endpoints');
    imshow(BW2,'Parent',hDa);
    drawnow;
    tempSeed=seed;
    tempSeed(BW2end)=1;
    BWD=bwdistgeodesic(BWnoBranch,tempSeed);
    BWD(isinf(BWD))=0;
    BWD(isnan(BWD))=0;
    BWL = bwlabel(BWD);
    longBranches = unique(BWL(BWD>maxSpineLength));
    BWL(ismember(BWL,longBranches)) = 0;
    BW2(logical(BWL)) = 0;
    
    imshow(BW2,'InitialMagnification',20,'Parent',hDa);
    drawnow;
    
end
BW2=bwareaopen(BW2,2);
close(hD);
return
%%%%%%%%%%%%
%% reconnect broken branches by doing geodesic using endpoints over original BW image?

