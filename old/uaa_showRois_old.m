function uaa_showRois
%uaa_showRois brings the saved ROIs up to the figure

global uaa

if ~isfield(uaa.handles,'roiA') %return of no ROIs are defined
    return;
end

figure(uaa.handles.Fig1);
axes(uaa.handles.ax1);
frameInd=uaa.currentFrame;

for i=1:length(uaa.handles.roiA) %circle ROIs
    try
        spc_roi=uaa.T.Roi{frameInd,i};
        if ~isempty(spc_roi)
            rectstr = ['RoiA', num2str(i-1)];
            textstr = ['TextA', num2str(i-1)];
            
            uaa.handles.roiA(i) = rectangle('Position', spc_roi, 'Tag', rectstr, 'EdgeColor', 'cyan', 'Curvature', [1,1], 'ButtonDownFcn', 'uaa_dragRoi');
            uaa.handles.textA(i) = text(spc_roi(1)-2, spc_roi(2)-2, num2str(i-1), 'color', 'white', 'Tag', textstr, 'ButtonDownFcn', 'uaa_deleteRoi');
        end
    end
    try
        spc_roi=uaa.T.PolygonRoi{frameInd,i};
        if ~isempty(spc_roi)
            xi=spc_roi(:,1);
            yi=spc_roi(:,2);
            
            rectstr = ['RoiA', num2str(i-1)];
            textstr = ['TextA', num2str(i-1)];
            uaa.handles.roiA(i) = line(xi, yi, 'Tag', rectstr, 'color', 'cyan', 'ButtonDownFcn', 'uaa_dragRoiB');
            uaa.handles.textA(i) = text(xi(1)-2, yi(2)-2, num2str(i-1), 'color', 'white', 'Tag', textstr, 'ButtonDownFcn', 'uaa_deleteRoi');
        end
    end
end

