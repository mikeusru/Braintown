function varargout = uaa_spineSelectionTool(varargin)
% UAA_SPINESELECTIONTOOL MATLAB code for uaa_spineSelectionTool.fig
%      UAA_SPINESELECTIONTOOL, by itself, creates a new UAA_SPINESELECTIONTOOL or raises the existing
%      singleton*.
%
%      H = UAA_SPINESELECTIONTOOL returns the handle to a new UAA_SPINESELECTIONTOOL or the handle to
%      the existing singleton*.
%
%      UAA_SPINESELECTIONTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UAA_SPINESELECTIONTOOL.M with the given input arguments.
%
%      UAA_SPINESELECTIONTOOL('Property','Value',...) creates a new UAA_SPINESELECTIONTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before uaa_spineSelectionTool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to uaa_spineSelectionTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help uaa_spineSelectionTool

% Last Modified by GUIDE v2.5 15-Nov-2018 11:06:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @uaa_spineSelectionTool_OpeningFcn, ...
    'gui_OutputFcn',  @uaa_spineSelectionTool_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before uaa_spineSelectionTool is made visible.
function uaa_spineSelectionTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to uaa_spineSelectionTool (see VARARGIN)

% Choose default command line output for uaa_spineSelectionTool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global uaa
uaa.handles.uaa_spineSelectionTool=handles;
% Update dataset to include coordinates
uaa_initializeSpineCoordinates;

% UIWAIT makes uaa_spineSelectionTool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = uaa_spineSelectionTool_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in selectSpinesTB.
function selectSpinesTB_Callback(hObject, eventdata, handles)
% hObject    handle to selectSpinesTB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global uaa
% if get(hObject,'Value')
%     set(uaa.handles.ax.Children, 'ButtonDownFcn', @uaa_selectSpines);
% else
%     set(uaa.handles.ax.Children, 'ButtonDownFcn', '');
% end
if get(hObject,'Value')
    set(handles.trackSpinesTB,'Value',0);
end
uaa_initializeSpineCoordinates;
uaa_updateImage;
% Hint: get(hObject,'Value') returns toggle state of selectSpinesTB


% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in keepSpinesCB.
function keepSpinesCB_Callback(hObject, eventdata, handles)
% hObject    handle to keepSpinesCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of keepSpinesCB


% --- Executes on button press in createTrainingExamplesPB.
function createTrainingExamplesPB_Callback(hObject, eventdata, handles)
% hObject    handle to createTrainingExamplesPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
posBox = str2double(get(handles.posTrainED,'String'));
negBox = str2double(get(handles.negTrainED,'String'));

uaa_cropSpinesForTrain(posBox,negBox);


% --- Executes on button press in previewTrainingExamplesPB.
function previewTrainingExamplesPB_Callback(hObject, eventdata, handles)
% hObject    handle to previewTrainingExamplesPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_previewTrainingExamples;



function posTrainED_Callback(hObject, eventdata, handles)
% hObject    handle to posTrainED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.negTrainED,'String',get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of posTrainED as text
%        str2double(get(hObject,'String')) returns contents of posTrainED as a double


% --- Executes during object creation, after setting all properties.
function posTrainED_CreateFcn(hObject, eventdata, handles)
% hObject    handle to posTrainED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function negTrainED_Callback(hObject, eventdata, handles)
% hObject    handle to negTrainED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of negTrainED as text
%        str2double(get(hObject,'String')) returns contents of negTrainED as a double


% --- Executes during object creation, after setting all properties.
function negTrainED_CreateFcn(hObject, eventdata, handles)
% hObject    handle to negTrainED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function exportTrainingImagesMenu_Callback(hObject, eventdata, handles)
% hObject    handle to exportTrainingImagesMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_exportTrainingImages;


% --------------------------------------------------------------------
function trainClassifierMenu_Callback(hObject, eventdata, handles)
% hObject    handle to trainClassifierMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
uaa.categoryClassifier = uaa_loadTrainingData;


% --- Executes on button press in previewClassifierTB.
function previewClassifierTB_Callback(hObject, eventdata, handles)
% hObject    handle to previewClassifierTB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of previewClassifierTB


% --------------------------------------------------------------------
function findTrainingDataMenu_Callback(hObject, eventdata, handles)
% hObject    handle to findTrainingDataMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_findTrainingData;


