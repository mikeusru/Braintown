function uaa_previewTrainingExamples

global uaa

% maximum number of images
maxNumImages = 50;

%eventually, random number search should only target available images

%% Positive Examples
cellInd2 = cellfun(@length,uaa.T.SpineImages,'UniformOutput',false);
cellInd1 = find(~cellfun(@isempty,cellInd2));
cellInd1([cellInd2{:}]'==0)=[];
cellInd2 = cellInd2(cellInd1);
totalPositiveN = sum([cellInd2{:}]);
if totalPositiveN==0
    disp('No Positive Training Examples');
else
    MNI = min(maxNumImages,totalPositiveN);
    r1 = randi(length(cellInd1),MNI,1);
    r2 = cellfun(@randi,cellInd2,'UniformOutput',false);
    r2 = [r2{:}]';
    
    I=cell(1,MNI);
    for i=1:MNI
        I{i} =  uaa.T.SpineImages{r1(i)}{r2(r1(i))};
    end
    f1=figure; imdisp(I);
    set(f1,'Name',['Showing ', num2str(MNI), ' out of ', num2str(totalPositiveN), ' Positive Training Examples'], 'NumberTitle', 'off');
end

%% Negative Examples
cellInd2 = cellfun(@length,uaa.T.NoSpineImages,'UniformOutput',false);
cellInd1 = find(~cellfun(@isempty,cellInd2));
cellInd1([cellInd2{:}]'==0)=[];
cellInd2 = cellInd2(cellInd1);
totalNegativeN = sum([cellInd2{:}]);
if totalNegativeN==0
    disp('No Negative Training Examples');
else
    MNI = min(maxNumImages,totalNegativeN);
    r1 = randi(length(cellInd1),MNI,1);
    cellInd2 = repmat(cellInd2,ceil(MNI/length(cellInd2)),1);
%     cellInd2 = cellInd2(1:MNI);
    r2 = cellfun(@randi,cellInd2,'UniformOutput',false);
    r2 = [r2{:}]';
%     cellInd2 = [cellInd2{:}]';
    Inot=cell(1,MNI);
    for i=1:MNI
        Inot{i} =  uaa.T.NoSpineImages{cellInd1(r1(i))}{r2(r1(i))};
    end
    f2=figure; imdisp(Inot);
    set(f2,'Name',['Showing ', num2str(MNI), ' out of ', num2str(totalNegativeN), ' Negative Training Examples'], 'NumberTitle', 'off');
end