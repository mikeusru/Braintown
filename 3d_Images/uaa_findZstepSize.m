function [zStepSize,zoomFactor] = uaa_findZstepSize

global uaa

fName=[uaa.T.Foldername{1},uaa.T.Filename{1}];
imgInfo=imfinfo(fName);
imDesc=strsplit(imgInfo(1).ImageDescription);

Keys={'state.acq.zStepSize','state.acq.zoomFactor'};
Values=zeros(1,length(Keys));

for i=1:length(Keys)
    ind=strfind(imDesc,Keys{i});
    ind=find(~cellfun(@isempty,ind));
    if ~isempty(ind)
        Str=imDesc{ind};
        Str(strfind(Str, '=')) = [];
        Index = strfind(Str, Keys{i});
        Values(i) = sscanf(Str(Index(1) + length(Keys{i}):end), '%g', 1);
    end
end

zStepSize=Values(1);
zoomFactor=Values(2);