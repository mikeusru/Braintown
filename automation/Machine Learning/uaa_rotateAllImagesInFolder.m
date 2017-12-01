function uaa_rotateAllImagesInFolder

fileList = getAllFiles(uigetdir,1);

for i=1:length(fileList)
    filename = fileList{i};
    [~,~,ext] = fileparts(filename);
    if strcmp(ext,'.tif')
        uaa_rotateAndSaveImages(filename)
    end
end

disp('Done with all images');