function categoryClassifier = uaa_loadTrainingData

global uaa

p = mfilename('fullpath');
[folderName, ~, ~] = fileparts(p);
fileNameML = fullfile(folderName,'categoryClassifier.mat');
if exist(fileNameML,'file')
    answer = questdlg('Use previous machine learning data?');
    switch answer
        case 'Yes'
            uaa.ml.bagOfFeaturesClassifier = load(fileNameML,'categoryClassifier');
            return
        case 'Cancel'
            return
    end
end
pathName='';

if isfield(uaa,'pathName')
    pathName = uaa.pathName;
end

rootFolder = uigetdir(pathName);
uaa.pathName = rootFolder;


categories = dir(rootFolder);
categories = {categories.name};
categories = categories(3:end);

imgSets = [imageSet(fullfile(rootFolder,categories{1})),...
    imageSet(fullfile(rootFolder,categories{2}))];

minSetCount = min([imgSets.Count]); % determine the smallest amount of images in a category

% Use partition method to trim the set.
imgSets = partition(imgSets, minSetCount, 'randomized');

[trainingSet, validationSet] = partition(imgSets, 0.6, 'randomized');

extractorFcn = @uaa_bagOfFeaturesExtractor;
bag = bagOfFeatures(trainingSet,'CustomExtractor',extractorFcn);
% bag = bagOfFeatures(trainingSet);

% img = read(imgSets(1),1);
% featureVector = encode(bag, img);

categoryClassifier = trainImageCategoryClassifier(trainingSet, bag);
uaa.ml.bagOfFeaturesClassifier = categoryClassifier;

cofnMatrix1 = evaluate(categoryClassifier, trainingSet);
confMatrix2 = evaluate(categoryClassifier, validationSet);

% [fName,pName] = uiputfile([rootFolder, '\categoryClassifier.mat'],'Choose where to save classifier');
% if ~isempty(fName)
    save(fileNameML,'categoryClassifier');
% end



%% predict with:
% [labelIdx, scores] = predict(categoryClassifier, img);
% 
% % Display the string label
% categoryClassifier.Labels(labelIdx)

% function [features, featureMetrics] = uaa_bagOfFeaturesExtractor(I)
