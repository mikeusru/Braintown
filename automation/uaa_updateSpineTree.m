function uaa_updateSpineTree()
global uaa

if ~isfield(uaa.handles,'spineTreeUIFigure') || ~ishandle(uaa.handles.spineTreeUIFigure)
    [uaa.handles.spineTreeUIFigure] = makeTheFigure;
end

t = findobj(uaa.handles.spineTreeUIFigure,'Type','uitree');
populateTree(t);

    function [f,t] = makeTheFigure()
        f = uifigure('Name','Spine Tracking Info');
        t = uitree(f,'Position',[20 20 200 400]);
        
        %spine status panel
        spine_status_panel = uipanel(f);
        spine_status_panel.Title = 'Spine Information';
        spine_status_panel.FontName = 'MS Sans Serif';
        spine_status_panel.Position = [230 120 200 300];
        %spine status label
        status_label = uitextarea(spine_status_panel);
        status_label.HorizontalAlignment = 'left';
        status_label.Position = [0 0 200 280];
        % Assign Tree callback in response to node selection
        t.SelectionChangedFcn = {@nodechange,f};
    end

    function populateTree(t)
        delete(t.Children);
        % First level nodes
        catLevel = containers.Map;
        for tag = [uaa.spineTracking.Spines.Tag]
            tag_str = num2str(tag);
            catLevel(tag_str) = uitreenode(t,'Text',['Spine ', tag_str],'NodeData',[]);
            ind = [uaa.spineTracking.Spines.Tag] == tag;
            for i = 1:length(uaa.spineTracking.Spines(ind).Frames)
                fields = fieldnames(uaa.spineTracking.Spines(ind).Frames(i));
                node_data ={['Spine ',tag_str]};
                for field = fields'
                    node_data{end+1} = field{1};
                    val = uaa.spineTracking.Spines(ind).Frames(i).(field{1});
                    if isnumeric(val)
                        val = num2str(val);
                    end
                    node_data{end+1} = val;
                end
                uitreenode(catLevel(tag_str),'Text',['Frame ',num2str(i)],'NodeData',node_data);
            end
        end
        
        % Expand the tree
%         expand(t);
    end

    function nodechange(src,event,f)
        node = event.SelectedNodes;
        if ~isempty(node.NodeData)
            infohere = findobj(f,'Type','uitextarea');
            infohere.Value = node.NodeData';
        end
    end
end