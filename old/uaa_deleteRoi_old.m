function uaa_deleteRoi
global uaa


tagA = get(gco, 'Tag');
Texts = findobj('Tag', tagA);
RoiNstr = tagA(6:end);
Rois = findobj('Tag', ['RoiA', RoiNstr]);

i=str2double(RoiNstr)+1;
switch get(uaa.handles.roiA(i),'Type')
    case 'line'
        uaa.T.PolygonRoi(:,i)={[]}; %clear all positions
    case 'rectangle'
        uaa.T.Roi(:,i)=[];
end
for j = 1:length(Rois)

    delete(Rois(j));
    delete(Texts(j));
end
