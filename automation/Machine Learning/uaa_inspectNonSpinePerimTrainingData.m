function uaa_inspectNonSpinePerimTrainingData(f,ii)

global uaa

if nargin<2
    ii=1;
    f = figure('Name','Inspect Spine Training Data');
    set(f,'keypressfcn',@moveToNextPerimset);
end

kk = 0;

figure(f); cla; hold on;
axis([0,200,0,50]);
td = zeros(200,0);
lg = {};
for i=1:2
    imageRegions = uaa.T.PerimRegions{ii,1};
    for j=1:size(imageRegions,1)
            if isempty(imageRegions(j).nonSpineTrainData)
                continue
            end
            td = [td, cell2mat(imageRegions(j).nonSpineTrainData')];
            if ~isempty(td)
                spineNumber = 1:length(imageRegions(j).nonSpineTrainData);
                legendNumber = kk + spineNumber;
                for sn = spineNumber
                    lg{legendNumber(sn)} = ['Frame #', num2str(ii), ', Region #', num2str(j), ' Non-Spine #', num2str(sn)];
                end
                kk = kk+length(imageRegions(j).nonSpineTrainData);
            end
    end
    ii=ii+1;
end
if kk>0
    p = plot(td);
    legend(p,lg);
end
set(f,'userdata',ii);


% uaa.ml.inspectSpines.ii = ii;
function moveToNextPerimset(src, event)
if strcmp(event.Key,'rightarrow')
    ii = get(src,'userdata');
    uaa_inspectNonSpinePerimTrainingData(src,ii);
elseif strcmp(event.Key,'leftarrow')
    ii = get(src,'userdata');
    ii = ii - 10;
    uaa_inspectNonSpinePerimTrainingData(src,ii);
end