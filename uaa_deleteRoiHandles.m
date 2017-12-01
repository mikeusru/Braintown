function uaa_deleteRoiHandles
%UAA_DELETEROIHANDLES deletes the currently visible roi handles.

global uaa

roiHandles=findall(uaa.handles.Fig1,'Type','hggroup');
delete(roiHandles);

try
    for i=1:length(uaa.handles.roiA)
%         delete(uaa.handles.roiA(i));
        delete(uaa.handles.textA(i));
    end
end

try
    for i=1:length(uaa.handles.polyA)
%         delete(uaa.handles.polyA(i));
        delete(uaa.handles.polyTextA(i));
    end
end

end

