function IafPks = uaa_findAfPeaks(af,caStack,afMethod,blankSpaces)

% find peaks in autofocus
global uaa
% uaa.test.af=af;
% uaa.test.caStack=caStack;
testi=26;
testj=16;
try
    close(hFig)
end

% minPkProm=3;
if strcmp(afMethod,'gradient')
    threshk=0.2; %threshold constant
elseif strcmp(afMethod,'brightest')
    threshk=0.5;
else
    threshk=.01;
end
afSmoothSpan=1; %span for smoothing af values before finding peaks

afPks=cell([size(af,1),size(af,2)]);

pkVals=cell([size(af,1),size(af,2)]);

thresh=max(max(max(af)))*threshk;

hPks=waitbar(0,'Calculating Peaks');
wsPks=1/size(af,1);
% backGnd=max(max(max(I)));


for i=1:size(af,1)
    hPks=waitbar(i*wsPks, hPks,'Calculating Peaks');
    for j=1:size(af,2)
        afVal=permute(af(i,j,:),[3 1 2]);
%         [afVal,~]=imgradient(afVal);
        
        afValLong=[min(afVal);afVal;min(afVal)]; %add zeros at ends so edge maxima are counted as peaks
        afValLong=smooth(afValLong,afSmoothSpan);
        if max(afValLong) > thresh
            [pks,locs]=findpeaks(afValLong,'MinPeakHeight',thresh);
%             eliminate peaks which are closest to eachother (use max)
            pks1=pks;
            locs1=locs;
            dlocs=diff(locs1);
            closeLocs=dlocs<4;
            skipthis=false;
            while ~isempty(find(closeLocs,1))
                if skipthis
                    break
                end
                for k=1:length(closeLocs)
                    if closeLocs(k)
                        ind=pks1==min([pks1(k),pks1(k+1)]);
                        if length(find(ind))>1
                            skipthis=true;
                            break
                        end
                        pks1(ind)=[];
                        locs1(ind)=[];
                        dlocs=diff(locs1);
                        closeLocs=dlocs<4;
                        break
                    end
                end
            end
            pks=pks1;
            locs=locs1;
            afPks{i,j}=locs-1; %subtract 1 to account for addition of zero
            pkVals{i,j}=pks;
        else
            if blankSpaces
                afPks{i,j}=[];
            else
                [~,afPks{i,j}]=max(afVal);
            end
        end
    end
end

% Once peaks are found, take only the dark info in each cell? like... find
% the light/dark contrast in the gradient and only take the stuff darker
% than that.

ca2=cell([size(caStack,1),size(caStack,2)]);
for i=1:size(ca2,1)
    for j=1:size(ca2,2)
        if ~isempty(afPks{i,j})
            ca2{i,j}=min(cell2mat(caStack(i,j,afPks{i,j})),[],3);
        else
            ClassName=class(caStack{i,j,1});
            ca2{i,j}=feval(ClassName,(zeros(size(caStack{i,j,1}))));
        end
        if i==testi && j==testj
            ca2{i,j}=ca2{i,j}*2; %for testing
        end
    end
end

close(hPks);

IafPks=cell2mat(ca2);

return

global uaa

%% testing
hFig(1)=figure;
imshow(IafPks);
af1=permute(af(testi,testj,:),[3 1 2]);
hFig(2)=figure;
plot(af1);
hold on
pkX=afPks{testi,testj};
pkY=pkVals{testi,testj};
plot(pkX,pkY,'ro');
hFig(3)=figure;
ii=1;
for i=1:length(pkX)
    subplot(length(pkX),2,ii);
    ii=ii+1;
    imshow(caStack{testi,testj,pkX(i)});
    subplot(length(pkX),2,ii);
    ii=ii+1;
    imshow(uaa.test.caStackGauss{testi,testj,pkX(i)});
    drawnow;
end