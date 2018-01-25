function uaa_selectSpines(h,e)
global uaa

%click on spine to select it
ax = get(h,'Parent');
hold(ax, 'on');
markerSiz = 1e5 / max(max(size(uaa.T.Image{uaa.currentFrame,1})) * 4,1000);
scatter(ax,e.IntersectionPoint(1), e.IntersectionPoint(2),markerSiz,...
    'd','filled','MarkerEdgeColor','r','MarkerFaceColor','k',...
    'ButtonDownFcn',@uaa_selectedSpineClickCallback);
hold(ax, 'off');

%save spine info
ind = size(uaa.T.SpineCoordinates{uaa.currentFrame},1)+1;
uaa.T.SpineCoordinates{uaa.currentFrame}(ind,:) = round(e.IntersectionPoint(1:2));