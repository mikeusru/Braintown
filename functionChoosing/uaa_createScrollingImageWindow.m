function [hF,panel1,panel2,s] = uaa_createScrollingImageWindow()
% draws figure which scrolls. All images should be drawn with panel2 as their parent.

hF = figure('Name','Image Analysis','NumberTitle','off','SizeChangedFcn',@resizeui);
panel1 = uipanel('Parent',hF,'tag','panel1');
panel2 = uipanel('Parent',panel1);
set(panel1,'Position',[0 0 0.95 1]);
set(panel2,'Position',[0 0 1 1]);

s = uicontrol('Style','Slider','Parent',hF,...
    'Units','normalized','Position',[0.95 0 0.05 1],...
    'Value',0,'Callback',{@slider_callback1,panel2},'Tag','WindowSlider');


function slider_callback1(src,eventdata,arg1)
val = get(src,'Value');
p = get(arg1,'Position');
bot = (-val)*p(4);
% bot(bot>0) = 0; %position should always be negative
set(arg1,'Position',[p(1) bot p(3) p(4)]);

function resizeui(hObject,callbackdata)
s = findobj(hObject,'Style','Slider','Tag','WindowSlider');
set(s,'units','pixels');
p = get(s,'position');
if ~isempty(p) %position is empty during creation
    set(s,'position',[p(1)+p(3)-20,p(2),20,p(4)]);
    set(s,'units','normalized'); 
end
% ax = findobj(hObject,'Type','Axes');
% disp(ax);
