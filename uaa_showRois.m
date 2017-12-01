function nRois=uaa_showRois
%nRois=uaa_showRois brings the saved ROIs up to the figure and returns the
%number of Rois created

global uaa

figure(uaa.handles.Fig1);
axes(uaa.handles.ax(1));
frameInd=uaa.currentFrame;
nRois=0;



% try
    for i=1:size(uaa.T.Roi,2) %circle ROIs
        roiPos=uaa.T.Roi{frameInd,i};
        if ~isempty(roiPos)
            rectstr = ['RoiA', num2str(i-1)];
            textstr = ['TextA', num2str(i-1)];
            uaa.handles.roiA(i)=imellipse(uaa.handles.ax(1),roiPos);
            set(uaa.handles.roiA(i),'Tag',rectstr);
            uaa.handles.textA(i) = text(roiPos(1), roiPos(2), num2str(i-1), 'color', 'white', 'Tag', textstr, 'ButtonDownFcn', 'uaa_deleteRoi');
            addNewPositionCallback(uaa.handles.roiA(i),@(p) uaa_updateRoiInfo(p,i,'RoiA'));
            nRois=nRois+1;
        end
    end
% end
% try
    for i=1:size(uaa.T.PolygonRoi,2)
        roiPos=uaa.T.PolygonRoi{frameInd,i};
        if ~isempty(roiPos)
            polystr = ['PolA', num2str(i-1)];
            polytextstr = ['PolyTextA', num2str(i-1)];
            uaa.handles.polyA(i) = impoly(uaa.handles.ax(1),roiPos);
            set(uaa.handles.polyA(i),'Tag',polystr);
            uaa.handles.polyTextA(i) = text(roiPos(1,1)+2, roiPos(1,2)+2, num2str(i-1), 'color', 'white', 'Tag', polytextstr, 'ButtonDownFcn', 'uaa_deleteRoi');
            addNewPositionCallback(uaa.handles.polyA(i),@(p) uaa_updateRoiInfo(p,i,'PolA'));
            nRois=nRois+1;
        end
    end
% end

if nRois>0 %only mark frame as accessed if there are >1 ROIs
    uaa.T.Accessed(uaa.currentFrame)=1;
end

