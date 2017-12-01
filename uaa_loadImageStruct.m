function uaa_loadImageStruct(fullPath)
% function uaa_loadImageStruct(fullPath) loads the image structure to be
% analyzed automatically
global uaa
S = load(fullPath);
ind = S.channel : S.totalChannels : size(S.Image,3);
I = S.Image(:,:,ind);
uaa.imageInfo.umPerPixel = S.umPerPixel;
uaa.imageInfo.zStep = S.zStep;
uaa.imageInfo.key = S.key;
uaa.imageInfo.task = S.task;

%load into dataset
nFrames = length(ind);
C = squeeze(mat2tiles(I,inf,inf,1));

dsNames={'Foldername','Filename','Time','Image','ImageStack','Roi','PolygonRoi','Accessed','RoiCrop','PolyCrop','AverageBackgroundPixel','RoiSum','RoiAvg','RoiMax','PolySum','PolyAvg','PolyMax','SpineCoordinates'};
emptyCell=cell(nFrames,1);
emptyMat = zeros(nFrames,1);
ds=dataset(emptyCell,emptyCell,emptyMat,C,emptyCell,emptyCell,emptyCell,false(nFrames,1),emptyCell,emptyCell,emptyMat,emptyMat,emptyMat,emptyMat,emptyMat,emptyMat,emptyMat,emptyCell,'VarNames',dsNames);
uaa.T=ds;
uaa.currentFrame=1;
uaa.imSize=size(uaa_getCurrentImageFrame(1));

uaa_makeFig;
uaa_updateImage;