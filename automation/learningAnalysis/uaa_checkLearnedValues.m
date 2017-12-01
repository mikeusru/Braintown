
%% Load and Concatenate All Datasets
global uaa

pName=uigetdir;
listing=dir(pName);
DS=[];
for i=1:length(listing)
   if ~listing(i).isdir && ~isempty(strfind(listing(i).name,'learningAnalysis'))
       S=load([pName,'\',listing(i).name],'S');
       S=S.S;
       if isempty(DS)
          DS=S;
       else
           DS=vertcat(DS,S);
       end
   end
end

%% Find Best Values
% DS=sortrows(DS,'R','descend');
[~,ia,~]=unique(DS.R);
DS2=DS(ia,:);
DS2=sortrows(DS2,'R','descend');

%% Set Watershed Values and run

for i=1:size(DS2,1)
    
    allValues=DS2.Values{i};
    varLength=length(allValues);
    
    for j=1:varLength
        weightsRange=uaa.learningAnalysis.weights{j};
        eval([uaa.learningAnalysis.rangeCells{j,2},'=allValues(j);']);
    end
    
    uaa_updateGUI(1);
    uaa_updateImage;
    button=questdlg('Continue?','Advance Query','Yes','No','Yes');
    if strcmp(button,'No')
        break
    end
end