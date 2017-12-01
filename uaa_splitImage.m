function uaa_splitImage(x,y)
% uaa_splitImage(x,y) splits the single-frame image into multiple frames
% with x and y pixels each.
global uaa

I=uaa_getCurrentImageFrame(1);

ca = uaa_imageToGrid(I,x,y);

[m,n]=size(ca);
mn=m*n;

% clear and preallocate dataset
ds=uaa.T;

ds.Image{1,1}=[];
for i=1:mn
    ds(i,:)=uaa.T(1,:);
end

for i=1:mn
    ds.Image(i,1)=ca(i);
end

uaa.T=ds;