% --------------------------------------------------------------------
function datasetMenu_Callback(hObject, eventdata, handles)
% hObject    handle to datasetMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function fillInMissingTrainingExamplesMenu_Callback(hObject, eventdata, handles)
% hObject    handle to fillInMissingTrainingExamplesMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
ind = find(cellfun(@isempty,uaa.T.SpineImages));
posBox = str2double(get(handles.posTrainED,'String'));
negBox = str2double(get(handles.negTrainED,'String'));

uaa_cropSpinesForTrain(posBox,negBox,ind);

% --------------------------------------------------------------------
function findMissingSpineCoordinatesMenu_Callback(hObject, eventdata, handles)
% hObject    handle to findMissingSpineCoordinatesMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
ind = find(cellfun(@isempty,uaa.T.SpineCoordinates));
if isempty(ind)
    strFormat = ['Spine Coordinates Empty at dataset index \n', repmat('%d, ',1,length(ind)),'.\n'];
    fprintf(strFormat,ind);
end


% --- Executes on button press in createPerimDistTrainingExamplesPB.
function createPerimDistTrainingExamplesPB_Callback(hObject, eventdata, handles)
% hObject    handle to createPerimDistTrainingExamplesPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa

[FileName,PathName] = uiputfile('*.mat');

for k = 1:size(uaa.T,1)
    if uaa.currentFrame == size(uaa.T,1)
        functionsGui('runFcnsPB_Callback');
        break
    end
    functionsGui('runFcnsPB_Callback');
    uaa_main('nextFramePushbutton_Callback');
end
disp('Done Running Analysis');

T = uaa_createSpinePerimTrainingData;
save(fullfile(PathName,FileName),'T');
uaa.imageAnalysis.T = T;
previewTrainingData();



function previewTrainingData
global uaa
T = uaa.imageAnalysis.T;
f = figure('Color','w','outerposition',[497 77 1034 1004]);
T.IntensityLine(isnan(T.IntensityLine)) = 0;

for j=1:4
    subplot(2,2,j,'xcolor','w','ycolor','w','fontsize',12,'box','off');
    switch j
        case 1
            data = T.PerimFromDendriteDist(T.isSpine,:);
            yLabelText = 'Perimeter Distance From Dendrite Backbone (µm)';
            ylimtop = 50;
        case 2
            data = T.PerimFromDendriteDist(~T.isSpine,:);
            yLabelText = 'Perimeter Distance From Dendrite Backbone (µm)';
            ylimtop = 50;
        case 3
            data = T.PerimFromSpineBackboneDist(T.isSpine,:);
            yLabelText = 'Perimeter Distance From Spine Backbone (µm)';
            ylimtop = 50;
            
        case 4
            data = T.PerimFromSpineBackboneDist(~T.isSpine,:);
            yLabelText = 'Perimeter Distance From Spine Backbone (µm)';
            ylimtop = 50;
            %         case 5
            %             data = T.IntensityLine(T.isSpine,:);
            %             yLabelText = 'Relative Spine Backbone Intensity (au)';
            %             ylimtop = 1;
            %
            %         case 6
            %             data = T.IntensityLine(~T.isSpine,:);
            %             yLabelText = 'Relative Spine Backbone Intensity (au)';
            %             ylimtop = 1;
    end
    totalGroups = 100;
    edges = linspace(0,ylimtop,totalGroups+1);
    
    dataLen = size(data,2);
    N = zeros(length(edges)-1,dataLen);
    for i=1:dataLen
        [N(:,i), ~] = histcounts(data(:,i),edges);
    end
    meanLine = mean(data,1)/10;
    xBase = linspace(0,5,dataLen) -2.5;
    yBase = linspace(0,ylimtop/10,dataLen);
    %     x = repmat(xBase,length(edges)-1,1);
    %     x = x(:)';
    %     y = repmat(edges(2:end),1,dataLen);
    z = N(:)';
    %     z(z>max(z)*.5) = max(z)*.5; %this can be done to avoid overwhelming
    %     peaks but data needs to be explained accurately otherwise it's
    %     falsifying data and we don't do that because we're good scientists
    %sort so highest values are plotted over lowest ones
    [z,ind] = sort(z);
    %     x = x(ind);
    %     y = y(ind);
    zeroIndex = find(z);
    c = z(zeroIndex);
    [X,Y] = meshgrid(xBase,yBase);
    pc = pcolor(X,Y,log(N));
    axis manual equal tight
    ylim([0 3]);
    pc.LineStyle = 'none';
    %     scatter(x(zeroIndex),y(zeroIndex),50,log(c),'o','filled');
    colormap(flipud(hot));
    caxis(log([c(1), c(end)]));
    cb = colorbar('Fontsize', 11);
    cb.Label.String = 'Total Training Values';
    cTickLabel = get(cb,'yticklabel');
    for i = 1:length(cTickLabel)
        cTickLabel{i} = sprintf('%d^%d',10,str2double(cTickLabel{i}));
    end
    set(cb,'yticklabel',cTickLabel)
    hold on;
    plot(xBase,meanLine,'LineWidth',3);
    %     title(figNames{j});
    %     ylim([0,ylimtop/10]);
    xlim([min(xBase),max(xBase)]);
    xlabel('Relative Perimeter Position (µm)');
    ylabel(yLabelText);
    %change units from 0.1 to 1 µm
    %     ytl = get(gca,'yticklabel');
    %     ytl = cellfun(@(x) num2str(str2double(x)/10),ytl,'uniformoutput',false);
    %     set(gca,'yticklabel',ytl);
