function uaa_clickOnImage(h,e)
%function runs when user clicks on the figure
global uaa
if e.Button == 1 && get(uaa.handles.uaa_spineSelectionTool.selectSpinesTB, 'Value')
    uaa_selectSpines(h,e);
elseif e.Button == 3 && get(uaa.handles.uaa_spineSelectionTool.trackSpinesTB, 'Value')
    right_click_menu(h,e);
end

function right_click_menu(h,e)
c = uicontextmenu;
%assign the uicontextmeny to the figure
h.UIContextMenu = c;

%create child menu items
m1 = uimenu(c,'Label','Spine May Be Obscured','Callback',@spine_may_be_obscured_callback);

function spine_may_be_obscured_callback(source, callbackdata)
global uaa
Tag = uaa.spineTracking.TrackedSpineTag;
ind = [uaa.spineTracking.Spines.Tag] == Tag;
frameInd = uaa.currentFrame;
uaa.spineTracking.Spines(ind).Frames(frameInd).Status = 'Obscured';
uaa.spineTracking.Spines(ind).Frames(frameInd).Coordinate = [];
uaa_updateSpineTree;