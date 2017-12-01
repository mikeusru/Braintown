function file_list = uaa_findTrainingData(fileType)
%finds .mat files in subfolders which have training data and add them to
%the dataset

global uaa

if nargin<1
    fileType = '.mat';
end

choice = questdlg('Load Duplicate Entries?','Allow duplicates?','Yes','No','Cancel','No');

switch choice
    case 'Yes'
        allowRepeats = true;
    case 'No'
        allowRepeats = false;
    case 'Cancel'
        return
end

pName = '';
if isfield(uaa.settings,'start_path')
    pName =  uaa.settings.start_path;
end

pName = uigetdir(pName);
disp('Searching Subfolders...');
file_list = getAllFiles(pName,1);
disp('Subfolder Indexing Done');

[~,name,ext] = cellfun(@fileparts,file_list,'UniformOutput',false);
ind = ~cellfun(@isempty,strfind(ext,fileType)) | ~cellfun(@isempty,strfind(name,fileType));
file_list = file_list(ind);

if strcmp(fileType,'.mat')
    
    for i=1:length(file_list)
        S = whos('-file',file_list{i});
        isDataset = sum(~cellfun(@isempty,strfind({S.name},'uaaCopy')));
        if ~isDataset
            continue
        end
        if strcmp(S.name,'uaaCopy')
            S = load(file_list{i});
            isTrainingData = strfind(get(S.uaaCopy.ds,'VarNames'),'SpineCoordinates');
            isTrainingData = sum([isTrainingData{:}]);
            if isTrainingData
                if ~allowRepeats
                    allNewFiles = fullfile(S.uaaCopy.ds.Foldername,S.uaaCopy.ds.Filename);
                    allExistingFiles = fullfile(uaa.T.Foldername,uaa.T.Filename);
                    [~,ia] = setdiff(allNewFiles,allExistingFiles);
                    loadedDS = S.uaaCopy.ds(ia,:);
                else
                    loadedDS = S.uaaCopy.ds;
                end
                uaa_addNewDataset(loadedDS);
                disp(['Added ' file_list{i}]);
            end
        end
    end
end