function uaa_previewDataInFolder(file_list2)
%tool to find and display reference images in a particular folder. good for
%indexing folders to use for training data.

global uaa


expression = 'refimage[^z]'; %reference images, not zoomed out

[fileName,pathName]= uiputfile('*.txt','Select/Create Index File');
uaa.filePaths.imageIndexText = fullfile(pathName,fileName);

if nargin<1
    [f1,p1]= uiputfile('*.mat','Save All Ref Index File',pathName);
    f1p1 = fullfile(p1,f1);
    disp('File Loading Done.');
    folder_name = uigetdir;
    file_list = getAllFiles(folder_name,1);
    refInd = regexpi(file_list,expression);
    refInd = ~cellfun(@isempty,refInd);
    file_list2 = file_list(refInd);
    save(f1p1,'file_list2');
    uaa.filePaths.allRefImages = file_list2;
end

uaa.fileIndex = 1;
f = figure;
set(f,'keypressfcn',@uaa_showRefImagesForSelection);
uaa_showRefImagesForSelection(f,file_list2);



