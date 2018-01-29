function uaa_selectedSpineClickCallback(h,e)
%function runs when spine scatter dot is clicked on
global uaa
if e.Button == 1 && get(uaa.handles.uaa_spineSelectionTool.selectSpinesTB, 'Value')
    uaa_deselectSpines(h,e);
elseif e.Button == 1 && get(uaa.handles.uaa_spineSelectionTool.trackSpinesTB, 'Value')
    tag_spine(h,e);
elseif e.Button == 3
    right_click_menu(h,e);
end

function right_click_menu(h,e)
c = uicontextmenu;
%assign the uicontextmeny to the figure
h.UIContextMenu = c;

%create child menu items
m1 = uimenu(c,'Label','Identify Unique Spine','Callback',{@identify_unique_spine,h});

function identify_unique_spine(source,callbackdata,scatter_handle)
global uaa
% if ~isfield(uaa,'spineTracking')
%     sf = struct('Coordinate',{},'Status',{});
%     s = struct('Tag',{},'Frames',sf);
%     uaa.spineTracking = struct('TrackedSpineTag',[],'Spines',s);
% end
ind = length(uaa.spineTracking.Spines) + 1;
if ~isempty(scatter_handle.Tag)
    newTag = str2double(scatter_handle.Tag);
    ind = [uaa.spineTracking.Spines.Tag] == newTag;
elseif isempty([uaa.spineTracking.Spines.Tag]) %assign Tag irrelevant of struct index in case structs get deleted
    newTag = 1;
    populateStruct(newTag);
else
    newTag = uaa.spineTracking.Spines(end).Tag + 1;
    populateStruct(ind);
end
xy = [scatter_handle.XData,scatter_handle.YData];
uaa.spineTracking.TrackedSpineTag = newTag;
uaa.spineTracking.Spines(ind).Tag = newTag;
uaa.spineTracking.Spines(ind).Frames(uaa.currentFrame).Coordinate = xy;
uaa.spineTracking.Spines(ind).Frames(uaa.currentFrame).Status = 'Present';
scatter_handle.Tag = num2str(newTag);
uaa_markTaggedSpine;
uaa_updateSpineTree;

function populateStruct(ind)
global uaa
for frame = 1:height(uaa.T)
    uaa.spineTracking.Spines(ind).Frames(frame).Coordinate = [];
    uaa.spineTracking.Spines(ind).Frames(frame).Status = 'Absent';
end

function tag_spine(scatter_handle,e)
global uaa
Tag = uaa.spineTracking.TrackedSpineTag;
ind = [uaa.spineTracking.Spines.Tag] == Tag;
frameInd = uaa.currentFrame;
xy = [scatter_handle.XData,scatter_handle.YData];
uaa.spineTracking.Spines(ind).Frames(frameInd).Status = 'Present';
uaa.spineTracking.Spines(ind).Frames(frameInd).Coordinate = xy;

%check if any other spines have the same tag already
s = findall(uaa.handles.Fig1,'Type','Scatter','Tag',num2str(Tag));
for s_ = s'
    s_.Tag = '';
end
scatter_handle.Tag = num2str(Tag);
uaa_markTaggedSpine;
uaa_updateSpineTree;