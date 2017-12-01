function allValues = uaa_randomizeValues
% randomize values for watershed analysis using previously collected
% weights, or create a new array of equal weights.
global uaa

% valFields=fieldnames(uaa.settings.watershed);
% ind=~cellfun(@isempty,strfind(valFields,'fName'));
% valFields(ind)=[];
varLength=size(uaa.learningAnalysis.rangeCells,1);



allValues=zeros(1,(varLength));
for i=1:varLength
    weightsRange=uaa.learningAnalysis.weights{i};
    randInd=randweightedpick(weightsRange,1); %pick index
    randVal=uaa.learningAnalysis.rangeCells{i,1}(randInd);
    eval([uaa.learningAnalysis.rangeCells{i,2},'=randVal;']);
    allValues(i)=randVal;
end



end