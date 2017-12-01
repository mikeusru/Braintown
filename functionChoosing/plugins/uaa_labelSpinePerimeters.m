function [tempOutput] = uaa_labelSpinePerimeters(imageRegions)
% [tempOutput] = uaa_labelSpinePerimeters(imageRegions)
%create draggable rectangle boxes to select spine perimeters
global uaa

if ~max(strcmp(uaa.T.Properties.VariableNames,'PerimeterSpineBoundingBox'))
    uaa.T.PerimeterSpineBoundingBox = cell(size(uaa.T,1),1);
end
bBoxSize = str2double(get(uaa.handles.uaa_spineSelectionTool.posTrainED,'String'));
coords = uaa.T.SpineCoordinates{uaa.currentFrame};

if isfield(uaa.handles,'perimAx') && ishandle(uaa.handles.perimAx)
    cla(uaa.handles.perimAx);
else
    uaa.handles.perimFig = figure;
    set(uaa.handles.perimFig,'tag','PerimSelectFig');
    set(uaa.handles.perimFig,'KeyPressFcn',@uaa_imageFrame_keypressfcn);
    uaa.handles.perimAx = axes('parent',uaa.handles.perimFig);
end

if ~isstruct(imageRegions)
    perimPreview = zeros(size(uaa_getCurrentImageFrame));
else
    perimPreview = [imageRegions.x];
    perimPreview = reshape(perimPreview,size(imageRegions(1).x,1),size(imageRegions(1).x,2),size(imageRegions,1));
    perimPreview(~isfinite(perimPreview)) = 0;
    perimPreview = sum(perimPreview,3);
end

imagesc(perimPreview,'parent',uaa.handles.perimAx);
axis(uaa.handles.perimAx,'image','off');

for i=1:size(coords,1)
    
    try
        pos = uaa.T.PerimeterSpineBoundingBox{uaa.currentFrame,1}(i,:);
    catch
        pos = [coords(i,1) - bBoxSize/2,  coords(i,2) - bBoxSize/2, bBoxSize, bBoxSize];
        uaa.T.PerimeterSpineBoundingBox{uaa.currentFrame,1}(i,:) = pos;
    end
    h(i) = imrect(uaa.handles.perimAx,pos);
    addNewPositionCallback(h(i),@(p) uaa_updateSpinePerimeterROI(i,p));
    
end

uaa.T.PerimRegions{uaa.currentFrame,1} = imageRegions;
figure(uaa.handles.perimFig);
tempOutput = 0;