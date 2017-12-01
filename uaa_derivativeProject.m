function [ImaxC,Iaf] = uaa_derivativeProject 
% uaa_derivativeProject projects an image based on the maximum values of
% its derivative

global uaa

%make waitbar since this takes a while
h=waitbar(0,'Working...');


I=uaa_getCurrentImageFrame(1);
[Gmag,~] = imgradient(uaa_getCurrentImageFrame(1));
caStack=uaa_imageToGrid(uaa_getCurrentImageFrame(1));
IGmag=Gmag;
% G=fspecial('gaussian',[3 3],2);

ws=.2/size(uaa.T.Image,1);

for i=1:size(uaa.T.Image,1)
    if i==1
        continue
    end
    I(:,:,i)=uaa_getCurrentImageFrame(i);
%     Ig=imfilter(uaa.T.Image{i,1},G,'same');
    ca=uaa_imageToGrid(uaa_getCurrentImageFrame(i),100,100);
    caStack(:,:,i)=ca;
    [Gmag,~] = imgradient(uaa_getCurrentImageFrame(i));
    IGmag(:,:,i)=Gmag;
    waitbar(ws*i,h,'Building Image');
end

ws=.5/size(caStack,3);

af=zeros(size(caStack));
for i=1:size(caStack,3)
    waitbar(i*ws+.2,h,'Focusing...');
    for j=1:size(caStack,2)
        for k=1:size(caStack,1)
            af(k,j,i)=fmeasure(caStack{k,j,i},'GDER',[]);
        end
    end
end


[afMax,afInd]=max(af,[],3);
ca2=cell([size(caStack,1),size(caStack,2)]);
for i=1:size(ca2,1)
    for j=1:size(ca2,2)
        ca2(i,j)=caStack(i,j,afInd(i,j));
    end
end
Iaf=cell2mat(ca2);


[MaxMGmag,IndMGmag]=max(IGmag,[],3);
Imax=uint16(zeros(size(IndMGmag)));

ws=.3/size(Imax,1);

for i=1:size(Imax,1)
    waitbar(i*ws+.7,h,'Building Max');
    for j=1:size(Imax,2)
        Imax(i,j)=I(i,j,IndMGmag(i,j));
    end
    
end

ImaxC=imcomplement(Imax);
close(h);
delete(h);

%% This part is just for testing

hf=figure;
ha=axes('Parent',hf);
imshow(ImaxC,'Parent',ha,'InitialMagnification',50);
axis(ha,'equal','image','off');

hf2=figure;
ha2=axes('Parent',hf2);
imshow(Iaf,'Parent',ha2,'InitialMagnification',50);
axis(ha2,'equal','image','off');

[fName,pName] = uiputfile('segmented_focus.mat');
FileName=[pName,fName];
save(FileName,'I','caStack','af');

return

%% this part is just for testing
level=multithresh(MaxMGmag);
BW=imquantize(MaxMGmag,level);
BW=BW-min(min(BW));
BW2=bwareaopen(BW,50);
imagesc(BW2);
SE=strel('disk',1);
BW3=imclose(Imax,SE);
imagesc(BW3);
BW4=imfill(BW3,'holes');
SE2=strel('line',20,0);
BW5=imtophat(BW4,SE2);
BW6=imopen(BW5,strel('disk',1));
imagesc(BW6);

ind2=imopen(IndMGmag,strel('disk',2));
imagesc(ind2);

%% show image

hf=figure;
ha=axes('Parent',hf);
imshow(ImaxC,'Parent',ha,'InitialMagnification',50);
axis(ha,'equal','image','off');