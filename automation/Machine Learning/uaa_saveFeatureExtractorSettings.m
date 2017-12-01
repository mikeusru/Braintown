function uaa_saveFeatureExtractorSettings
global uaa
fName = which('uaa_featureExtractorsGUI.m');
[p,f,e] = fileparts(fName);
feSettingsName = fullfile(p,'Feature Extractors','feSettings.mat');
featureExtractors = uaa.featureExtractors;
save(feSettingsName,'-struct','featureExtractors');