end
alterFigureForPaper(f);
figure;
spineMeans = mean(T.IntensityLine(T.isSpine,2:end),1);
spineErr = std(T.IntensityLine(T.isSpine,2:end),1) / sqrt(length(find(T.isSpine)));

NonSpineMeans = mean(T.IntensityLine(~T.isSpine,2:end),1);
NonSpineErr = std(T.IntensityLine(~T.isSpine,2:end),1) / sqrt(length(find(~T.isSpine)));
subplot(1,2,1,'xcolor','w','ycolor','w','fontsize',12);
boxplot(T.IntensityLine(:,1),T.isSpine);
xticklabels({'Non-Spine','Spine'});
ylabel('Spine Length (µm)');
axis square
subplot(1,2,2,'xcolor','w','ycolor','w','fontsize',12);
errorbar(spineMeans,spineErr,'linewidth',2); hold on
errorbar(NonSpineMeans,NonSpineErr,'linewidth',2);
ylabel('Pixel Intensity (au)');
xlabel('Relative Pixel');
legend({'Spine','Non-Spine'})
axis square

function alterFigureForPaper(f) %this is just lazy because i don't feel like changing original function
% f = gcf;
ax = findobj(f,'type','axes');
cb = findobj(f,'type','colorbar');
for i = 1:length(ax)
    ax(i).YLim = [0 3];
    ax(i).YTick = [0 1 2 3];
    ax(i).YTickLabel = [0 1 2 3];    ax(i).FontSize = 12;
    ax(i).TickLength = [0,0];
    ax(i).Layer = 'top';
    ax(i).XTick = [-2,0,2];
    if i == 2 || i == 4
        cb(i).Label.Visible = 'off';
    end
    ax(i).Box = 'off';
    cb(i).FontSize = 12;
    cb(i).Ticks = [0 2 4 6 8];
    cb(i).TickLabels = {'1','10^2','10^4','10^6','10^8'};
end

function trainNeuralNetwork(T)
global uaa
allSpineFeatures = [T.PerimFromDendriteDist(T.isSpine,:),T.PerimFromSpineBackboneDist(T.isSpine,:)];
allNonSpineFeatures = [T.PerimFromDendriteDist(~T.isSpine,:),T.PerimFromSpineBackboneDist(~T.isSpine,:)];
if uaa.featureExtractors.sttdbil
    allSpineFeatures = [allSpineFeatures, T.IntensityLine(T.isSpine,:)];
    allNonSpineFeatures = [allNonSpineFeatures, T.IntensityLine(~T.isSpine,:)];
end
% train neural network
uaa_trainSpinePerimDistNeuralNetwork(allSpineFeatures, allNonSpineFeatures);


% --------------------------------------------------------------------
function loadTrainedNetworkMenu_Callback(hObject, eventdata, handles)
% hObject    handle to loadTrainedNetworkMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa

[f,p] = uigetfile('*.mat');
fname = fullfile(p,f);
S = load(fname);
uaa.ml.net = S.net;


% --------------------------------------------------------------------
function selectFeaturesMenu_Callback(hObject, eventdata, handles)
% hObject    handle to selectFeaturesMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_featureExtractorsGUI


