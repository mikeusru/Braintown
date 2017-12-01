function [ trainingTable ] = uaa_createSpinePerimTrainingData(saveImages)

global uaa
if nargin<1
    saveImages = false;
end

if saveImages
    folder_name = uigetdir;
    folder_name_pos = fullfile(folder_name,'PositiveSpinePerims');
    folder_name_neg = fullfile(folder_name,'NegativeSpinePerims');
    mkdir(folder_name_pos);
    mkdir(folder_name_neg);
end

structInd = 1;
for k=1:size(uaa.T.PerimRegions,1)
%     disp(k);
    fprintf('Creating spine training data for frame %d\n',k);
    imageRegions = uaa.T.PerimRegions{k,1};
    boundingBoxes = uaa.T.PerimeterSpineBoundingBox{k,1};
    BWborder = uaa_findImageBorder(uaa_getCurrentImageFrame(k));

    ignoreSpinesHere = uaa.T.DetachedSpines{k,1} | BWborder;
    I = uaa.T.Image{k,1};
    BW = uaa.T.AttachedSpines{k,1};
    thin = uaa.T.thin{k,1};
    for i=1:length(imageRegions)
        siz = size(imageRegions(i).Image);
        allPerimSpineInd = false(size(imageRegions(i).ind));
        allPerimSpineTipInd = false(size(imageRegions(i).ind));
%         imageRegions(i).singlePerimSpineInd = false(size(imageRegions(i).ind,1),size(boundingBoxes,1));
        spineDistPix = cell(size(boundingBoxes,1),1);
%         imageRegions(i).spineTrainData = cell(size(boundingBoxes,1),1);
%         imageRegions(i).NoSpineTrainData = cell(size(boundingBoxes,1),1);
%         imageRegions(i).singleSpinePerimPixelPosition = cell(size(boundingBoxes,1),1);
%         imageRegions(i).ignoreSpine = false(size(boundingBoxes,1),1);
        for j=1:size(boundingBoxes,1)
            [singleSpinePerimDistPixels, pixelPosition, ind, ignore, spineTipInd, loc] = uaa_identifySpineInBox(size(imageRegions(i).x),boundingBoxes(j,:),imageRegions(i).y,imageRegions(i).ind,ignoreSpinesHere);
            if uaa.featureExtractors.pdfsb
                [perimDistFromSpineBackbone,~,~,thinPath] = uaa_calculatePerimDistFromSpineBackbone(pixelPosition, BW, thin, round(length(pixelPosition)/2));
            end
            if uaa.featureExtractors.sttdbil && ~isempty(thinPath)
                singleIntensityLine = uaa_calculateSpineIntensityLine(loc,thinPath,I,uaa.imageInfo.umPerPixel);
            end
%             imageRegions(i).perimDistFromSpineBackboneFromLabeledSpines = perimDistFromSpineBackbone;

            spineDistPix{j} = singleSpinePerimDistPixels;
%             imageRegions(i).singlePerimSpineInd(ind,j) = true;
            allPerimSpineInd(ind) = true;
            allPerimSpineTipInd(spineTipInd) = true;
%             imageRegions(i).singleSpinePerimPixelPosition{j} = pixelPosition;
%             imageRegions(i).ignoreSpine(j) = ignore;

            if ~isempty(singleSpinePerimDistPixels) && ~ignore
                [~, yi] = uaa_interpSpinePerim(singleSpinePerimDistPixels);
                [~, yyi] = uaa_interpSpinePerim(perimDistFromSpineBackbone);
                if saveImages
                    I_sbd = zeros(siz);
                    I_dbd = zeros(siz);
                    I_sbd(pixelPosition) = singleSpinePerimDistPixels;
                    I_dbd(pixelPosition) = perimDistFromSpineBackbone;
                    file_name_sbd = fullfile(folder_name_pos,sprintf('%sF%dR%dS%d%s','sbd',k,i,j,'.tif'));
                    file_name_dbd = fullfile(folder_name_pos,sprintf('%sF%dR%dS%d%s','dbd',k,i,j,'.tif'));
                    imwrite(I_sbd,file_name_sbd);
                    imwrite(I_dbd,file_name_dbd);
                end
%                 imageRegions(i).spineTrainData{j} = {[yi ; yyi]};
%                 allSpinePerims = [allSpinePerims; {[yi ; yyi]}];
                isSpine(structInd,1) = true;
                Frame(structInd,1) = k;
                Region(structInd,1) = i;
                Section(structInd,1) = j;
                PerimFromDendriteDist(structInd,:) = yi';
                PerimFromSpineBackboneDist(structInd,:) = yyi';
                IntensityLine(structInd,:) = singleIntensityLine;
