function uaa_calcAll(command)
%UAA_CALCALL runs through all the frames and does calculations on them
% command (optional) can say 'watershed'
global uaa

if nargin<1
    command='';
end

%go to first frame
uaa_makeFig;
uaa.currentFrame=1;
uaa_updateImage;
if strcmp(command,'watershed')
    uaa.T.Roi(uaa.currentFrame,2:end)=uaa.T.closestPosRoi(uaa.currentFrame,2:end);
end
uaa_showRois;
uaa_updateGUI;

buttonStr=get(uaa.handles.uaa_main.calcAllPushbutton,'String');
k=1; %counter
drawnow;
uaa_calcRoiInfo; %calculate info for current position

try
    while strcmp(buttonStr,'Abort') && k<height(uaa.T)  %as long as user hasn't pressed 'Abort'

        uaa_changeFrame(1,command); %move to next frame;
        drawnow;
        uaa_calcRoiInfo; %calculate info for current position
        
        k=k+1;
        buttonStr=get(uaa.handles.uaa_main.calcAllPushbutton,'String'); %reload button string;

    end
catch ME
    disp(['error: ', ME.message]);
end

uaa_makeCharts;

%reset button back to normal
set(uaa.handles.uaa_main.calcAllPushbutton,'String','Calculate All','ForegroundColor','k');



end

