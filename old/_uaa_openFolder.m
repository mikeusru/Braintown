function uaa_openFolder(fType)
%UAA_OPENFOLDER opens files in a folder for analysis.
% fType (optional) indicates if a file should be opened instead of a
% folder. 0 (default) indicates a folder, and 1 indicates a file.
global uaa


if nargin<1
    fType=0;
end

if fType==1
    if isfield(uaa.settings,'start_path_image') && ischar(uaa.settings.start_path_image)
        pName = uaa.settings.start_path_image;
    else
        pName = '../';
    end
    [fileName,pName,~]=uigetfile([pName,'*.tif'],'Select File','MultiSelect','on');
    uaa.settings.start_path_image = pName;
    %new file loading system
    if ~iscell(fileName)
        fileName = {fileName};
    end
    fileNameOnly = fileName;
    
    for i=1:length(fileName)
        fileName{i} = fullfile(pName,fileName{i});
    end
    fileName = fileName';
    
    
    [I,numImages,imageInfo] = uaa_loadTiffFiles(fileName);
    ii = 1;
    for i = 1:length(I)
        for j = 1:numImages{i}
            dStruct.Image{ii,1} = I{i}(:,:,j);
            dStruct.Time(ii,1) = datenum(imageInfo{i}(j).FileModDate);
            dStruct.Filename(ii,1) = fileNameOnly(i);
            dStruct.Foldername{ii,1} = pName;
            ii = ii + 1;
        end
    end
    dStruct.ImageStack(1:size(dStruct.Image,1),1)={[]};
    nFrames = ii-1;
    %
else
    start_path = '';
    if isfield(uaa.settings,'start_path')
        start_path =  uaa.settings.start_path;
    end
    pName=uigetdir(start_path);
    if pName==0
        return
    end
    uaa.settings.start_path = pName;
    
    listing=dir(pName);
    [~,root,~]=fileparts(pName);
    answer=inputdlg(['Assuming ', num2str(uaa.settings.totalChan), ' channels; please select channel'],'Channel',1,{'1'});
    chan=str2double(answer{:});
    if isnan(chan)
        chan=1;
        disp('Channel set to 1 by default');
    end
    if strcmp(root,'spc') %if SPC files...

        %%
        k=1;
        for i=1:length(listing)
            [~,fName,ext]=fileparts(listing(i).name);
            if strcmp(ext,'.tif') && strcmp(fName(end-2:end),'max') %check if file is max.tif
                FileTif=[pName,'\',listing(i).name];
                I=imread(FileTif);
%                 disp(size(I));

                imInf=imfinfo(FileTif);
%                 disp(imInf);
%                 disp(imInf.ImageDescription);
                spc = struct;
                eval(imInf.ImageDescription);
%                 w=
%                 l=
%                 uaa.test.imInf = imInf;
                Iproject = reshape(sum(I, 1), spc.size(2), spc.size(3));
                chanYpix = spc.size(2)/uaa.settings.totalChan;
                chanIndex = 1+chanYpix*(chan-1) :chanYpix*chan;
                Iproject = Iproject(chanIndex,:);
                dStruct.ImageStack(k,1)={Iproject};
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
                        dStruct.ImageStack(k,1)={I};
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
        
        k=1;
        
        dStruct=struct;
        for i=1:length(listing)
            [~,fName,ext]=fileparts(listing(i).name);
            if strcmp(ext,'.tif') && ~strcmp(fName(end-2:end),'max') %check if file is appropriate image
                ignore=checkIfIgnore(fName);
                if ignore
                    continue
                end
                FileTif=[pName,'\',listing(i).name];
                info=imfinfo(FileTif);
                imgIndex=chan:uaa.settings.totalChan:length(info);
                for r=1:length(imgIndex) %read images and sum Z stack together
                    if r==1
                        Isum=imread(FileTif,'Index',imgIndex(r),'Info',info);
                        Iall=Isum;
                    else
                        I=imread(FileTif,'Index',imgIndex(r),'Info',info);
                        Iall(:,:,r)=I;
                        Isum=Isum+I;
                    end
                end
                dStruct.ImageStack(k,1)={Iall};
                dStruct.Image(k,1)={Isum};
                dStruct.Filename(k,1)={listing(i).name};
                dStruct.Foldername(k,1)={pName};
                dStruct.Time(k,1)=listing(i).datenum;
                k=k+1;
            elseif listing(i).isdir && ~isempty(fName) && ~strcmp(fName,'.') %load images from first-degree subfolders
                pathNameSub=[pName,'\',fName];
                listingSub=dir(pathNameSub);
                for j=1:length(listingSub)
                    [~,fNameSub,extSub]=fileparts(listingSub(j).name);
                    if strcmp(extSub,'.tif') && ~strcmp(fNameSub(end-2:end),'max') %check if file is appropriate
                        ignore=checkIfIgnore(fNameSub);
                        if ignore
                            continue
                        end
                        FileTif=[pathNameSub,'\',listingSub(j).name];
                        info=imfinfo(FileTif);
                        imgIndex=chan:uaa.settings.totalChan:length(info);
                        for q=1:length(imgIndex) %read images and sum Z stack together
                            if q==1
                                Isum=imread(FileTif,'Index',imgIndex(q),'Info',info);
                                Iall=Isum;
                            else
                                I=imread(FileTif,'Index',imgIndex(q),'Info',info);
                                Isum=Isum+I;
                                Iall(:,:,q)=I;
                            end
                        end
                        dStruct.ImageStack(k,1)={Iall};
                        dStruct.Image(k,1)={Isum};
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
end
%convert to dataset
dsNames={'Foldername','Filename','Time','Image','ImageStack','Roi','PolygonRoi','Accessed','RoiCrop','PolyCrop','AverageBackgroundPixel','RoiSum','RoiAvg','RoiMax','PolySum','PolyAvg','PolyMax'};
emptyCell=cell(nFrames,1);
ds=dataset(dStruct.Foldername,dStruct.Filename,dStruct.Time,dStruct.Image,dStruct.ImageStack,emptyCell,emptyCell,false(nFrames,1),emptyCell,emptyCell,zeros(nFrames,1),zeros(nFrames,1),zeros(nFrames,1),zeros(nFrames,1),zeros(nFrames,1),zeros(nFrames,1),zeros(nFrames,1),'VarNames',dsNames);

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

    function ignore=checkIfIgnore(filename)
        ignore=0;
        for l=1:length(uaa.settings.ignoreFiles) %check if file is on ignore list
            if ~isempty(strfind(filename,uaa.settings.ignoreFiles{l}))
                ignore=1;
                break
            end
        end
    end
end

