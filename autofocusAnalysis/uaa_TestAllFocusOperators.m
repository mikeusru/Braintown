function afScores = uaa_TestAllFocusOperators(bestFocus)

global uaa

disp('Draw Rectange for Autofocus ROI');

figure(uaa.handles.Fig1);
h=imrect;
accepted_pos=wait(h);

load('operator.mat'); %load list of operators

%% preallocate dataset
% focus values are stored within structure's dataset
siz=size(uaa.T.ImageStack{1,1},3);
space2=size(uaa.T,1)*length(operator);
space=siz*length(operator);
dsNames={'Slice','FocusMeasure','FocusValue','CalculatedSlice','TargetSlice','Score','Time'};
dsFinalNames={'Frame','FocusMeasure','CalculatedSlice','TargetSlice','Score','Time'};
blankDS=dataset([zeros(space,1)],cell(space,1),[zeros(space,1)],[zeros(space,1)],[zeros(space,1)],[zeros(space,1)],[zeros(space,1)],'VarNames',dsNames);
dsFinal=dataset([zeros(space2,1)],cell(space2,1),[zeros(space2,1)],[zeros(space2,1)],[zeros(space2,1)],[zeros(space2,1)],'VarNames',dsFinalNames);


ii=1;
for k=1:size(uaa.T,1)
    disp(k);
    I=uaa.T.ImageStack{k,1};
    ds=blankDS;
    r=1;
    for i=1:siz
        for q=1:length(operator)
            ds.Slice(r,1)=i;
            ds.FocusMeasure(r,1)=operator(q); %record focus measure
            try
                tic;
                ds.FocusValue(r,1)=fmeasure(I(:,:,i),operator{q,1},accepted_pos); %run autofocus function
                ds.Time(r,1)=toc;
            catch
                ds.FocusValue(r,1)=0;
            end
            ds.TargetSlice(r,1)=bestFocus(k);
            r=r+1;
        end
    end
    
    ds.FocusMeasure=categorical(ds.FocusMeasure);
    
    for i=1:length(operator)
        q=ii;
        compds=ds(ds.FocusMeasure==operator{i},:);
        maxind=find(compds.FocusValue==max(compds.FocusValue),1);
        ds.CalculatedSlice(ds.FocusMeasure==operator{i},:)=maxind;
        ds.Score(ds.FocusMeasure==operator{i},:)=abs(ds.CalculatedSlice(ds.FocusMeasure==operator{i},:)-ds.TargetSlice(ds.FocusMeasure==operator{i},:));
        dsFinal.FocusMeasure(q,1)=operator(i);
        dsFinal.Score(q,1)=dsFinal.Score(q,1)+ds.Score(i,1);
        dsFinal.Time(q,1)=mean(ds.Time(ds.FocusMeasure==operator{i},:));
        ii=ii+1;
    end

end

dsFinal.FocusMeasure=categorical(dsFinal.FocusMeasure);

afScores=cell(length(operator),3);

for i=1:length(operator)
    compds=dsFinal(dsFinal.FocusMeasure==operator{i},:);
    afScores{i,2}=sum(compds.Score);
    afScores{i,1}=operator{i};
    afScores{i,3}=mean(compds.Time);
end

