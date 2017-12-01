function [ output_args ] = uaa_addPolyRoi( i )
%UAA_ADDPOLYROI Summary of this function goes here
%   Detailed explanation goes here
global uaa

i=i+1;
figure(uaa.handles.Fig1);


[xi, yi] = getline;
xi = [xi(:); xi(1)];
yi = [yi(:); yi(1)];
%set(gui.spc.figure.roiA(i), 'Position', spc_roi);
rectstr = ['RoiA', num2str(i-1)];
textstr = ['TextA', num2str(i-1)];
Rois = findobj('Tag', rectstr);
Texts = findobj('Tag', textstr);

for j = 1:length(Rois)
    delete(Rois(j));
end
for j = 1:length(Rois)
    delete(Texts(j));
end

figure(uaa.handles.Fig1);
axes(uaa.handles.ax1);
uaa.handles.roiA(i) = line(xi, yi, 'Tag', rectstr, 'color', 'cyan', 'ButtonDownFcn', 'uaa_dragRoiB');
uaa.handles.textA(i) = text(xi(1)-2, yi(2)-2, num2str(i-1), 'color', 'white', 'Tag', textstr, 'ButtonDownFcn', 'uaa_deleteRoi');


% uaa.rois.roiPoly{i} = [get(uaa.handles.roiA(i), 'XData'), get(uaa.handles.roiA(i), 'YData')];

%% Save ROI to dataset
uaa_updateRoiInfo( i );

figure(uaa.handles.Fig1);
