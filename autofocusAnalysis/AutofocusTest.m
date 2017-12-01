function afScores = AutofocusTest
%% Instructions for Autofocus Testing

% run uaa_RUN
% open the folder with your files
% run this script. You can run each section individually or everything at
% once.
% follow the instructions in the command window
%% NOTE:
% the variable bestFocus will be saved to the image directory and has the
% focus values you chose in case you want to reuse them
%
% the variable afScores has the scores for the autofocus algorithms and
% will also be saved

%% Code starts here

%% Get Best Focus Values
global uaa
bestFocus = uaa_chooseBestFocusFrames;

%save data
save([uaa.T.Foldername{1,1},'\bestFocus.mat'],'bestFocus');
disp('list of best focused positions saved to');
disp([uaa.T.Foldername{1,1},'\bestFocus.mat']);

%% Run Autofocus Algorithms on them
afScores = uaa_TestAllFocusOperators(bestFocus);
uaa.imageAnalysis.afScores=afScores;
%% Prepare Data
operator=afScores(:,1);
totalSlices=size(uaa.T.ImageStack{1},3);
totalFrames=size(uaa.T,1);
finalScores=cell2mat(afScores(:,2));
finalScores=(totalFrames*totalSlices-finalScores)/(totalFrames*totalSlices)*100;
meanTimes=cell2mat(afScores(:,3));
timePlot=log(meanTimes)-min(log(meanTimes));
timePlot=timePlot/max(timePlot)*100;
timeAxis=min(round(log(meanTimes))):max((round(log(meanTimes))));
timeAxisTickLabels=1*10.^(timeAxis) * 1000;
%make a graph
f=figure;
[ax,b1,b2]=plotyy(1:length(operator),finalScores,1:length(operator),log(meanTimes),'bar','stem');
set(ax(2),'YDir','reverse','YTick',timeAxis,'YTickLabel',flip(timeAxisTickLabels));
set(b2,'color','b','linewidth',5);
set(b1,'FaceColor',[.9,.9,.9],'EdgeColor','k','linewidth',2);
ylabel(ax(2),'Calculation Speed Per Slice(ms)','FontSize',20,'FontWeight','bold');
% b=bar(finalScores);
% hold on
% b2=bar(timePlot,.5,'r');
% ylim([0,100]);
set(ax,'xtick',1:length(operator),'xticklabel',operator,'FontSize',12);
xlabel(ax(1),'Autofocus Algorithm','FontSize',20,'FontWeight','bold');
ylabel(ax(1),'Percent Success','FontSize',20,'FontWeight','bold');

textobj=findall(f,'Type','Text');
set(textobj,'FontName','arial');

%save data
save([uaa.T.Foldername{1,1},'\afScores.mat'],'afScores');
disp('autofocus scores saved to ');
disp([uaa.T.Foldername{1,1},'\afScores.mat']);
savefig(f,[uaa.T.Foldername{1,1},'\afScores.fig']);