function    [I,numImages,imageInfo] = uaa_loadTiffFiles(fileName)

if ~iscell(fileName)
    fileName = {fileName};
end
I = cell(size(fileName));
imageInfo = I;
numImages = I;
fprintf('%s\n','Loading...');
for i=1:length(fileName)
    fprintf('%s\n',fileName{i});
    [I{i},numImages{i},imageInfo{i}] = read_tiff_func(fileName{i});
end
fprintf('%s\n','...Done');