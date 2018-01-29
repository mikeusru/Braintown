function uaa_markTaggedSpine()
%mark the tagged spines with a different color
global uaa
s = findall(uaa.handles.Fig1,'Type','Scatter');

for i = 1:length(s)
    if ~isempty(s(i).Tag)
        s(i).Marker = 'o';
        s(i).MarkerEdgeColor = 'y';
        s(i).MarkerFaceColor = 'w';
        labelThePoint(s(i));
    end
end

CurrentTag = uaa.spineTracking.TrackedSpineTag;
if isempty(CurrentTag)
    return
end
s = findall(uaa.handles.Fig1,'Type','Scatter','Tag',num2str(CurrentTag));
if ~isempty(s)
    s.Marker = 'o';
    s.MarkerEdgeColor = 'y';
    s.MarkerFaceColor = 'k';
    labelThePoint(s);
end

function labelThePoint(s)
global uaa
x = s.XData + 2;
y = s.YData + 2;
ax = findobj(uaa.handles.Fig1,'Type','Axes');
text(ax,x,y,s.Tag);