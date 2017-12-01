function [ output_args ] = uaa_makeFig( makeNew )
%UAA_MAKEFIG checks if the figure is needed and makes it if necessary
% makeNew (optional) is a boolean indicating whether to refresh the figure
% even if it exists. it is off by default.
global uaa

%%subplot size
try
    if uaa.settings.watershed.doWatershed
        s=[4,3];
    elseif uaa.settings.golgi.doGolgi
        s=[4,3];
    else
        s=[1,1];
    end
catch
    s=[1,1];
end
%%

if nargin<1
    makeNew=0;
end

%fig1
if ~isfield(uaa,'handles') || ~isfield(uaa.handles,'Fig1') || ~ishandle(uaa.handles.Fig1) || makeNew
    try
        (delete(uaa.handles.Fig1));
    end
    uaa.handles.Fig1=figure('Name','Image Frame','NumberTitle','Off','MenuBar','none','KeyPressFcn',@uaa_imageFrame_keypressfcn);
    %record axes handles
    for i=1:s(1)*s(2)
        uaa.handles.ax(i)=subplot_tight(s(1),s(2),i,.03,'Parent',uaa.handles.Fig1);
    end
    
    %set properties for all axes
    %     axesHandles = findobj(get(uaa.handles.Fig1,'Children'), 'flat','Type','axes');
    % Set the axis properties
    h=uaa.handles.ax(ishandle(uaa.handles.ax));
    axis(h,'equal','off','image');
    
end

end

