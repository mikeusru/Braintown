function uaa_trainCascadeObjectDetector

global uaa

pathName='';
if isfield(uaa,'pathName')
    pathName = uaa.pathName;
end

positiveImageFolder = uigetdir(pathName,'Positive Image Directory');
uaa.pathName = positiveImageFolder;
negativeFolder = uigetdir(pathName,'Negative Image Directory');
listing = dir(positiveImageFolder);
listing = listing(~[listing.isdir]');
imageFilenames = {listing.name};
imageFilenames = sort(imageFilenames);

boundingBoxes = uaa.T.BoundingBoxes;
boundingBoxes = cellfun(@(x) x', boundingBoxes, 'UniformOutput',false);
positiveImages = cell2struct(boundingBoxes,{'objectBoundingBoxes'},2);
for i = 1:length(positiveImages)
    positiveImages(i).objectBoundingBoxes = cell2mat(positiveImages(i).objectBoundingBoxes);
    imSize = size(uaa_getCurrentImageFrame(i));
    bbSize =  positiveImages(i).objectBoundingBoxes(1,3:4);
    positiveImages(i).objectBoundingBoxes((positiveImages(i).objectBoundingBoxes(:,1) < 1),1) = 1;
    positiveImages(i).objectBoundingBoxes((positiveImages(i).objectBoundingBoxes(:,2) < 1),2) = 1;
    positiveImages(i).objectBoundingBoxes((positiveImages(i).objectBoundingBoxes(:,1) + bbSize(1) > imSize(2)),1) = imSize(2) - bbSize(1);
    positiveImages(i).objectBoundingBoxes((positiveImages(i).objectBoundingBoxes(:,2) + bbSize(2) > imSize(1)),2) = imSize(1) - bbSize(2);   
    positiveImages(i).imageFilename =imageFilenames{i};
end

addpath(negativeFolder, positiveImageFolder);

trainCascadeObjectDetector('spineDetector.xml',positiveImages,...
    negativeFolder,'FalseAlarmRate',0.2,'NumCascadeStages',5);

minSetCount = min([imgSets.Count]); % determine the smallest amount of images in a category

% Use partition method to trim the set.
imgSets = partition(imgSets, minSetCount, 'sequential');

[trainingSet, validationSet] = partition(imgSets, 0.6, 'sequential');

extractorFcn = @uaa_bagOfFeaturesExtractor;
bag = bagOfFeatures(trainingSet,'CustomExtractor',extractorFcn);
% bag = bagOfFeatures(trainingSet);

% img = read(imgSets(1),1);
% featureVector = encode(bag, img);

categoryClassifier = trainImageCategoryClassifier(trainingSet, bag);

cofnMatrix1 = evaluate(categoryClassifier, trainingSet);
confMatrix2 = evaluate(categoryClassifier, validationSet);

[fName,pName] = uiputfile([positiveImageFolder, '\categoryClassifier.mat'],'Choose where to save classifier');
if ~isempty(fName)
    save(fullfile(pName,fName),'categoryClassifier');
end
