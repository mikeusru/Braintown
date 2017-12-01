function uaa_openFolder
%UAA_OPENFOLDER opens files in a folder for analysis.

global uaa

%preallocate dataset
dsNames={'Foldername','Filename','Time','Image','Roi','PolygonRoi','Accessed','RoiCrop','PolyCrop','AverageBackgroundPixel','RoiSum','RoiAvg','RoiMax','PolySum','PolyAvg','PolyMax'};
nFrames=1;
pathName=uigetdir;
if pathName==0
    return
end

emptyCell=cell(nFrames,1);
ds=dataset(emptyCell,emptyCell,(1:nFrames)',emptyCell,emptyCell,emptyCell,false(nFrames,1),emptyCell,emptyCell,zeros(nFrames,1),zeros(nFrames,1),zeros(nFrames,1),zeros(nFrames,1),zeros(nFrames,1),zeros(nFrames,1),zeros(nFrames,1),'VarNames',dsNames);

listing=dir(pathName);
answer=inputdlg('If more than one channel, please select channel','Channel',1,{'1'});
channel=str2double(answer{:});
if isnan(channel)
    channel=1;
    disp('Channel set to 1 by default');
end
k=1;
for i=1:length(listing)
    [~,fName,ext]=fileparts(listing(i).name);
    if strcmp(ext,'.tif') && strcmp(fName(end-2:end),'max') %check if file is max.tif
        FileTif=[pathName,'\',listing(i).name];
        I=imread(FileTif,'Index',channel);
        ds.Image(k,1)={I};
        ds.Filename(k,1)={listing(i).name};
        ds.Foldername(k,1)={pathName};
        ds.Time(k,1)=listing(i).datenum;
        k=k+1;
    elseif listing(i).isdir && ~isempty(fName) && ~strcmp(fName,'.') %load images from first-degree subfolders
        pathNameSub=[pathName,'\',fName];
        listingSub=dir(pathNameSub);
        for j=1:length(listingSub)
            [~,fNameSub,extSub]=fileparts(listingSub(j).name);
            if strcmp(extSub,'.tif') && strcmp(fNameSub(end-2:end),'max') %check if file is max.tif
                FileTif=[pathNameSub,'\',listingSub(j).name];
                I=imread(FileTif,'Index',channel);
                ds.Image(k,1)={I};
                ds.Filename(k,1)={listingSub(j).name};
                ds.Foldername(k,1)={pathNameSub};
                ds.Time(k,1)=listingSub(j).datenum;
                k=k+1;
            end
        end
    end
end

%extract relative time for each frame
minDate=datevec(min(ds.Time));
dateVector=datevec(ds.Time);
eTimeVec=zeros(size(dateVector,1),1);
for i=1:size(dateVector,1)
    eTimeVec(i,:)=etime(dateVector(i,:),minDate);
end
ds.Time=eTimeVec;
ds.Time=ds.Time/60; %convert to minutes
ds=sortrows(ds,'Time');

uaa.T=ds;
uaa.pathName=pathName;
uaa.currentFrame=1;
uaa.imSize=size(uaa_getCurrentImageFrame(1));
uaa_makeFig;
figure(uaa.handles.Fig1);
imagesc(uaa_getCurrentImageFrame(1));
uaa_updateGUI;


end

