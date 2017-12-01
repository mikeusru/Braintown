function uaa_addRoi( i )
% uaa_adRoi( i )
% adds a ROI to the figure

global uaa

figure(uaa.handles.Fig1);
i=i+1;

rectstr = ['RoiA', num2str(i-1)];
% polystr = ['PolA', num2str(i-1)];
textstr = ['TextA', num2str(i-1)];
Rois = findobj('Tag', rectstr);
% Polys = findobj('Tag', polystr);
Texts = findobj('Tag', textstr);

for j = 1:length(Rois)
    delete(Rois(j));
end
for j = 1:length(Rois)
    delete(Texts(j));
end
% for j=1:length(Polys)
%     delete(Polys(j));
% end
h = imellipse(uaa.handles.ax(1));
roiPos = h.getPosition;

% fill create empty ROI handle first to avoid bug
if ~isfield(uaa.handles,'roiA')
    for j = 1:i-1
        delete(h);
        uaa.handles.roiA(j) = h;
    end
    h = imellipse(uaa.handles.ax(1),roiPos);
end
uaa.handles.roiA(i) = h;
set(uaa.handles.roiA(i),'Tag',rectstr);
uaa.handles.textA(i) = text(roiPos(1), roiPos(2), num2str(i-1), 'color', 'white', 'Tag', textstr, 'ButtonDownFcn', 'uaa_deleteRoi');
addNewPositionCallback(uaa.handles.roiA(i),@(p) uaa_updateRoiInfo(p,i,'RoiA'));
uaa_updateRoiInfo(roiPos,i,'RoiA');

uaa.T.Accessed(uaa.currentFrame)=1;

end

