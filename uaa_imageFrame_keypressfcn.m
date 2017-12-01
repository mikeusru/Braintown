function uaa_imageFrame_keypressfcn(varargin)
%runs when a keyboard key is pressed as the image frame is selected

global uaa
% disp(varargin{2}.Key);
switch varargin{2}.Key
    case 'leftarrow'
        uaa_main('previousFramePushbutton_Callback');
    case 'rightarrow'
        uaa_main('nextFramePushbutton_Callback');
end

if strcmp(get(varargin{1},'tag'),'PerimSelectFig')
    functionsGui('runFcnsPB_Callback');
end