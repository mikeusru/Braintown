function uaa_deepLearningImageClassifierTrainer

global uaa

p = mfilename('fullpath');
[folderName, ~, ~] = fileparts(p);
fileNameML = fullfile(folderName,'ml.mat');
if exist(fileNameML,'file')
    answer = questdlg('Use previous machine learning data?');
    switch answer
        case 'Yes'
            uaa.ml = load(fileNameML);
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

imds = imageDatastore(fullfile(rootFolder, categories(1:2)), 'LabelSource', 'foldernames');
% imgSets = [imageSet(fullfile(rootFolder,categories{1})),...
%     imageSet(fullfile(rootFolder,categories{2}))];
tbl = countEachLabel(imds);

minSetCount = min(tbl{:,2}); % determine the smallest amount of images in a category

% Use partition method to trim the set.
imds = splitEachLabel(imds, minSetCount,'randomized');

% Location of pre-trained "AlexNet"
cnnURL = 'http://www.vlfeat.org/matconvnet/models/beta16/imagenet-caffe-alex.mat';
% Store CNN model in a temporary folder
cnnMatFile = fullfile(tempdir, 'imagenet-caffe-alex.mat');

if ~exist(cnnMatFile, 'file') % download only once
    disp('Downloading pre-trained CNN model...');
    websave(cnnMatFile, cnnURL);
end
% Load MatConvNet network into a SeriesNetwork
convnet = helperImportMatConvNet(cnnMatFile);

imds.ReadFcn = @(filename)uaa_readAndPreProcessImageForClassifier(filename);

[trainingSet, testSet] = splitEachLabel(imds, 0.3,'randomized');

% % Get the network weights for the second convolutional layer
% w1 = convnet.Layers(2).Weights;
%
% % Scale and resize the weights for visualization
% w1 = mat2gray(w1);
% w1 = imresize(w1,5);
%
% % Display a montage of network weights. There are 96 individual sets of
% % weights in the first layer.
% figure
% montage(w1)
% title('First convolutional layer weights')

featureLayer = 'fc7';
trainingFeatures = activations(convnet, trainingSet, featureLayer, ...
    'MiniBatchSize', 32, 'OutputAs', 'columns');

% Get training labels from the trainingSet
trainingLabels = trainingSet.Labels;

% Train multiclass SVM classifier using a fast linear solver, and set
% 'ObservationsIn' to 'columns' to match the arrangement used for training
% features.
classifier = fitcecoc(trainingFeatures, trainingLabels, ...
    'Learners', 'Linear', 'Coding', 'onevsall', 'ObservationsIn', 'columns');

uaa.ml.classifier = classifier;
uaa.ml.testSet = testSet;
uaa.ml.convnet = convnet;
uaa.ml.featureLayer = featureLayer;
disp('done training...');

disp('Saving Training Data');


ml = uaa.ml;
% p = mfilename('fullpath');
% [folderName, ~, ~] = fileparts(p);
% fileNameML = fullfile(folderName,'ml.mat');
save(fileNameML,'-struct','ml');



% Extract test features using the CNN
testFeatures = activations(convnet, testSet, featureLayer, 'MiniBatchSize',32);

% Pass CNN image features to trained classifier
predictedLabels = predict(classifier, testFeatures);

% Get the known labels
testLabels = testSet.Labels;

% Tabulate the results using a confusion matrix.
confMat = confusionmat(testLabels, predictedLabels);

% Convert confusion matrix into percentage form
confMat = bsxfun(@rdivide,confMat,sum(confMat,2))

%
% [trainingSet, validationSet] = partition(imgSets, 0.6, 'sequential');
%
% extractorFcn = @uaa_bagOfFeaturesExtractor;
% bag = bagOfFeatures(trainingSet,'CustomExtractor',extractorFcn);
% % bag = bagOfFeatures(trainingSet);
%
% % img = read(imgSets(1),1);
% % featureVector = encode(bag, img);
%
% categoryClassifier = trainImageCategoryClassifier(trainingSet, bag);
%
% cofnMatrix1 = evaluate(categoryClassifier, trainingSet);
% confMatrix2 = evaluate(categoryClassifier, validationSet);
%
% [fName,pName] = uiputfile([rootFolder, '\categoryClassifier.mat'],'Choose where to save classifier');
% if ~isempty(fName)
%     save(fullfile(pName,fName),'categoryClassifier');
% end


%% predict with:
% [labelIdx, scores] = predict(categoryClassifier, img);
%
% % Display the string label
% categoryClassifier.Labels(labelIdx)

% function [features, featureMetrics] = uaa_bagOfFeaturesExtractor(I)