%                 trainingStruct(structInd,1).IsSpine = true;
%                 trainingStruct(structInd,1).Frame = k;
%                 trainingStruct(structInd,1).Region = i;
%                 trainingStruct(structInd,1).Section = j;
%                 trainingStruct(structInd,1).PerimFromDendriteDist = yi;
%                 trainingStruct(structInd,1).PerimFromSpineBackboneDist = yyi;
                structInd = structInd + 1;
            end
        end

        [singleNonSpinePerimDistPixels, nonSpinePixelPos, ~, locs] = uaa_identifyNonSpinesInData(allPerimSpineInd, imageRegions(i).y, imageRegions(i).ind, ignoreSpinesHere);
        nonSpinePerimDistFromSpineBackbone = cell(size(nonSpinePixelPos));
        nonSpineIntensityLines = nonSpinePerimDistFromSpineBackbone;
        if uaa.featureExtractors.pdfsb
            for q=1:length(nonSpinePixelPos)
                nspPos = nonSpinePixelPos{q};
                [nonSpinePerimDistFromSpineBackbone{q},~,~,thinPath] = uaa_calculatePerimDistFromSpineBackbone(nspPos, BW, thin, round(length(nspPos)/2));
                if uaa.featureExtractors.sttdbil
                    nonSpineIntensityLines{q} = uaa_calculateSpineIntensityLine(locs(q),thinPath,I,uaa.imageInfo.umPerPixel);
                end
            end
        end

%         imageRegions(i).singleNonSpinePerimDistPixels = singleNonSpinePerimDistPixels;
%         imageRegions(i).nonSpinePixelPos = nonSpinePixelPos;
%         imageRegions(i).nonSpineInd = nonSpineInd;
        if ~isempty(singleNonSpinePerimDistPixels)
            [~, yi] = uaa_interpSpinePerim(singleNonSpinePerimDistPixels);
            [~, yyi] = uaa_interpSpinePerim(nonSpinePerimDistFromSpineBackbone);
            if saveImages
                for j = 1:length(singleNonSpinePerimDistPixels)
                    I_ndbd = zeros(siz);
                    I_nsbd = zeros(siz);
                    I_nsbd(nonSpinePixelPos{j}) = singleNonSpinePerimDistPixels{j};
                    I_ndbd(nonSpinePixelPos{j}) = nonSpinePerimDistFromSpineBackbone{j};
                    
                    file_name_nsbd = fullfile(folder_name_neg,sprintf('%sF%dR%dS%d%s','nsbd',k,i,j,'.tif'));
                    file_name_ndbd = fullfile(folder_name_neg,sprintf('%sF%dR%dS%d%s','ndbd',k,i,j,'.tif'));
                    imwrite(I_nsbd,file_name_nsbd);
                    imwrite(I_ndbd,file_name_ndbd);
                end
            end
%             if uaa.featureExtractors.sttdbil
%                 yii = cellfun(@(x,y,z) [x;y;z], yi,yyi,nonSpineIntensityLines,'UniformOutput',false);
%             else
%                 yii = cellfun(@(x,y) [x;y], yi,yyi,'UniformOutput',false);
%             end
%             imageRegions(i).nonSpineTrainData = yii;
%             allNonSpinePerims = [allNonSpinePerims; yii];
%             structInd = size(trainingStruct,1);
            for q = 1:length(yi)
                isSpine(structInd,1) = false;
                Frame(structInd,1) = k;
                Region(structInd,1) = i;
                Section(structInd,1) = q;
                PerimFromDendriteDist(structInd,:) = yi{q}';
                PerimFromSpineBackboneDist(structInd,:) = yyi{q}';
                IntensityLine(structInd,:) = nonSpineIntensityLines{q};
%               
%                 trainingStruct(structInd,1).IsSpine = false;
%                 trainingStruct(structInd,1).Frame = k;
%                 trainingStruct(structInd,1).Region = i;
%                 trainingStruct(structInd,1).Section = q;
%                 trainingStruct(structInd,1).PerimFromDendriteDist = yi{q};
%                 trainingStruct(structInd,1).PerimFromSpineBackboneDist = yyi{q};
                structInd = structInd + 1;
            end
        end

    end
%     uaa.T.PerimRegions{k,1} = imageRegions;
end
% trainingTable = struct2table(trainingStruct);
trainingTable = table(isSpine,Frame,Region,Section,PerimFromDendriteDist,PerimFromSpineBackboneDist,IntensityLine);

%bugfix?
trainingTable.IntensityLine(isnan(trainingTable.IntensityLine)) = 0;
% uaa.T.SpinePerimDist = spinePerimDist;
% uaa.T.NonSpinePerimDist = nonSpinePerimDist;
