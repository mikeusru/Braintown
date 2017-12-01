function uaa_runFunctionList(varargin)

global uaa

inputs = {};
if nargin<1
    if uaa.fxnChoosing.inputCurrentFrame
        inputs{1} = uaa_getCurrentImageFrame;
    end
    for i = 1:length(uaa.fxnChoosing.optionalInputVars)
        tempIn =  eval(uaa.fxnChoosing.optionalInputVars{i});
        inputs = [inputs, {tempIn}];
    end
else
    inputs = varargin;
end

%normalize image to 255 gray values (change this later)
if uaa.fxnChoosing.inputCurrentFrame
    inputs{1} = double(inputs{1}) / double(range(inputs{1}(:)));
    [inputs{1},~] = gray2ind(inputs{1}, 255);
end

totalVarList = uaa.fxnChoosing.totalVarList;
uaa.fxnChoosing.tbl = table(cell(size(totalVarList')),'VariableNames',{'OutputData'},'RowNames',totalVarList');
uaa.fxnChoosing.tbl.OutputData(1:length(inputs)) = inputs;

for i = 1:length(uaa.FL)
    funName = uaa.FL(i).funName;
    funOut = uaa.FL(i).funOut;
    funIn = uaa.FL(i).funIn;
    I_In = cell(funIn,1);
    I_Out = cell(funOut,1);
    for j = 1 : funIn
        varLabel = uaa.FL(i).inputs(j).varLabel;
        I_In{j} = uaa.fxnChoosing.tbl.OutputData{varLabel};
    end
    outVars = [repmat({'I_Out'},1,funOut);num2cell(1 : funOut); ];
    outVars = sprintf('%s{%d}, ',outVars{:});
    outVars = outVars(1:end-2);
    inVars = [repmat({'I_In'},1,funIn);num2cell(1 : funIn); ];
    inVars = sprintf('%s{%d}, ',inVars{:});
    inVars = inVars(1:end-2);
    lineOfCode = ['[',outVars,']',' = ',funName,'(',inVars,');'];
    eval(lineOfCode);
    %     eval(['[',outVars,']']) = uaa.sp.(funName)(eval(inVars));
    for j = 1:funOut
        if isempty(I_Out{j})
            I_Out{j} = nan; %prevents empty outputs from being deleted when trying to make figures
        end
        varLabel = uaa.FL(i).funOutVarLabels{j};
        uaa.fxnChoosing.tbl.OutputData{varLabel} = I_Out{j};
    end
end


%% Show images

%remove empty cells
Iall = uaa.fxnChoosing.tbl.OutputData;
emptyInd = ~cellfun(@isempty,Iall);
Iall = Iall(emptyInd);
totalVarList = totalVarList(emptyInd);

%create image display window
if ~isfield(uaa.handles,'imageAnalysis') ...
        || ~isfield(uaa.handles.imageAnalysis,'h')...
        || ~ishandle(uaa.handles.imageAnalysis.h)
    [h,~,panel2,sl] = uaa_createScrollingImageWindow;
    uaa.handles.imageAnalysis.h = h;
    uaa.handles.imageAnalysis.panel2 = panel2;
    uaa.handles.imageAnalysis.sl = sl;
else
    h = uaa.handles.imageAnalysis.h;
    panel2 = uaa.handles.imageAnalysis.panel2;
    sl = uaa.handles.imageAnalysis.sl;
    for i=1:length(uaa.handles.imageAnalysis.transientHandles)
        delete(uaa.handles.imageAnalysis.transientHandles{i});
    end
end

set(h,'UserData',0);
%calculate height and width of figure window;
%max width is 5 images
n = ceil(sqrt(length(Iall)));
if  n>2
    n = 2;
end
m = ceil(length(Iall) / n);
for i=1:length(Iall)
    s(i) = subplot_tight(m,n,i,[0.001,0.001],'Parent',panel2);
    if isa(Iall{i},'numeric') ||...
            isa(Iall{i},'float') ||...
            isa(Iall{i},'integer') ||...
            isa(Iall{i},'logical') ||...
            isa(Iall{i},'gpuArray')
        hi(i) = imagesc(Iall{i},'parent',s(i));
    else
        hi(i) = imagesc(0,'parent',s(i));
    end
    t(i) = title(s(i),totalVarList{i});
end
set(t,'interpreter','none');

axis(s,'off','image');
p = get(panel2,'position');
ratio = max(m/n,1);
set(panel2,'position',[p(1),p(2),p(3),p(3)*ratio]);
set(sl,'max',1-1/(p(3)*ratio));


% removed for now; dropdown box for selecting where the image goes. I think
% this isn't necessary anymore.

% ii=1; skipped = 1; for i = 1:length(uaa.FL)
%     axp = get(s(i + skipped),'outerposition');
%     for j=1:uaa.FL(i).funIn
%         val = uaa.figIndex(uaa.FL(i).indIn{j}(1),uaa.FL(i).indIn{j}(2));
%         popupPos = [axp(1) + (j - 1) * (axp(3)/uaa.FL(i).funIn),axp(2)-axp(4) + 0.05,axp(3)*.9/uaa.FL(i).funIn, axp(4)];
%         popup(ii + skipped) = uicontrol(panel2,'Style','popupmenu','units','normalized','string',uaa.figNames,...
%             'Value',val,'position',popupPos,'UserData',[i,j],'Callback',@uaa_popupImageSelectionCallback);
%         ii=ii+1;
%     end
%     skipped = skipped + uaa.FL(i).funOut - 1;
% end

%objects to delete next round
% uaa.handles.imageAnalysis.transientHandles = {s,hi,popup};
uaa.handles.imageAnalysis.transientHandles = {s,hi};