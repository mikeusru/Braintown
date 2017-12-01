    function uaa_imageClickFcn(src,eventdata)
        global uaa
        
        disp(src);
        disp(eventdata);
%         ax = axes('parent',src.UserData{2},'position',get(src.UserData{2},'position'),'visible','off','tag',['connectorLine',num2str(src.UserData{1})]);
%         axis(ax,[0 1 0 1]);
%         imline(ax);
    end