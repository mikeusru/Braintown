function uaa_showRefImagesForSelection(f,e)
%show a number of reference images and save their info to a text file when
%they are clicked

global uaa

if ~strcmp(e.Key, 'return')
    return
end
delete(get(f,'children'));
file_list2 = uaa.filePaths.allRefImages;
maxImages = 50; %show 50 images at a time

maxImages = min(maxImages, length(file_list2));

ind = uaa.fileIndex : 1 : min(uaa.fileIndex+maxImages-1,length(file_list2));
figure(f);
hIm = imdisp(file_list2(1:maxImages));
set(f,'keypressfcn',@uaa_showRefImagesForSelection);
hIm = hIm';
hIm = hIm(:);
for i = ind
    set(hIm(i),'Tag',file_list2{i},'ButtonDownFcn',@uaa_saveFigureTag);
end