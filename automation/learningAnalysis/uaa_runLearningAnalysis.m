function uaa_runLearningAnalysis
% runs the learning analysis algorithm on the loaded image

global uaa

uaa_autoOptions;
set(uaa.handles.uaa_autoOptions.learningAnalysisTogglebutton,'Value',1);
pName=uigetdir;

I=uaa_getCurrentImageFrame;
hI=figure;
hIax=axes('Parent',hI,'Position',[0 0 1 1]);
imagesc(I,'Parent',hIax);
axis(hIax,'off','equal');



uaa.learningAnalysis.analysisResults=dataset;


disp('Click on each spine you want to identify once. Hit Enter when done.');
[x,y]=ginput;

x=round(x);
y=round(y);
spineCount=length(x);
disp([num2str(spineCount) ' Coordinates Collected.']);
uaa.learningAnalysis.spineCoordinates=[x,y];
hold(hIax,'on');
scatter(x,y,'filled','r');
drawnow;
contCheck=input('Continue? (1 for yes) ');
if ~(contCheck==1)
    return
end

% uaa.T=[];
% disp('Image loaded and uaa.T deleted to conserve memory');


blankSpines=zeros(size(I));
spineInd=sub2ind(size(I),y,x);
blankSpines(spineInd)=1;


ds=createBlankLearningDataset;

hW=figure('Name','Weights');
% valFields=fieldnames(uaa.settings.watershed);
% ind=~cellfun(@isempty,strfind(valFields,'fName'));
% valFields(ind)=[];
% varLength=length(valFields);
uaa_setWatershedRanges;

%preallocate list of top 10 configs
topConfigs={'R','Values','Ranges';0,zeros(1,size(uaa.learningAnalysis.rangeCells,1)),uaa.learningAnalysis.rangeCells};
topConfigs=[topConfigs(1,:);repmat(topConfigs(2,:),10,1)];
uaa.learningAnalysis.topConfigs=cell2dataset(topConfigs);


varLength=size(uaa.learningAnalysis.rangeCells,1);
uaa.learningAnalysis.weights=cell(1,varLength);
for i=1:varLength %set all weights to 0
    uaa.learningAnalysis.weights{i}=ones(1,length(uaa.learningAnalysis.rangeCells{i,1}));
end


for j=1:varLength
    hSubAx(j)=subplot(4,4,j,'Parent',hW);
end

ii=1;
iii=1;
while get(uaa.handles.uaa_autoOptions.learningAnalysisTogglebutton,'Value')
    try
        [allValues , r] = runRandomizedAnalysis();
        ds.Values{1}=allValues;
        ds.R(1)=r;
    catch err
        ds.Error{1}=err;
    end
    uaa.learningAnalysis.analysisResults=vertcat(uaa.learningAnalysis.analysisResults,ds);
    ii=ii+1;
    disp(['Run: ' , num2str(ii)]);
    if mod(ii,10000)==0
        saveLearningData(iii);
        iii=iii+1;
        ds=createBlankLearningDataset;
    end
end

if ~get(uaa.handles.uaa_autoOptions.learningAnalysisTogglebutton,'Value')
    saveLearningData(iii+1);
end


    function [allValues,r] = runRandomizedAnalysis()
        allValues = uaa_randomizeValues;
        analyzedStruct = uaa_watershedWithOptions( I );
        xC=analyzedStruct.stats.Centroid(:,1);
        yC=analyzedStruct.stats.Centroid(:,2);
        measuredSpineCount=length(xC);
        
        %create image of spine locations and calculate its 2D correlational coefficient
        if measuredSpineCount>0
            xC=round(xC);
            yC=round(yC);
            calcSpines=zeros(size(I));
            calcSpineInd=sub2ind(size(I),yC,xC);
            calcSpines(calcSpineInd)=1;
            r=corr2(blankSpines,calcSpines);
            if r<0
                r=0;
            end
        else
            r=0;
        end
       
        if r>0
            addWeightValues(r);
            checkTop10(allValues,r);
        end
        
    end

    function addWeightValues(r)
        for i=1:varLength
            rng=uaa.learningAnalysis.rangeCells{i,1};
            valField=uaa.learningAnalysis.rangeCells{i,2};
            if length(rng)<2
                continue;
            end
            mu=eval(valField);
            sig=length(rng)/100;
            norm=normpdf(rng,mu,sig);
            weightNorms=r*norm;
            uaa.learningAnalysis.weights{i}=uaa.learningAnalysis.weights{i}+weightNorms;
            plotNewWeights;
        end
        
    end

    function plotNewWeights
        for i=1:varLength
            plot(hSubAx(i),uaa.learningAnalysis.rangeCells{i,1},uaa.learningAnalysis.weights{i});
            title(hSubAx(i),uaa.learningAnalysis.rangeCells{i,2});
        end
    end

    function saveLearningData(fNum)
        S=uaa.learningAnalysis.analysisResults;
        W=uaa.learningAnalysis.weights;
        R=uaa.learningAnalysis.rangeCells;
        save([pName,'\learningAnalysis',num2str(fNum),'.mat'],'S','W','R');
        
    end

    function ds = createBlankLearningDataset
        dsc={'Values','R','Error';{[]},0,{[]}};
        ds=cell2dataset(dsc);
        uaa.learningAnalysis.analysisResults=ds;
    end

    function checkTop10(allValues,r)
        minInd=find(uaa.learningAnalysis.topConfigs.R==min(uaa.learningAnalysis.topConfigs.R),1);
        if r>uaa.learningAnalysis.topConfigs.R(minInd,1)...
                && ~ismember(allValues,uaa.learningAnalysis.topConfigs.Values,'rows')
            uaa.learningAnalysis.topConfigs.R(minInd,1)=r;
            uaa.learningAnalysis.topConfigs.Values(minInd,:)=allValues;
            S=uaa.learningAnalysis.topConfigs;
            save([pName,'\topConfigs','.mat'],'S');
        end
    end
end