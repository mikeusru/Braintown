function uaa_open(ftype)
%first function to open and load in images
global uaa
uaa.data_to_add = [];

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
        if isinteger(imageStruct)
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
    case 'bens_fov'
        %find starting folder
        if isfield(uaa.settings,'start_path_image') && ischar(uaa.settings.start_path_image)
            pName = uaa.settings.start_path_image;
        else
            pName = '../';
        end
        %load Images
        [imageStruct, pName] = loadBensFOV(pName);
        if isempty(imageStruct)
            disp('Error - This is not the data you''re looking for');
            return
        end
        %set Startpath
        uaa.settings.start_path_image = pName;
end
%convert to table
T = struct2table(imageStruct,'asarray',true);
%extract relative time for each frame
T.DateTime = datetime(T.DateTime);
T.Time = datenum(T.DateTime);
minDateVec=datevec(min(T.Time));
eTimeVec = zeros(height(T),1);
for i = 1:height(T)
    eTimeVec(i) = etime(datevec(T.DateTime(i)),minDateVec);
end
% eTimeVec=etime(datevec(T.DateTime),minDateVec);
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

%deal with already analyzed data in ben's fov folders
if ~isempty(uaa.data_to_add)
    for i = 1:length(uaa.data_to_add)
        data_to_add = uaa.data_to_add{i};
        S=load(data_to_add{1});
        loaded_table = S.uaaCopy.T;
        uaa_addNewDataset(loaded_table);
    end
end

disp('Stuff opened successfully goodie');


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
if isempty(fileName)
    imageStruct = 0;
    pName = 0;
    return
end
%new file loading system
if ~iscell(fileName)
    fileName = {fileName};
end

for i=1:length(fileName)
    fileName{i} = fullfile(pName,fileName{i});
end
fileName = fileName';

[I,numImages,imageInfo] = uaa_loadTiffFiles(fileName);
imageStructPart = makeImageStructPart(I,numImages,imageInfo);
imageStruct = imageStructPart;

function [imageStruct, pName] = loadBensFOV(pName)
global uaa
[fileName,pName,~]=uigetfile([pName,'\*.mat'],'Select File','MultiSelect','on');
imageStruct = struct([]);
whole_path_loaded = false;
if ~isa(fileName,'cell')
    if ~fileName
        pName=uigetdir('Select Directory');
        if ~pName
            return
        end
        fileList = getAllFiles(pName);
        % remove folders with previously analyzed data
        expression = '(.*_Analyzed.mat)';
        file_name_analyzed = regexp(fileList, expression, 'match');
        file_name_analyzed(cellfun(@isempty,file_name_analyzed)) = [];
        uaa.data_to_add = file_name_analyzed;
        for i = 1:length(file_name_analyzed)
            [~,f,~] = fileparts(fileparts(file_name_analyzed{i}{1}));
            expression = sprintf('%s',f);
            analyzed_folders = regexp(fileList, expression, 'match');
            fileList(~cellfun(@isempty,analyzed_folders)) = [];
        end
        expression = '(.*.mat)';
        fileName = regexp(fileList,expression,'match');
        non_empty_ind = ~cellfun(@isempty,fileName);
        fileName = fileName(non_empty_ind);
        fileName = reshape(fileName,1,[]);
        whole_path_loaded = true;
    else
        fileName = {fileName};
    end
end

for f_name_single = fileName
    if whole_path_loaded
        filePath = f_name_single{1}{1};
    else
        filePath = fullfile(pName,f_name_single{1});
    end
    fov = load(filePath);
    % This assumes there's just one fieldname, and whatever it is is the right
    % thing.
    fields = (fieldnames(fov));
    fov = fov.(fields{1});
    if ~isfield(fov,'spine') || ~isfield(fov,'img') || sum([fov.spine]) < 1
        continue
    end
    % This is a dumb way to do it but let's just do it this way for now...
    xPos = [fov.xPos];
    yPos = [fov.yPos];
    switch fields{1}
        case 'fov'
            loadedSessions = [];
            for i = 1:length(fov)
                if ~isempty(fov(i).img)
                    session = fov(i).session;
                    if sum(session == loadedSessions) > 0
                        continue
                    end
                    loadedSessions(end+1) = session;
                    imageStruct(end+1).Image = fov(i).img;
                    if isfield(fov,'scale')
                        imageStruct(end).Scale = fov(i).scale;
                    end
                    imageStruct(end).DateTime = fov(i).date;
                    imageStruct(end).Filename = f_name_single{1};
                    imageStruct(end).Foldername = pName;
                    x = xPos([fov.session] == session);
                    y = yPos([fov.session] == session);
                    imageStruct(end).SpineCoordinates = [x',y'];
                end
            end
        case 'ce'
            for i = 1:length(fov)
                if ~isempty(fov(i).img)
                    img = fov(i).img;
                    if ~isempty(imageStruct)
                        %check to make sure it's not a duplicate image
                        if isequal(imageStruct(end).Image,img)
                            continue
                        end
                    end
                    imageStruct(end+1).Image = img;
                    imageStruct(end).DateTime = fov(i).date;
                    imageStruct(end).Filename = f_name_single{1};
                    imageStruct(end).Foldername = pName;
                    if isfield(fov,'scale')
                        imageStruct(end).Scale = fov(i).scale;
                    end
                    x = xPos([fov.spine]);
                    y = yPos([fov.spine]);
                    imageStruct(end).SpineCoordinates = [x',y'];
                end
            end
        otherwise
            disp('Error - data type not recognized. Stop fooling around.');
    end
end


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