% --------------------------------------------------------------------
function loadTrainingTable_Callback(hObject, eventdata, handles)
% hObject    handle to loadTrainingTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
[FileName,PathName] = uigetfile('*.mat');
T = load(fullfile(PathName,FileName));
T = T.T;
uaa.imageAnalysis.T = T;
previewTrainingData();


% --------------------------------------------------------------------
function previewTrainingDataMenu_Callback(hObject, eventdata, handles)
% hObject    handle to previewTrainingDataMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
previewTrainingData();


% --------------------------------------------------------------------
function trainNeuralNetworkMenu_Callback(hObject, eventdata, handles)
% hObject    handle to trainNeuralNetworkMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
T = uaa.imageAnalysis.T;
T.IntensityLine(isnan(T.IntensityLine)) = 0;
trainNeuralNetwork(T);


% --- Executes on button press in trackBrightCB.
function trackBrightCB_Callback(hObject, eventdata, handles)
% hObject    handle to trackBrightCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
uaa.roiTracking.trackBright = get(hObject,'value');
% Hint: get(hObject,'Value') returns toggle state of trackBrightCB


% --- Executes during object creation, after setting all properties.
function trackBrightCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trackBrightCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global uaa
set(hObject,'value',1);
uaa.roiTracking.trackBright = true;


% --- Executes on button press in findAndLabelSpinesPB.
function findAndLabelSpinesPB_Callback(hObject, eventdata, handles)
% hObject    handle to findAndLabelSpinesPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global uaa
%% Find and label spines with neural network
[labeledSpineEdgesThick, pos] = uaa_locateSpinesUsingSpinePerimDistNeuralNetwork;
I = uaa.fxnChoosing.tbl.OutputData{1};
% figure; imagesc(imoverlay(I,labeledSpineEdgesThick)); axis equal
i = 1;

%remove values too close to each other
if ~isempty(pos)
    while true
        D = pdist2(pos(:,1:2),pos(:,1:2));
        ind = D(:,i)>0 & D(:,i)<10;
        pos = pos(~ind,:);
        i = i + 1;
        if i >= size(pos,1)
            break
        end
    end
end

spines_removed = bwperim(uaa.fxnChoosing.tbl{'BWBlobs (4)',1}{1});
Io = imoverlay(I,spines_removed,'r');
figure; imshow(Io); axis image off
colormap gray
hold on
sc = scatter(pos(:,1),pos(:,2),100,'y','filled','MarkerFaceAlpha',.3,'MarkerEdgeColor','g');


% --- Executes on button press in trackSpinesTB.
function trackSpinesTB_Callback(hObject, eventdata, handles)
% hObject    handle to trackSpinesTB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
if get(hObject,'Value')
    set(handles.selectSpinesTB,'Value',0);
end
if ~isfield(uaa,'spineTracking')
    sf = struct('Coordinate',{},'Status',{});
    s = struct('Tag',{},'Frames',sf);
    uaa.spineTracking = struct('TrackedSpineTag',[],'Spines',s);
end
uaa_initializeSpineCoordinates;
uaa_updateImage;
uaa_updateSpineTree;

% Hint: get(hObject,'Value') returns toggle state of trackSpinesTB


% --------------------------------------------------------------------
function exportLabeledData_Callback(hObject, eventdata, handles)
% hObject    handle to exportLabeledData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
%get parent folder
parent_folder = uigetdir();
for i = 1: height(uaa.T)
    %get info for text file
    original_filepath = fullfile(uaa.T.Foldername{i}, uaa.T.Filename{i});
    coordinates = uaa.T.SpineCoordinates{i}';
    bounding_boxes = uaa.T.BoundingBoxes{i};
    scale_text = sprintf('%.2f px per um',uaa.T.Scale{i});
    coordinates_text = sprintf('x = %.0f, y = %.0f\n',coordinates(:));
%     bounding_box_text = sprintf('x = %.0f, y = %.0f, w = %.0f, h = %.0f\n',bounding_boxes(:));
    %get new folder and file names
    folder_name = sprintf('spine%06d',i);
    image_file_name = sprintf('spine_image%06d.tif',i);
    text_file_name = sprintf('spine_info%06d.txt',i);
    bounding_box_file_name = sprintf('spine_bounding_boxes%06d.csv',i);
    %make directory
    mkdir(fullfile(parent_folder,folder_name));
    %write text file
    fileID = fopen(fullfile(parent_folder,folder_name,text_file_name),'w');
    fprintf(fileID,'Original Filepath: \n%s\n\n',original_filepath);
    fprintf(fileID,'%s\n','Spine Coordinates: ');
    fprintf(fileID,coordinates_text);
    fprintf(fileID,'%s\n','Scale: ');
    fprintf(fileID,scale_text);
    fclose(fileID);
    %write bounding boxes to separate csv file
    csvwrite(fullfile(parent_folder,folder_name,bounding_box_file_name),bounding_boxes)
    %write image
    imwrite(mat2gray(uaa.T.Image{i}),fullfile(parent_folder,folder_name,image_file_name));
    fprintf('Image #%d of %d Written...\n', i, height(uaa.T));
