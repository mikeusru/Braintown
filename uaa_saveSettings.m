function uaa_saveSettings(wShed,ranges)
%   uaa_saveSettings saves uaa.settings to uaa_settings.mat
% wShed (optional) indicates whether only watershed settings should be
% saved, in which case they are saved to the automation/watershed_settings
% folder. this is off by default.
global uaa

if nargin<1
    wShed=false;
end

if nargin<2
    ranges=false;
end

fPath=mfilename('fullpath');
[pName,~,~]=fileparts(fPath);
baseDir=pName;
if wShed
    S=uaa.settings.watershed;
    fName=matlab.lang.makeValidName(uaa.settings.watershed.fName);
    pName=[pName,'\automation\watershed_settings\',fName,'.mat'];
elseif ranges
    S=uaa.learningAnalysis.ranges;
	pName=[pName,'\automation\learningAnalysis\ranges.mat'];
    if ~exist([baseDir, '\automation\learningAnalysis'],'dir')
        mkdir([baseDir, '\automation\learningAnalysis']);
    end
else
    pName=[pName,'\uaa_settings.mat'];
    S=uaa.settings;
end
save(pName,'-struct','S');
