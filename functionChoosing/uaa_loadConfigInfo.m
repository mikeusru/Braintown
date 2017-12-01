function [configInfo,ind] = uaa_loadConfigInfo
%UAA_LOADCONFIGINFO loads the file with the ratings and purpose listings
%for the configurations, and finds which one is currently being used with
%the ind

global uaa
funNameList=[uaa.FL.funName];
indIn={uaa.FL(:).indIn};
funIndex = zeros(0,2);
for i=1:length(indIn)
    funIndex=[funIndex;cell2mat(indIn{i})];
end
funIndex=num2str(funIndex(:)');

load('configInfo.mat','configInfo');
ind = strcmp({configInfo.funNameList},funNameList) & strcmp({configInfo.funIndex},funIndex);