end
fprintf('Donez0rz');


% --------------------------------------------------------------------
function remove_frame_Callback(hObject, eventdata, handles)
% hObject    handle to remove_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
uaa.T([uaa.currentFrame],:) = [];
uaa_updateImage;
uaa_updateGUI;


% --- Executes on button press in calculate_bounding_boxes_PB.
function calculate_bounding_boxes_PB_Callback(hObject, eventdata, handles)
% hObject    handle to calculate_bounding_boxes_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_calculate_spine_bounding_boxes;


% --- Executes on button press in show_bounding_boxes_CB.
function show_bounding_boxes_CB_Callback(hObject, eventdata, handles)
% hObject    handle to show_bounding_boxes_CB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of show_bounding_boxes_CB


% --------------------------------------------------------------------
function exportForYolov3_Callback(hObject, eventdata, handles)
% hObject    handle to exportForYolov3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
parent_folder = uigetdir();
relative_image_dir = 'images';
image_dir = fullfile(parent_folder,relative_image_dir);
% labels_dir = fullfile(parent_folder,'labels');
mkdir(image_dir);
% mkdir(labels_dir);
all_file_lines = cell(height(uaa.T),1);
other_image_info_lines = all_file_lines;
for i = 1: height(uaa.T)
    yolo_boxes = get_yolo_boxes_xmin_ymin_xmax_ymax_c(i);
    image_file_name = sprintf('%06d.tif',i);
    image_path = fullfile(image_dir,image_file_name);
    relative_image_path = fullfile(relative_image_dir, image_file_name);
    imwrite(mat2gray(repmat(uaa.T.Image{i},1,1,3)),image_path);
    fprintf('Image #%d of %d Written...\n', i, height(uaa.T));
    yolo_boxes = yolo_boxes';
    yolo_boxes_string = sprintf('%.0f,%.0f,%.0f,%.0f,%.0f ', yolo_boxes(:));
    all_file_lines{i} = sprintf('%s %s', relative_image_path, yolo_boxes_string);
    other_image_info_lines{i} = sprintf('%s Scale %.2f', relative_image_path, uaa.T.Scale{i});
end
[trainInd, valInd, ~] = dividerand(height(uaa.T), 0.7, 0.3, 0);
writeCellsToText(all_file_lines(trainInd), fullfile(parent_folder, 'train.txt'));
writeCellsToText(all_file_lines(valInd), fullfile(parent_folder, 'validation.txt'));
writeCellsToText(other_image_info_lines, fullfile(parent_folder, 'image_info.txt'));
fprintf('Donez0rz\n');

function yolo_boxes_cxywh = getCXYWH(i)
global uaa
[imageHeight, imageWidth] = size(uaa.T.Image{i});
coordinates = uaa.T.SpineCoordinates{i}';
coordinates = coordinates'./[imageWidth,imageHeight];
bounding_boxes = uaa.T.BoundingBoxes{i};
w_h=bounding_boxes(:,3:end)./[imageWidth,imageHeight];
classes = ones(size(bounding_boxes(:,1)));
yolo_boxes_cxywh = [classes, coordinates, w_h];

function yolo_boxes = get_yolo_boxes_xmin_ymin_xmax_ymax_c(i)
global uaa  
if max(contains(uaa.T.Properties.VariableNames, 'BoundingBoxes'))
    bounding_boxes = uaa.T.BoundingBoxes{i};
    classes = zeros(size(bounding_boxes(:,1)));
    yolo_boxes = [bounding_boxes(:,1:2), bounding_boxes(:,1:2) + bounding_boxes(:,3:4), classes];
else
    yolo_boxes = [];
end

function writeCellsToText(cellArray, filePath)
fid = fopen(filePath, 'at');
for i = 1:length(cellArray)
    fprintf(fid, '%s\n\r', cellArray{i});
end
fclose(fid);
