function uaa_addNewDataset(loadedDS)
%add new dataset to current dataset. Missing fields from each dataset are
%filled in with appropriate blank values.
global uaa

loadedVars = get(loadedDS,'VarNames');
newDS = uaa.T;

siz1 = size(newDS,1);
siz2 = size(loadedDS,1);
siz3 = siz1 + siz2;
for i=1:length(loadedVars)
    varCols = size(loadedDS.(loadedVars{i}),2);
    newDS.(loadedVars{i})(siz1+1 : siz3,1:varCols) = loadedDS.(loadedVars{i});
end
uaa.T = newDS;