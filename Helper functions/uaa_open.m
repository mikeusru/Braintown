function uaa_open(ftype)
%first function to open and load in images
global uaa

switch ftype
    case 'images'
        %find starting folder
        if isfield(uaa.settings,'start_path_image') && ischar(uaa.settings.start_path_image)
            pName = uaa.settings.start_path_image;
        else
            pName = '../';
        end
        %load Images
        [imageStruct, pName] = loadImageFiles(pName);
        if ~imageStruct
            return
        end
        %set Startpath
        uaa.settings.start_path_image = pName;
    case 'folder'
        %find starting folder
        if isfield(uaa.settings,'start_path') && ischar(uaa.settings.start_path)
            pName = uaa.settings.start_path;
        else
            pName = '../';
        end
        pName=uigetdir(pName);
        if pName==0
            return
        end
        uaa.settings.start_path = pName;
        fileList = getAllFiles(pName);
        % % % % % % add way to specify channels
        [imageStruct] = loadOnlyTifs(fileList);
end
%convert to table
T = struct2table(imageStruct,'asarray',true);
%extract relative time for each frame
T.DateTime = datetime(T.DateTime);
T.Time = datenum(T.DateTime);
minDateVec=datevec(min(T.Time));
eTimeVec=etime(datevec(T.DateTime),minDateVec);
T.Time=eTimeVec;
T.Time=T.Time/60; %convert to minutes
T=sortrows(T,'Time');

%see if there's a pre-uncaging folder and extract last pre-uncaging frame
[~, parentFolder, ~]=cellfun(@fileparts,T.Foldername,'UniformOutput',false);
if ismember('pre-uncaging',parentFolder)
    lastPreFrame=find(strcmp(parentFolder,'pre-uncaging'),1,'last');
    set(uaa.handles.uaa_main.uncageFrameEdit,'String',num2str(lastPreFrame));
    uaa.uncageFrame=lastPreFrame;
end

T = uaa_setupTable(T);
        
uaa.T=T;
uaa.pathName=pName;
uaa.currentFrame=1;
uaa.imSize=size(uaa_getCurrentImageFrame(1));
uaa_makeFig;
uaa_updateImage;
% figure(uaa.handles.Fig1);
% imagesc(uaa.T.Image{1,1});
uaa_updateGUI;


%find tiffs in list and load them
function [imageStruct] = loadOnlyTifs(fileList)
global uaa
%load all tifs
imageStruct = struct([]);
[~,f,e] = cellfun(@fileparts,fileList,'UniformOutput',false);
ind = contains(e,'.tif') & ~contains(f,uaa.settings.ignoreFiles);
fileList = fileList(ind);
stackFlag = true;
for i=1:length(fileList)  
    [I,numImages,imageInfo] = uaa_loadTiffFiles(fileList(i));
    if i == 1
        n = numImages{1};
    elseif numImages{1} ~= n
        stackFlag = false;
    end  
    imageStructPart = makeImageStructPart(I,numImages,imageInfo);
    imageStruct = [imageStruct, imageStructPart];
end
if stackFlag
    prompt = {'How many channels?','Which channel do you wish to keep?'};
    dlg_title = 'Channels';
    num_lines = 1;
    defaultans = {'2','1'};
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
    totalChan = str2double(answer{1});
    selectedChan = str2double(answer{2});
    imageStruct = imageStruct(selectedChan:totalChan:length(imageStruct));
    ii = 1;
    %collapse into stacks
    while ii < length(imageStruct)
        stackInd = contains({imageStruct.Filename},[imageStruct(ii).Filename]);
        imageStruct(ii).ImageStack = {imageStruct(stackInd).Image};
        imageStruct(ii).Image = max(cat(3,imageStruct(ii).ImageStack{:}),[],3);
        stackInd(ii)=0;
        imageStruct(stackInd) = [];
        ii = ii + 1;
    end
end
    

%select images to load and load them
function [imageStruct, pName] = loadImageFiles(pName)
[fileName,pName,~]=uigetfile([pName,'*.tif'],'Select File','MultiSelect','on');
if ~fileName
    imageStruct = 0;
    pName = 0;
    return
end
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
imageStructPart = makeImageStructPart(I,numImages,imageInfo);
imageStruct = imageStructPart;

%put images together into struct
function imageStructPart = makeImageStructPart(I,numImages,imageInfo)
ii = 1;
for i = 1:length(I)
    for j = 1:numImages{i}
        imageStructPart(ii).Image = I{i}(:,:,j);
        imageStructPart(ii).DateTime = imageInfo{i}(j).FileModDate;
        [p,f,e] = fileparts(imageInfo{i}(j).Filename);
        imageStructPart(ii).Filename = [f,e];
        imageStructPart(ii).Foldername = p;
        ii = ii + 1;
    end
end

% %check if file is on ignore list
% function ignore=checkIfIgnore(filename)
% global uaa
% ignoreList = uaa.settings.ignoreFiles;
% ignore=0;
% for l=1:length(ignoreList) %check if file is on ignore list
%     if ~isempty(strfind(filename,ignoreList{l}))
%         ignore=1;
%         break
%     end
% end

