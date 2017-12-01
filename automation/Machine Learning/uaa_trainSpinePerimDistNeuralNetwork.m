function [net,tr,x,t] = uaa_trainSpinePerimDistNeuralNetwork(allSpinePerims, allNonSpinePerims)

global uaa

% allSpinePerims = [allSpinePerims{:}];
% allNonSpinePerims = [allNonSpinePerims{:}];
[x,t] = makeTrainingData(allSpinePerims',allNonSpinePerims');

% SPI = cellfun(@(x) reshape(x,[],1), allSpinePerimImages,'UniformOutput',false);
% NSPI = cellfun(@(x) reshape(x,[],1), allNonSpinePerimImages,'UniformOutput',false);
% SPI = [SPI{:}];
% NSPI= [NSPI{:}];
% %x is input matrix, t is target matrix
% [x,t] = makeTrainingData(SPI,NSPI);

% x = [allSpinePerims, allNonSpinePerims];
% t = false(2,size(x,2));
% t(1,1:size(allSpinePerims,2)) = true;
% t(2,:) = ~(t(1,:));


%%
net = patternnet(20);

[net,tr] = train(net,x,t);
view(net);

nntraintool
uaa.ml.net = net;

[FileName,PathName] = uiputfile('*.mat');
fname = fullfile(PathName, FileName);
save(fname,'net');
fprintf('Saved %s\n',fname);


function [x,t] = makeTrainingData(positiveExamples,negativeExamples)
% positiveExamples = SPI;
% negativeExamples = NSPI;
x = [positiveExamples, negativeExamples];
t = false(2,size(x,2));
t(1,1:size(positiveExamples,2)) = true;
t(2,:) = ~(t(1,:));
