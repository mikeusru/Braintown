function uaa_exportDatasetToParts()
    global uaa
    varNames = uaa.T.Properties.VarNames;
    folder_name = uigetdir();
    folder_name = fullfile(folder_name,'cellArrays');
    mkdir(folder_name)
    S = struct;
    for i = 1:length(varNames)
        eval(['S.',genvarname(varNames{i}), ' = uaa.T.', varNames{i}]) 
    end
    filename = fullfile(folder_name,'DataStruct.mat');
    save(filename,'-struct','S')