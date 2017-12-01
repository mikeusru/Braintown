function uaa_openFile
%UAA_OPENFILE reads a file into the struct and dataset

global uaa

[fileName,pathName,~]=uigetfile('../*.tif');
% [uaa.image,uaa.imageFrames]=read_tiff_func(filename);
[I,nFrames]=read_tiff_func(fileName);

try %delete previous ROI handles. 
    delete(uaa.handles.roiA);
    delete(uaa.handles.textA);
    delete(uaa.handles.polyA);
    delete(uaa.handles.polyTextA);
end


%preallocate dataset
dsNames={'Foldername','Filename','Time','Image','Roi','PolygonRoi','Accessed','RoiCrop','PolyCrop','AverageBackgroundPixel','RoiSum','RoiAvg','RoiMax','PolySum','PolyAvg','PolyMax'};
emptyCell=cell(nFrames,1);
ds=dataset(emptyCell,(1:nFrames)',emptyCell,emptyCell,emptyCell,false(nFrames,1),emptyCell,emptyCell,zeros(nFrames,1),zeros(nFrames,1),zeros(nFrames,1),zeros(nFrames,1),zeros(nFrames,1),zeros(nFrames,1),zeros(nFrames,1),'VarNames',dsNames);

ds.Accessed(1)=1;
%add image to dataset
for i=1:nFrames
    ds.Image(i,1)={I(:,:,i)};
end
ds.Filename(:,1)={fileName};
ds.Foldername(:,1)={pathName};
uaa.T=ds;
uaa.pathName=pathName;
uaa.currentFrame=1;
uaa.imSize=size(I(:,:,1));
uaa_makeFig;
figure(uaa.handles.Fig1);
imagesc(I(:,:,1));
uaa_updateGUI;

end

