function uaa_addPolyRoi( i )
% uaa_addPolyRoi( i ) adds a polygonal ROI

global uaa

figure(uaa.handles.Fig1);
i=i+1;

polystr = ['PolA', num2str(i-1)];
polytextstr = ['PolyTextA', num2str(i-1)];

Polys = findobj('Tag', polystr);
PolyTexts = findobj('Tag', polytextstr);

for j=1:length(Polys)
    delete(Polys(j));
end

for j=1:length(PolyTexts)
    delete(PolyTexts(j));
end

uaa.handles.polyA(i)=impoly(uaa.handles.ax(1));
roiPos=uaa.handles.polyA(i).getPosition;
set(uaa.handles.polyA(i),'Tag',polystr);
uaa.handles.polyTextA(i) = text(roiPos(1,1)+2, roiPos(1,2)+2, num2str(i-1), 'color', 'white', 'Tag', polytextstr, 'ButtonDownFcn', 'uaa_deleteRoi');
addNewPositionCallback(uaa.handles.polyA(i),@(p) uaa_updateRoiInfo(p,i,'PolA'));
uaa_updateRoiInfo(roiPos,i,'PolA');

uaa.T.Accessed(uaa.currentFrame)=1;