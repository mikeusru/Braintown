function uaa_inspectSpinePerimTrainingData(f,ii)

global uaa

if nargin<2
    ii=1;
    f = figure('Name','Inspect Spine Training Data');
    set(f,'keypressfcn',@moveToNextPerimset);
end

% ii = 1;
kk = 1;

figure(f); cla; hold on;
axis([0,200,0,50]);

for i=1:5
    imageRegions = uaa.T.PerimRegions{ii,1};
    for j=1:size(imageRegions,1)
        for k = 1:size(imageRegions(j).spineTrainData,1)
            if isempty(imageRegions(j).spineTrainData)
                continue
            end
            td = imageRegions(j).spineTrainData{k};
            if iscell(td)
                td = td{1};
            end
            if ~isempty(td) && ~uaa.T.PerimRegions{ii,1}(j).ignoreSpine(k)
                p(kk) = plot(td,'linewidth',2);
                lg{kk} = ['Frame #', num2str(ii), ', Region #', num2str(j), ' Spine #', num2str(k)];
                kk = kk+1;
            end
        end
    end
    ii=ii+1;
end
if kk>1
    legend(p,lg);
end
set(f,'userdata',ii);


% uaa.ml.inspectSpines.ii = ii;
function moveToNextPerimset(src, event)
if strcmp(event.Key,'rightarrow')
    ii = get(src,'userdata');
    uaa_inspectSpinePerimTrainingData(src,ii);
elseif strcmp(event.Key,'leftarrow')
    ii = get(src,'userdata');
    ii = ii - 10;
    uaa_inspectSpinePerimTrainingData(src,ii);
end