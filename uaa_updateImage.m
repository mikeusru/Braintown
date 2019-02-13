function uaa_updateImage(varargin)
%UAA_UPDATEIMAGE updates the image in the figure

global uaa
if ~ishandle(uaa.handles.Fig1)
    uaa_makeFig(1);
end

imSiz = size(uaa.T.Image{uaa.currentFrame,1});
figSiz = get(uaa.handles.Fig1,'Position');
screenSiz = get(0,'screensize');
figSiz(3:4) = [min(imSiz(2)*4,1000), min(imSiz(1) * 4,1000)];
figSiz(1:2) = [min(figSiz(1), screenSiz(3) - figSiz(3)), min(figSiz(2), screenSiz(4) - figSiz(4))];
set(uaa.handles.Fig1,'Position',figSiz);

I=uaa_getCurrentImageFrame;


if uaa.settings.watershed.doWatershed...
        && isfield(uaa.handles,'uaa_autoOptions')...
        && ishandle(uaa.handles.uaa_autoOptions.updateSingleImageCheckbox)...
        && get(uaa.handles.uaa_autoOptions.updateSingleImageCheckbox,'Value')
    uaa_analyzeSingleImage(I);
    return
end
map=parula;
try
    map=uaa.wShed.map;
end
h=uaa.handles.ax(ishandle(uaa.handles.ax));
cla(h);
ih = imagesc(imc(I),'Parent',uaa.handles.ax(1));


% if uaa.settings.watershed.doWatershed
uaa_analyzeSingleImage(I);
% end

axis(h,'equal','off','image');
if length(h)==1
    set(h(1),'Position',[0 0 1 1]);
end

if isfield(uaa.handles,'uaa_largeImageGui') ...
        && ishandle(uaa.handles.uaa_largeImageGui.largeImageGui)
    imshow(uaa.imageAnalysis.analyzedFigs{uaa.imageAnalysis.largeImage},'Parent',uaa.handles.uaa_largeImageGui.axes1);
end


buttonFxn = '';
%% spine selection tool check
if isfield(uaa.handles,'uaa_spineSelectionTool') && ishandle(uaa.handles.uaa_spineSelectionTool.figure1)
    if get(uaa.handles.uaa_spineSelectionTool.previewClassifierTB,'Value')
%         [xy,cind] = uaa_findSpinesWithClassifier(I,uaa.categoryClassifier);
        [xy,cind,xyBBox] = uaa_findSpinesWithClassifier(I,uaa.ml.classifier);

        %         ih = imagesc(RGB,'Parent',uaa.handles.ax(1));
        hold(h,'on');
        for i = 1:size(xyBBox,1)
            rectangle('Position',xyBBox(i,:),'EdgeColor',cind(1,:),'parent',h,'linewidth',2,'curvature',0.2);
        end
        scatter(xy(:,1),xy(:,2),50,cind,'filled','parent','parent',h);
%         scatter(xy(:,1),xy(:,2),50,'filled','parent','parent',h);
        
    end
    
    if get(uaa.handles.uaa_spineSelectionTool.selectSpinesTB, 'Value') ...
            || get(uaa.handles.uaa_spineSelectionTool.trackSpinesTB, 'Value')
        buttonFxn = @uaa_clickOnImage;
        uaa_initializeSpineCoordinates;
        %         map = gray;
        %plot spine coordinates
        hold(uaa.handles.ax(1), 'on');
        %use previous frame's coordinates if they exist
        spineCoordinates = [];
        if ~isempty(uaa.T.SpineCoordinates{uaa.currentFrame})
            spineCoordinates = uaa.T.SpineCoordinates{uaa.currentFrame};
        elseif get(uaa.handles.uaa_spineSelectionTool.keepSpinesCB,'Value')
            spineCoordinates = uaa.T.SpineCoordinates{max(uaa.currentFrame-1,1)};
            if ~isempty(spineCoordinates)
                spineCoordinates = moveToMaxima(spineCoordinates,imc(I));
            end
            uaa.T.SpineCoordinates{uaa.currentFrame} = spineCoordinates;
        end
        markerSiz = 1e5 / max(max(size(uaa.T.Image{uaa.currentFrame,1})) * 4,1000);

        for i=1:size(spineCoordinates,1)
            scatter(uaa.handles.ax(1),spineCoordinates(i,1),...
                spineCoordinates(i,2),...
                markerSiz/2,'d','filled','MarkerEdgeColor','r','MarkerFaceColor','k',...
                'LineWidth',2,'ButtonDownFcn',@uaa_selectedSpineClickCallback);
%             rectangle('Position',rect_pos,'parent',uaa.handles.ax(1));
        end
        %plot bounding boxes
        if ismember('BoundingBoxes', uaa.T.Properties.VariableNames) && ~isempty(uaa.T.BoundingBoxes(uaa.currentFrame)) && get(uaa.handles.uaa_spineSelectionTool.show_bounding_boxes_CB, 'Value')
            pos = uaa.T.BoundingBoxes{uaa.currentFrame};
            if ~isempty(pos)
                X = [pos(:,1), pos(:,1), pos(:,1) + pos(:,3), pos(:,1) + pos(:,3)]';
                Y = [pos(:,2), pos(:,2) + pos(:,4), pos(:,2) + pos(:,4), pos(:,2)]';
                patch(uaa.handles.ax(1),'XData',X,'YData',Y, 'FaceColor', 'None');
            end
        end
        if get(uaa.handles.uaa_spineSelectionTool.trackSpinesTB, 'Value')
            uaa_tagSpineScatters();
            uaa_markTaggedSpine();
        end
        hold(uaa.handles.ax(1), 'off');
    end
end
set(ih, 'ButtonDownFcn', buttonFxn);


colormap(uaa.handles.ax(1),map)
uaa.CData=get(ih,'CData');
if isfield(uaa.handles,'CLim_slider_figure') && ishandle(uaa.handles.CLim_slider_figure)
    c_low = get(findobj(uaa.handles.CLim_slider_figure,'Tag','low_slider'),'Value');
    c_high = get(findobj(uaa.handles.CLim_slider_figure,'Tag','high_slider'),'Value');
    uaa.handles.ax(1).CLim = [c_low,c_high];
end

%%

drawnow;

function coords = moveToMaxima(coords,I)
global uaa
if ~uaa.roiTracking.trackBright
    I = imcomplement(I);
end
Ig = imgaussfilt(I);
[y,x] = find(imregionalmax(Ig));
[~,idx] = pdist2([x,y],coords,'euclidean','Smallest',1);
coords = [x(idx),y(idx)];

function I2 = imc(I)
global uaa
inverted = get(uaa.handles.uaa_main.showInvertedCB,'Value');
if inverted
    I2 = imcomplement(I);
else I2 = I;
end