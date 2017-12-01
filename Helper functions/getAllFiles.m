function fileList = getAllFiles(dirName,verbose)
%list all files in all subdirectories of dirName
%verbose (optional) shows which files are currently being indexed
if nargin<2
    verbose=false;
end

  dirData = dir(dirName);      % Get the data for the current directory
  dirIndex = [dirData.isdir];  % Find the index for directories
  fileList = {dirData(~dirIndex).name}';  %'# Get a list of the files
  if ~isempty(fileList)
    fileList = cellfun(@(x) fullfile(dirName,x),...  % Prepend path to files
                       fileList,'UniformOutput',false);
  end
  subDirs = {dirData(dirIndex).name};  % Get a list of the subdirectories
  validIndex = ~ismember(subDirs,{'.','..'});  % Find index of subdirectories
                                               %   that are not '.' or '..'
  for iDir = find(validIndex)                  % Loop over valid subdirectories
    nextDir = fullfile(dirName,subDirs{iDir});    % Get the subdirectory path
    if verbose
        disp(nextDir);
    end
    fileList = [fileList; getAllFiles(nextDir,verbose)];  % Recursively call getAllFiles
  end

end