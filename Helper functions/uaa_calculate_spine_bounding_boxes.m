function uaa_calculate_spine_bounding_boxes()

global uaa
for i = 1:height(uaa.T)
    scale_px_per_um = cell2mat(uaa.T.Scale(i));
    if isempty(scale_px_per_um)
        scale_px_per_um = 10;
    end
    rect_side = str2double(get(uaa.handles.uaa_spineSelectionTool.posTrainED,'String'));
    rect_side = rect_side * scale_px_per_um/15;
    spine_coordinates = cell2mat(uaa.T.SpineCoordinates(i));
    rect_side_repeated = repmat(rect_side,length(spine_coordinates(:,1)), 1);
    bounding_boxes = [spine_coordinates(:,1)-rect_side/2,spine_coordinates(:,2) - rect_side/2, rect_side_repeated, rect_side_repeated];
    uaa.T.BoundingBoxes(i) = {bounding_boxes};
end