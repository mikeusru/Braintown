function [IafPks, Is, af, timeOutErr] = uaa_afProject(blockSizeR,blockSizeC,afMethod,allowTimeout,blankSpaces,I)
% [IafPks, Is, timeOutErr] = uaa_afProject(blockSizeR,blockSizeC,afMethod,allowTimeout,blankSpaces,I)
% projects an image using its local peaks in focus values
% blockSizeR,blockSizeC (optional) indicate the block size which should be used for
% collecting focus values. smaller block sizes take significantly more
% time. Default= 100 , 100.

global uaa

if nargin<6
    I = uaa_imagesToStack;
end

if nargin<5
    blankSpaces=true;
end

if nargin<4
    allowTimeout=false;
end

if nargin<3
   afMethod='GDER'; 
end

if nargin<1
    blockSizeR = 100;
    blockSizeC = 100;
end

if nargin==1
    blockSizeC=blockSizeR;
end
%% 

useimopen=false;
useGauss=false;
timeOutErr=false;
timeOutMax=300; %time out after 5 min
IafPks=[];

%make waitbar since this takes a while
h=waitbar(0,'Working...');

Is=I;

caStack=uaa_imageToGrid(I(:,:,1),blockSizeR,blockSizeC);

if useGauss || useimopen
    waitbar(0,h,'Rendering image for focusing...');
    if useimopen
        Is(:,:,1)=findSharpObjects(I(:,:,1));
        caStackGauss=uaa_imageToGrid(Is(:,:,1),blockSizeR,blockSizeC);
    else
        Ig=imgaussfilt3(I,2);
        caStackGauss=uaa_imageToGrid(Ig(:,:,1),blockSizeR,blockSizeC);
    end
end


ws=.2/size(uaa.T.Image,1);

for i=1:size(uaa.T.Image,1)
    ca=uaa_imageToGrid(I(:,:,i),blockSizeR,blockSizeC);
    if useGauss
        caGauss=uaa_imageToGrid(Ig(:,:,i),blockSizeR,blockSizeC);
        caStackGauss(:,:,i)=caGauss;
    elseif useimopen
        Is(:,:,i)=findSharpObjects(I(:,:,i));
        caGauss=uaa_imageToGrid(Is(:,:,i),blockSizeR,blockSizeC);
        caStackGauss(:,:,i)=caGauss;
    end
    
    caStack(:,:,i)=ca;
    waitbar(ws*i,h,'Building Image');
end

ws=.8/size(caStack,3);
totalTime=0;

af=zeros(size(caStack));

if useGauss || useimopen
    afStack=caStackGauss;
else
    afStack=caStack;
end
    
for i=1:size(afStack,3)
    waitbar(i*ws+.2,h,'Focusing...');
    for j=1:size(afStack,2)
        for k=1:size(afStack,1)
            tV=tic;
            if strcmp(afMethod,'gradient')
                [Gmag,~]=imgradient(afStack{k,j,i});
                af(k,j,i)=max(max(Gmag));
            elseif strcmp(afMethod,'darkest')
                af(k,j,i)=max(max(imcomplement(afStack{k,j,i})));
            elseif strcmp(afMethod,'brightest')
                af(k,j,i)=max(max(afStack{k,j,i}));
            else
                af(k,j,i)=fmeasure(afStack{k,j,i},afMethod,[]);
            end
            eT=toc(tV);
            totalTime=totalTime+eT;
            if totalTime > timeOutMax && allowTimeout %end if taking too long
                timeOutErr=1;
                disp(['ending ', afMethod, ' due to timeout']);
                return
            end
        end
    end
end

IafPks = uaa_findAfPeaks(af,caStack,afMethod,blankSpaces);

close(h);
delete(h);

return
% This part is just for testing

hf(1)=figure;
ha=axes('Parent',hf(1));
imshow(IafPks,'Parent',ha(1),'InitialMagnification',50);
axis(ha(1),'equal','image','off');
%%
% 
% hf(2)=figure;
% ha(2)=axes('Parent',hf(2));
% imshow(IafPksGauss,'Parent',ha(2),'InitialMagnification',50);
% axis(ha(2),'equal','image','off');

button=questdlg('Save Image?');
if strcmp(button,'Yes')
    [fName,pName] = uiputfile('segmented_focus.mat');
    FileName=[pName,fName];
    disp('Saving File...');
    saveVars={'I','caStack','af','IafPks'};
    ind=logical(cellfun(@exist,saveVars));
    save(FileName,saveVars{ind});
    FileTif=[FileName(1:end-3),'tif'];
    imwrite(IafPks,FileTif);
    disp('Done!');
end
