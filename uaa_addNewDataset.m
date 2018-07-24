function uaa_addNewDataset(loaded_table)
%add new dataset to current dataset. Missing fields from each dataset are
%filled in with appropriate blank values.
global uaa

loaded_table = uaa_setupTable(loaded_table);
%need this for temp fix. but isn't this all temporary anyway?
loaded_table = uaa_convert_table_column_to_cell(loaded_table,'Scale');
all_vars = unique([loaded_table.Properties.VariableNames,uaa.T.Properties.VariableNames]);
height_home = height(uaa.T);
height_adding = height(loaded_table);
% accomodate for missing data in tables
for i = 1:length(all_vars)
    if ~sum(strcmp(uaa.T.Properties.VariableNames, all_vars{i}))
        switch class(loaded_table.(all_vars{i}))
            case 'cell'
                emptyCol = cell(height_home,1);
            case 'double'
                emptyCol = zeros(height_home,1);
            case 'logical'
                emptyCol = false(height_home,1);
            case 'datetime'
                emptyCol = repmat(datetime,height_adding,1);
        end
        uaa.T.(all_vars{i}) = emptyCol;
    elseif ~sum(strcmp(loaded_table.Properties.VariableNames, all_vars{i}))
        switch class(uaa.T.(all_vars{i}))
            case 'cell'
                emptyCol = cell(height_adding,1);
            case 'double'
                emptyCol = zeros(height_adding,1);
            case 'logical'
                emptyCol = false(height_adding,1);
            case 'datetime'
                emptyCol = repmat(datetime,height_adding,1);
        end
        loaded_table.(all_vars{i}) = emptyCol;                
    end
end
%add tables together
uaa.T = vertcat(uaa.T, loaded_table);
% 
% loadedVars = get(loadedDS,'VarNames');
% newDS = uaa.T;
% 
% siz1 = size(newDS,1);
% siz2 = size(loadedDS,1);
% siz3 = siz1 + siz2;
% for i=1:length(loadedVars)
%     varCols = size(loadedDS.(loadedVars{i}),2);
%     newDS.(loadedVars{i})(siz1+1 : siz3,1:varCols) = loadedDS.(loadedVars{i});
% end
% uaa.T = newDS;