function uaa_updateGUI( wShed,handles )
% uaa_updateGUI updates the uaa gui. duh.
% wShed is an optional value indicating whether to update all the watershed
% uptions
global uaa

if nargin<2
    handles=[];
end

if nargin<1
    wShed=false;
end
% uaa.test.handles=handles;
if ~isempty(handles)
   if strcmp(get(handles,'Tag'),'largeImageGui') || strcmp(get(handles.Parent,'Tag'),'largeImageGui')
           imshow(uaa.imageAnalysis.analyzedFigs{uaa.imageAnalysis.largeImage},'Parent',uaa.handles.uaa_largeImageGui.axes1);
   set(uaa.handles.uaa_largeImageGui.imageIdText,'String',uaa.imageAnalysis.figNames{uaa.imageAnalysis.largeImage});
   end
end

try
    set(uaa.handles.uaa_main.currentFrameEdit,'String',num2str(uaa.currentFrame));
end
try
    set(uaa.handles.uaa_main.uncageFrameEdit,'String',num2str(uaa.uncageFrame));
end
try
    set(uaa.handles.uaa_main.totalFramesEdit,'String',num2str(size(uaa.T,1)));
end

try
    h=get(uaa.handles.uaa_autoOptions.watershedAnalysisUipanel,'Children');
    switch uaa.settings.watershed.doWatershed
        case 1
            set(h,'Enable','on');
        case 0
            set(h,'Enable','off');
    end
end
%show scale in functionsGui
if ishandle(uaa.handles.functionsGui.functionsGUI)
    if sum(contains(uaa.T.Properties.VariableNames,'Scale'))
        set(uaa.handles.functionsGui.pixel_per_um_ED,'String',num2str(cell2mat(uaa.T.Scale(uaa.currentFrame))));
    end
    %show resolution in functionsGui
    w_h = size(cell2mat(uaa.T.Image(uaa.currentFrame)));
    resolution_text = sprintf('%dx%dpx',w_h(1),w_h(2));
    set(uaa.handles.functionsGui.resolution_TX,'String',resolution_text);
end

if wShed
    try
        varNames=fieldnames(uaa.settings.watershed);
        for i=1:length(varNames)
            try
                editVar=[varNames{i},'vEdit'];
                sliderVar=[varNames{i},'Slider'];
                set(uaa.handles.uaa_autoOptions.(editVar),'String',num2str(uaa.settings.watershed.(varNames{i})));
                set(uaa.handles.uaa_autoOptions.(sliderVar),'Value',uaa.settings.watershed.(varNames{i}));
            end
        end
%         set(uaa.handles.uaa_autoOptions.gbrvEdit,'String',num2str(uaa.settings.watershed.gbr));
%         set(uaa.handles.uaa_autoOptions.bw3iovEdit,'String',num2str(uaa.settings.watershed.bw3io));
%         set(uaa.handles.uaa_autoOptions.bw4aovEdit,'String',num2str(uaa.settings.watershed.bw4ao));
%         set(uaa.handles.uaa_autoOptions.bw5aovEdit	,'String',num2str(uaa.settings.watershed.bw5ao));
%         set(uaa.handles.uaa_autoOptions.mslvEdit,'String',num2str(uaa.settings.watershed.bw5spur));
%         set(uaa.handles.uaa_autoOptions.bw6imcvEdit,'String',num2str(uaa.settings.watershed.bw6imc));
%         set(uaa.handles.uaa_autoOptions.bw7aovEdit,'String',num2str(uaa.settings.watershed.bw7ao));
        set(uaa.handles.uaa_autoOptions.doWatershedCheckbox,'Value',uaa.settings.watershed.doWatershed);
%         set(uaa.handles.uaa_autoOptions.imexvEdit,'String',num2str(uaa.settings.watershed.imex));
        set(uaa.handles.uaa_autoOptions.inverseCheckbox,'Value',uaa.settings.watershed.inverseImage);
%         set(uaa.handles.uaa_autoOptions.mbwaovEdit,'String',num2str(uaa.settings.watershed.mbwao));
%         set(uaa.handles.uaa_autoOptions.micvEdit,'String',num2str(uaa.settings.watershed.mic));
        set(uaa.handles.uaa_autoOptions.removeTransparencyCheckbox,'Value',uaa.settings.watershed.removeTransparency);
%         set(uaa.handles.uaa_autoOptions.tfdvEdit,'String',num2str(uaa.settings.watershed.tfd));
    catch me
        disp(me.message);
        disp('Error - Not all watershed settings could be loaded successfully');
    end
end
