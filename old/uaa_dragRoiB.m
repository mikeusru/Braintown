function uaa_dragRoiB
%UAA_DRAGROIB Summary of this function goes here
%   Detailed explanation goes here

global uaa

imSize=size(uaa_getCurrentImageFrame);
spc.size=[1,imSize]; %because i didn't feel like changing the spc.size syntax

point1 = get(gca,'CurrentPoint'); % button down detected
point1 = point1(1,1:2);              % extract x and y

if strcmp(get(gco, 'type'), 'line')
    RoiRectX = get(gco, 'XData');
    RoiRectY = get(gco, 'YData');
    RoiRect = [min(RoiRectX), min(RoiRectY), (max(RoiRectX)-min(RoiRectX)), (max(RoiRectY)-min(RoiRectY))];
else
    RoiRect = get(gco, 'Position');
end
rectFigure = get(gcf, 'Position');
rectAxes = get(gca, 'Position');


xmag = (rectFigure(3)*rectAxes(3))/spc.size(3);  %pixel/screenpixel
xoffset =rectAxes(1)*rectFigure(3);
ymag = (rectFigure(4)*rectAxes(4))/spc.size(2);
yoffset = rectAxes(2)*rectFigure(4);

%rect1 = [xmag*RoiRect(1)+xoffset, ymag*RoiRect(2)+yoffset, xmag*RoiRect(3), ymag*RoiRect(4)];
rect1 = [xmag*RoiRect(1)+xoffset+0.5, ymag*(spc.size(2)-RoiRect(2)-RoiRect(4))+yoffset+.5, xmag*RoiRect(3), ymag*RoiRect(4)];

tag1 = round(RoiRect(3)/5+0.5);
tag2 = round(RoiRect(4)/5+0.5);


rect2 = dragrect(rect1);
spc_roi = [round((rect2(1)-xoffset)/xmag), round(spc.size(2)-RoiRect(4)-(rect2(2)-yoffset)/ymag), RoiRect(3), RoiRect(4)];

diffx = (rect2(1) - rect1(1))/xmag;
diffy = (rect2(2) - rect1(2))/ymag;

Ylim = get(gca, 'YLim')-0.5;
Xlim = get(gca, 'Xlim')-0.5;

if spc_roi(1)<1
    spc_roi(1) = 1;
end
if spc_roi(3)+spc_roi(1) > Ylim(2)-1
    spc_roi(3)=Ylim(2)-spc_roi(1);
end

if spc_roi(2)<1
    spc_roi(2) = 1;
end
if spc_roi(2)+spc_roi(4) > Xlim(2)-1
    spc_roi(4) = Xlim(2)-spc_roi(2);
end



tagA = get(gco, 'Tag');
Rois = findobj('Tag', tagA);
RoiNstr = tagA(5:end);
Texts = findobj('Tag', ['TextA', RoiNstr]);
%spc.fit.spc_roi{str2num(RoiNstr)+1} = spc_roi;

%shift = -RoiRect(1:2) + spc_roi(1:2);
roiN = str2num(RoiNstr)+1;
% shift = [diffx, -diffy];
% if strcmp (get(gcf, 'SelectionType'), 'normal')
    for i = 1:length(Rois)
        if strcmp(get(uaa.handles.roiA(roiN), 'Type'), 'line')
            set(Rois(i), 'XData', RoiRectX + diffx);
            set(Rois(i), 'YData', RoiRectY - diffy);
            set(Texts(i), 'Position', [RoiRectX(1) + diffx - 2, RoiRectY(1) - diffy -2]);
            
            uaa_updateRoiInfo(roiN); %update ROI info
            
            
%             xi = get(uaa.handles.roiA(roiN), 'XData');
%             yi = get(uaa.handles.roiA(roiN), 'YData');
%             uaa.rois.roiPoly{roiN} = [xi(:), yi(:)];
%         else
%             set(Rois(i), 'Position', spc_roi);
%             set(Texts(i), 'Position', [spc_roi(1)-2, spc_roi(2)-2, 0]);
%             uaa.rois.roiA{str2num(RoiNstr)+1} = spc_roi;
        end
    end
% elseif strcmp(get(gcf, 'SelectionType'), 'extend')
%     nRoi = length(gui.spc.figure.roiB);
%         for i = 1:nRoi
%             if ishandle(gui.spc.figure.roiB(i))
%                 if ~strcmp(get(gui.spc.figure.roiB(i), 'Type'), 'line')
%                     spc.switches.spc_roi{i} = get(gui.spc.figure.roiB(i), 'Position');
%                     spc.switches.spc_roi{i}(1:2) = spc.switches.spc_roi{i}(1:2) + shift;
%                     set(gui.spc.figure.roiA(i), 'Position', spc.switches.spc_roi{i});
%                     set(gui.spc.figure.roiB(i), 'Position', spc.switches.spc_roi{i});
%                     try
%                         set(gui.spc.figure.roiC(i), 'Position', spc.switches.spc_roi{i});
%                     end
%                     textRoi = spc.switches.spc_roi{i}(1:2)-[2,2];
%                     set(gui.spc.figure.textA(i), 'Position', textRoi);
%                     set(gui.spc.figure.textB(i), 'Position', textRoi);
%                     try
%                         set(gui.spc.figure.textC(i), 'Position', textRoi);
%                     end
%                 else %Line
%                     xi = get(gui.spc.figure.roiB(i), 'XData') + diffx;
%                     yi = get(gui.spc.figure.roiB(i), 'YData') - diffy;
%                     spc.switches.spc_roi{i} = [xi(:), yi(:)];
%                     set(gui.spc.figure.roiA(i), 'XData', xi);
%                     set(gui.spc.figure.roiA(i), 'YData', yi);
%                     set(gui.spc.figure.roiB(i), 'XData', xi);
%                     set(gui.spc.figure.roiB(i), 'YData', yi); 
%                     try
%                         set(gui.spc.figure.roiC(i), 'XData', xi);
%                         set(gui.spc.figure.roiC(i), 'YData', yi);
%                     end
%                     textRoi = [xi(1), yi(1)]-[2,2];
%                     set(gui.spc.figure.textA(i), 'Position', textRoi);
%                     set(gui.spc.figure.textB(i), 'Position', textRoi);
%                     try
%                         set(gui.spc.figure.textC(i), 'Position', textRoi);
%                     end                   
%                 end
%             end
%         end
% end



