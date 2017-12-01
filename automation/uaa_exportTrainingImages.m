function uaa_exportTrainingImages
%save all spine training data to folders
global uaa

%% get and make folders
folder_name = uigetdir();
subFolder1 = [folder_name,'\','SpineImages'];
subFolder2 = [folder_name , '\', 'NoSpineImages'];
if ~exist(subFolder1,'dir')
    mkdir(subFolder1);
end
if ~exist(subFolder2,'dir')
    mkdir(subFolder2);
end

%% Save images to folders
h = waitbar(0,'Saving...');
siz = size(uaa.T,1);
ii=[1,1];
for i=1:siz
    comment = ['Origin File: ', uaa.T.Foldername{i},'\',uaa.T.Filename{i}];
    for j= 1:length(uaa.T.SpineImages{i})
        fName1 = [subFolder1, '\TrainingSpine', num2str(ii(1)), '.tif'];
        waitbar(i/siz,h,['Saving TrainingSpine', num2str(ii(1))]);
        imwrite(uaa.T.SpineImages{i}{j},fName1,'Description',comment);
        ii(1) = ii(1) + 1;
    end
    for j = 1:length(uaa.T.NoSpineImages{i})
        fName2 = [subFolder2, '\TrainingNoSpine', num2str(ii(2)), '.tif'];
        waitbar(i/siz,h,['Saving TrainingNoSpine', num2str(ii(2))]);
        imwrite(uaa.T.NoSpineImages{i}{j},fName2,'Description',comment);
        ii(2) = ii(2) + 1;
    end
end
delete(h);