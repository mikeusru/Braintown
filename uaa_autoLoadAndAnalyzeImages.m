function uaa_autoLoadAndAnalyzeImages

global uaa

%% wait for image to appear and then load it
[f,p] = uigetfile();
fullPath = fullfile(p,f);
uaa_loadImageStruct(fullPath);
%
%%

%resize image to work with spine finding
rc = uaa.imageInfo.umPerPixel / 0.065; %resize constant
for i=1:length(uaa.T.Image)
    uaa.T.Image{i} = imresize(uaa.T.Image{i},rc);
end
uaa.imageInfo.umPerPixel = 0.065;

%% find spines in 10µm z projections
%create 10µm projections
zStep = uaa.imageInfo.zStep;
zProjectionRanges = ceil([3/zStep, 10/zStep]);
uaa_calculateRegionalZStacks(zProjectionRanges);

%run analysis every 5 µm
minZ = ceil(zProjectionRanges(1)/2);
ii = 1;
spinePositions = struct;
for i = minZ : 1 : size(uaa.T.ImageRegional,1) - minZ
    uaa.currentFrame = i;
    uaa_changeFrame(2);
    uaa_runFunctionList(uaa.T.ImageRegional{uaa.currentFrame,1});
    [~, spinePositions(ii).posNarrow] = uaa_locateSpinesUsingSpinePerimDistNeuralNetwork;
    uaa_runFunctionList(uaa.T.ImageRegional{uaa.currentFrame,2});
    [~, spinePositions(ii).posWide] = uaa_locateSpinesUsingSpinePerimDistNeuralNetwork;
    spinePositions(ii).Zpos = i;
    ii = ii + 1;
end

%% preview whole image
Imax = reshape(uaa.T.Image,1,1,[]);
Imax = max(double(cell2mat(Imax)),[],3);
uaa_runFunctionList(Imax);
[~, pos] = uaa_locateSpinesUsingSpinePerimDistNeuralNetwork;
figure; imagesc(Imax); axis image off
colormap gray
hold on
scatter(pos(:,1),pos(:,2));

%% preview each one
for i=1:length(spinePositions)
    f = figure; imagesc(uaa.T.ImageRegional{spinePositions(i).Zpos,1});
    axis image off
    colormap gray
    hold on
    str = sprintf('%s%d','Z = ', spinePositions(i).Zpos);
    text(20,30,str,'color','white');
    posNarrow = spinePositions(i).posNarrow;
    posWide = spinePositions(i).posWide;
    [D,ind] = pdist2(posWide(:,1:2),posNarrow(:,1:2),'euclidean','Smallest',1);
	pos = posWide(ind(D<5),1:2);
    scatter(pos(:,1),pos(:,2),'r');
    drawnow;
    fName = sprintf('%s%d','frame',i);
    print(f,fName,'-dtiff');
end
