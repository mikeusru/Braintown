function uaa_tagSpineScatters()
global uaa
frame = uaa.currentFrame;
% Tag = uaa.spineTracking.TrackedSpineTag;
% ind = [uaa.spineTracking.Spines.Tag] == Tag;
s = findall(uaa.handles.Fig1,'Type','Scatter');
for ind = 1:length(uaa.spineTracking.Spines) %go through all spines
    if length(uaa.spineTracking.Spines(ind).Frames) >= frame...
            && isfield(uaa.spineTracking.Spines(ind).Frames(frame),'Coordinate')...
            && ~isempty(uaa.spineTracking.Spines(ind).Frames(frame).Coordinate)
        xy = uaa.spineTracking.Spines(ind).Frames(frame).Coordinate;
        xdata = [s.XData];
        ydata = [s.YData];
        s_ind = sum([xdata',ydata'] == xy,2) == 2;
        Tag = uaa.spineTracking.Spines(ind).Tag;
        s(s_ind).Tag = num2str(Tag);
    end
end
%%This function tags the spine which is currently being tracked. make it
%%tag ALL the spines.