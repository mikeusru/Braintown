function uaa_popupImageSelectionCallback(hObject,eventdata)
%callback for dropdown menu under images
global uaa
%get index for selected image
val = get(hObject,'value');
ind = (uaa.figIndex==val)';
[c,r] = ind2sub(size(ind),find(ind));
imgInd = get(hObject,'UserData');
uaa.FL(imgInd(1)).indIn{imgInd(2)} = [r,c];
