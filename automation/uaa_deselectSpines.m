function uaa_deselectSpines(h,e)
%removes closest marker

global uaa

% --- Get coordinates
x = get(h, 'XData')';
y = get(h, 'YData')';

% --- Get index of the clicked point
[~, i] = min(pdist2([x,y],e.IntersectionPoint(1:2)));

% remove from dataset
[~,ind] = min(pdist2(uaa.T.SpineCoordinates{uaa.currentFrame},[x(i),y(i)]));
uaa.T.SpineCoordinates{uaa.currentFrame}(ind,:) = [];

% remove plot point
delete(h);
