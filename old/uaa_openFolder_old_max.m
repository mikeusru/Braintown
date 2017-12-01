function uaa_openFolder
%UAA_OPENFOLDER opens files in a folder for analysis.

global uaa

pName=uigetdir;
if pName==0
    return
end


listing=dir(pName);
[~,root,~]=fileparts(pName);

if strcmp(root,'spc') %if SPC files...
    %%
    k=1;
    for i=1:length(listing)
        [~,fName,ext]=fileparts(listing(i).name);
        if strcmp(ext,'.tif') && strcmp(fName(end-2:end),'max') %check if file is max.tif
            FileTif=[pName,'\',listing(i).name];
            I=imread(FileTif);
            Iproject = reshape(sum(I, 1), 128, 128);
            dStruct.Image(k,1)={Iproject};
            dStruct.Filename(k,1)={listing(i).name};
            dStruct.Foldername(k,1)={pName};
            dStruct.Time(k,1)=listing(i).datenum;
            k=k+1;
        elseif listing(i).isdir && ~isempty(fName) && ~strcmp(fName,'.') %load images from first-degree subfolders
            pNameSub=[pName,'\',fName];
            listingSub=dir(pNameSub);
            for j=1:length(listingSub)
                [~,fNameSub,extSub]=fileparts(listingSub(j).name);
                if strcmp(extSub,'.tif') && strcmp(fNameSub(end-2:end),'max') %check if file is max.tif
                    FileTif=[pNameSub,'\',listingSub(j).name];
                    I=imread(FileTif);
                    dStruct.Image(k,1)={I};
                    dStruct.Filename(k,1)={listingSub(j).name};
                    dStruct.Foldername(k,1)={pNameSub};
                    dStruct.Time(k,1)=listingSub(j).datenum;
                    k=k+1;
                end
            end
        end
    end
    
    
else % if not SPC files
    
    answer=inputdlg('If more than one channel, please select channel','Channel',1,{'1'});
    channel=str2double(answer{:});
    if isnan(channel)
        channel=1;
        disp('Channel set to 1 by default');
    end
    k=1;
    
    dStruct=struct;
    for i=1:length(listing)
        [~,fName,ext]=fileparts(listing(i).name);
        if strcmp(ext,'.tif') && strcmp(fName(end-2:end),'max') %check if file is max.tif
            FileTif=[pName,'\',listing(i).name];
            I=imread(FileTif,'Index',channel);
            dStruct.Image(k,1)={I};
            dStruct.Filename(k,1)={listing(i).name};
            dStruct.Foldername(k,1)={pName};
            dStruct.Time(k,1)=listing(i).datenum;
            k=k+1;
        elseif listing(i).isdir && ~isempty(fName) && ~strcmp(fName,'.') %load images from first-degree subfolders
            pathNameSub=[pName,'\',fName];
            listingSub=dir(pathNameSub);
            for j=1:length(listingSub)
                [~,fNameSub,extSub]=fileparts(listingSub(j).name);
                if strcmp(extSub,'.tif') && strcmp(fNameSub(end-2:end),'max') %check if file is max.tif
                    FileTif=[pathNameSub,'\',listingSub(j).name];
                    I=imread(FileTif,'Index',channel);
                    dStruct.Image(k,1)={I};
                    dStruct.Filename(k,1)={listingSub(j).name};
                    dStruct.Foldername(k,1)={pathNameSub};
                    dStruct.Time(k,1)=listingSub(j).datenum;
                    k=k+1;
                end
            end
        end
    end
end

nFrames=k-1;
%convert to dataset
dsNames={'Foldername','Filename','Time','Image','Roi','PolygonRoi','Accessed','RoiCrop','PolyCrop','AverageBackgroundPixel','RoiSum','RoiAvg','RoiMax','PolySum','PolyAvg','PolyMax'};
emptyCell=cell(nFrames,1);
ds=dataset(dStruct.Foldername,dStruct.Filename,dStruct.Time,dStruct.Image,emptyCell,emptyCell,false(nFrames,1),emptyCell,emptyCell,zeros(nFrames,1),zeros(nFrames,1),zeros(nFrames,1),zeros(nFrames,1),zeros(nFrames,1),zeros(nFrames,1),zeros(nFrames,1),'VarNames',dsNames);


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

%see if there's a pre-uncaging folder and extract last pre-uncaging frame
[~, parentFolder, ~]=cellfun(@fileparts,ds.Foldername,'UniformOutput',false);
if ismember('pre-uncaging',parentFolder)
    lastPreFrame=find(ds.Time==max(ds.Time(strcmp(parentFolder,'pre-uncaging'),1)));
    set(uaa.handles.uaa_main.uncageFrameEdit,'String',num2str(lastPreFrame));
    uaa.uncageFrame=lastPreFrame;
end
uaa.T=ds;
uaa.pathName=pName;
uaa.currentFrame=1;
uaa.imSize=size(uaa_getCurrentImageFrame(1));
uaa_makeFig;
uaa_updateImage;
% figure(uaa.handles.Fig1);
% imagesc(uaa.T.Image{1,1});
uaa_updateGUI;


end

