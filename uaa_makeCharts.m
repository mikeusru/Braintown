function uaa_makeCharts
%UAA_MAKECHARTS draws figures for the data analysis

global uaa

try 
    if isempty(uaa.uncageFrame)
        disp('Error - Enter Frame Before Uncaging to Generate Plots');
    end
catch
    disp('Error - Enter Frame Before Uncaging to Generate Plots');
end

i=1; %graph number. Make this into a loop later when adding more than 1 graph.

hFig=figure('Name','Graph1','NumberTitle','Off','Position',[175,351,926,583]);
hAx=gca;
hold on
set(hAx,'Position',[.085 .1 .85 .84]);
% axis(hAx,'off','square','image');

preFrame=uaa.uncageFrame;
legStr={};
timeAxis=uaa.T.Time-uaa.T.Time(preFrame,1);
uaa.T.PlotTime=timeAxis;
for j=1:size(uaa.T.RoiSum,2)
    if ~(sum(uaa.T.RoiSum(:,j))==0)
        startFrame=preFrame-4;
        if startFrame<1
            startFrame=1;
        end
        preMean=mean(uaa.T.RoiSum(startFrame:preFrame,j));% Standardize values to post-uncaging duration
        plot(hAx,timeAxis,uaa.T.RoiSum(:,j)/preMean,'LineWidth',2);
        uaa.T.StandardRoiMean(:,j)=uaa.T.RoiSum(:,j)/preMean;
        legStr=[legStr,['Roi',num2str(j-1)]]; % add to legend
    end
end
for j=1:size(uaa.T.PolySum,2)
    if ~(sum(uaa.T.PolySum(:,j))==0)
        startFrame=preFrame-4;
        preMean=mean(uaa.T.PolySum(startFrame:preFrame,j));% Standardize values to post-uncaging duration
        plot(hAx,timeAxis,uaa.T.PolySum(:,j)/preMean,'LineWidth',2);
        uaa.T.StandardPolyMean(:,j)=uaa.T.PolySum(:,j)/preMean;
        legStr=[legStr,['Polygon',num2str(j-1)]]; %add to legend
    end
end

% Convert y-axis values to percentage values by multiplication
    a=cellstr(num2str(get(hAx,'ytick')'*100)); 
% Create a vector of '%' signs
     pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
     new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
     set(hAx,'yticklabel',new_yticks);
     
%make legend
legend(hAx,legStr);

xlabel(hAx,'Time (min)');
ylabel(hAx,'Volume');


uaa.handles.graphs(i)=hFig;
uaa.handles.graphAx(i)=hAx;
hold off

%jokes are fun too.
a=randi(50);
if a==13
    disp('In Soviet Russia, data analyze YOU');
end
end

