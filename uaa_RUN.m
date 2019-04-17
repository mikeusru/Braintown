function uaa_RUN
%uaa_RUN initiates the image analysis program

global uaa
evalin('base','global uaa');

% load config file
fPath=mfilename('fullpath');
[pName,~,~]=fileparts(fPath);
if exist(fullfile(pName,'uaa_settings.mat'),'file')
    uaa.settings=load(fullfile(pName,'uaa_settings.mat'));
else
    disp([pName,'\uaa_settings.mat']);
    disp('not found. Using default settings.');
    uaa.settings.ignoreFiles={'roiCorrected'};
    uaa_autoOptionsSetDefaultValues;
end

try
    if exist([pName,'\automation\learningAnalysis\ranges.mat'],'file')
        uaa.learningAnalysis.ranges=load([pName,'\automation\learningAnalysis\ranges.mat']);
    end
end

uaa.fxnChoosing.inputCurrentFrame = 1;
uaa.uncageFrame = 5;
loadFeatureExtractorSettings;
%open GUI
uaa_main;
% uaa_makeFig;
T = table;
T = uaa_setupTable(T);
uaa.T = T;
uaa_spineSelectionTool;
functionsGui;
% hide secondary windows
uaa.handles.functionsGui.functionsGUI.Visible = 'off';
uaa.handles.uaa_spineSelectionTool.figure1.Visible = 'off';

function loadFeatureExtractorSettings
global uaa
fName = which('uaa_featureExtractorsGUI.m');
[p,f,e] = fileparts(fName);
feSettingsName = fullfile(p,'Feature Extractors','feSettings.mat');
if exist(feSettingsName,'file')
    uaa.featureExtractors=load(feSettingsName);
else
    uaa.featureExtractors.pdfdb = false;
    uaa.featureExtractors.pdfsb = false;
    uaa.featureExtractors.sttdbil = false;
    uaa_saveFeatureExtractorSettings;
end
    
