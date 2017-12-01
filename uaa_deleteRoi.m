function uaa_deleteRoi
global uaa


tagA = get(gco, 'Tag');
Texts = findobj('Tag', tagA);

switch tagA(1:3)
    case 'Tex' %text is from regular ROI
        RoiNstr = tagA(6:end);
        Rois = findobj('Tag', ['RoiA', RoiNstr]);
        i=str2double(RoiNstr)+1;
        uaa.T.Roi(:,i)={[]}; %clear all positions
        for j = 1:length(Rois)
            delete(Rois(j));
            delete(Texts(j));
        end
    case 'Pol' %text is from polygonal roi
        PolNstr = tagA(10:end);
        Pols = findobj('Tag', ['PolA', PolNstr]);
        i=str2double(PolNstr)+1;
        uaa.T.PolygonRoi(:,i)={[]}; %clear all positions
        for j = 1:length(Rois)
            delete(Pols(j));
            delete(Texts(j));
        end
end


