function varargout = uaa_main(varargin)
% UAA_MAIN MATLAB code for uaa_main.fig
%      UAA_MAIN, by itself, creates a new UAA_MAIN or raises the existing
%      singleton*.
%
%      H = UAA_MAIN returns the handle to a new UAA_MAIN or the handle to
%      the existing singleton*.
%
%      UAA_MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UAA_MAIN.M with the given input arguments.
%
%      UAA_MAIN('Property','Value',...) creates a new UAA_MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before uaa_main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to uaa_main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help uaa_main

% Last Modified by GUIDE v2.5 29-Jan-2018 14:52:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @uaa_main_OpeningFcn, ...
    'gui_OutputFcn',  @uaa_main_OutputFcn, ...
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


% --- Executes just before uaa_main is made visible.
function uaa_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to uaa_main (see VARARGIN)

% Choose default command line output for uaa_main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global uaa
uaa.handles.uaa_main=handles;

% UIWAIT makes uaa_main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = uaa_main_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function fileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to fileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function openFileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to openFileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% uaa_openFolder(1);
uaa_open('images');


% --------------------------------------------------------------------
function openFolderMenu_Callback(hObject, eventdata, handles)
% hObject    handle to openFolderMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% uaa_openFolder;
uaa_open('folder');

% --- Executes on button press in previousFramePushbutton.
function previousFramePushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to previousFramePushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uaa_changeFrame(0);



% --- Executes on button press in nextFramePushbutton.
function nextFramePushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to nextFramePushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
uaa_changeFrame(1);



% --------------------------------------------------------------------
function roisMenu_Callback(hObject, eventdata, handles)
% hObject    handle to roisMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function circleRoiMenu_Callback(hObject, eventdata, handles)
% hObject    handle to circleRoiMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa

prompt = 'Roi Number:';
dlg_title = 'Roi';
num_lines= 1;
def     = {'1'};
answer  = inputdlg(prompt,dlg_title,num_lines,def);

uaa_addRoi(str2double(answer));


% --------------------------------------------------------------------
function polygonRoiMenu_Callback(hObject, eventdata, handles)
% hObject    handle to polygonRoiMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
prompt = 'Roi Number:';
dlg_title = 'Roi';
num_lines= 1;
def     = {'1'};
answer  = inputdlg(prompt,dlg_title,num_lines,def);

uaa_addPolyRoi(str2num(answer{1}));

% --------------------------------------------------------------------
function backgroundRoiMenu_Callback(hObject, eventdata, handles)
% hObject    handle to backgroundRoiMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
uaa_addRoi(0);
% h=imellipse(uaa.handles.ax1);
% xy=wait(h);
% BW=poly2mask(xy(:,1),xy(:,2),uaa.imSize(1),uaa.imSize(2));
% uaa.backgroundRoi(:,:,uaa.currentFrame)=BW;
% uaa_calcRoiInfo(0);



function uncageFrameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to uncageFrameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
uaa.uncageFrame=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of uncageFrameEdit as text
%        str2double(get(hObject,'String')) returns contents of uncageFrameEdit as a double


% --- Executes during object creation, after setting all properties.
function uncageFrameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uncageFrameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calcRoisPushbutton.
function calcRoisPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to calcRoisPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_calcRoiInfo;


% --- Executes on button press in calcAllPushbutton.
function calcAllPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to calcAllPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
if isempty(findobj('Tag', 'RoiA0'))
    beep;
    errordlg('Set the background ROI (roi 0)!');
    set(hObject,'String','Calculate All','ForegroundColor','k');
    return;
end
buttonStr=get(hObject,'String');
disp(buttonStr);
switch buttonStr
    case 'Calculate All'
        set(hObject,'String','Abort','ForegroundColor','r');
        uaa_calcAll;
    case 'Abort'
        set(hObject,'String','Calculate All','ForegroundColor','k');
end


function mainSpineRoiEdit_Callback(hObject, eventdata, handles)
% hObject    handle to mainSpineRoiEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mainSpineRoiEdit as text
%        str2double(get(hObject,'String')) returns contents of mainSpineRoiEdit as a double

% --- Executes during object creation, after setting all properties.
function mainSpineRoiEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mainSpineRoiEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in makePlotsPushbutton.
function makePlotsPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to makePlotsPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_makeCharts;


% --------------------------------------------------------------------
function imgMenu_Callback(hObject, eventdata, handles)
% hObject    handle to imgMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function driftCorrectMenu_Callback(hObject, eventdata, handles)
% hObject    handle to driftCorrectMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_driftCorrect;


% --------------------------------------------------------------------
function saveDataMenu_Callback(hObject, eventdata, handles)
% hObject    handle to saveDataMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa

pathName = uaa.pathName;

names=fieldnames(uaa);
names=names(~strcmp(names,'handles')); %remove 'uaa_main' fieldname
for i=1:size(names,1)
    uaaCopy.(names{i,1})=uaa.(names{i,1});
end

[~,fName,~]=fileparts(uaa.T.Filename{1,1});
[FileName,pathName]= uiputfile([pathName,'\',fName(1:end-3),'_Analyzed.mat']);
uaa.pathName = pathName;

save(fullfile(pathName,FileName),'uaaCopy', '-v7.3');
disp(['Data saved to ',fullfile(pathName,FileName)]);



% --------------------------------------------------------------------
function loadDataMenu_Callback(hObject, eventdata, handles)
% hObject    handle to loadDataMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
%backup main handles

filePath = '*.mat';
if isfield(uaa.settings,'start_path_data')
    filePath = uaa.settings.start_path_data;
end

[fileName,pathName,~]=uigetfile(filePath);
filePath = fullfile(pathName,fileName);

try
    %First, load non-handle objects
    S=load(filePath);
    if ~isempty(find(~cellfun(@isempty,strfind(fieldnames(S),'branchStruct')),1))
        uaa.T=dataset2table(S.ds);
    else
        names=fieldnames(S.uaaCopy);
        %     names=names(~strcmp(names,'handles')); %remove 'handles' fieldname
        for i=1:size(names,1)
            if strcmp(names{i,1},'ds')
                uaa.T = dataset2table(S.uaaCopy.(names{i,1}));
            else
                uaa.(names{i,1})=S.uaaCopy.(names{i,1});
            end
        end
        
        %Load empty ROI handles. This fixes a bug often caused by
        %creating imrois without predefined handles.
        %     names=fieldnames(S.uaaCopy.handles);
        %     names=names(~strcmp(names,'handles')); %remove 'handles' fieldname
        %     for i=1:size(names,1)
        %        uaa.(names{i,1})=S.uaaCopy.(names{i,1});
        %     end
    end
    uaa.settings.start_path_data = filePath;
    disp([fileName, ' loaded successfully']);
catch err
    disp(err);
end
%keep original handles
uaa.currentFrame=1;
uaa_makeFig;
uaa_updateImage;
% figure(uaa.handles.Fig1);
% imagesc(uaa.T.Image{1,1});
uaa_showRois;
uaa_updateGUI;
uaa_saveSettings;


% --------------------------------------------------------------------
function motionCorrectRoisMenu_Callback(hObject, eventdata, handles)
% hObject    handle to motionCorrectRoisMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa

button=questdlg('Motion-Correct circular ROIs? Warning - positions will be reset','Continue?','OK','Cancel','Cancel');
if strcmp(button,'Cancel')
    return
end

for j=1:size(uaa.T,1)
    [centers,~,~]=uaa_autoMakeCircles(uaa_getCurrentImageFrame(j));
    for i=1:size(uaa.T.Roi,2)
        if i>1 && ~isempty(uaa.T.Roi{1,i}) %is ROI is not background and first cell isn't empty
            roiPos=uaa.T.Roi{j,i};
            roiCenter=[roiPos(1)+roiPos(3)/2, roiPos(2)+roiPos(4)/2];
            pointDist=pdist2(roiCenter,centers); %distance between roi center and all circle centers
            closestCenter=centers(pointDist==min(pointDist),:); %closest circle center to ROI
            uaa.T.Roi{j,i}(1,1)=closestCenter(1)-roiPos(3)/2;
            uaa.T.Roi{j,i}(1,2)=closestCenter(2)-roiPos(4)/2;
            uaa.T.Accessed(j,1)=1;
        end
    end
end
uaa_deleteRoiHandles;
uaa_showRois;


% --------------------------------------------------------------------
function exportResultsMenu_Callback(hObject, eventdata, handles)
% hObject    handle to exportResultsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa

ds=dataset;
ds.RoiSum=uaa.T.RoiSum;
ds.RoiAvg=uaa.T.RoiAvg;
ds.RoiMax=uaa.T.RoiMax;
ds.PolySum=uaa.T.PolySum;
ds.PolyAvg=uaa.T.PolyAvg;
ds.PolyMax=uaa.T.PolyMax;
ds.PlotTime=uaa.T.PlotTime;
try
    ds.StandardRoiMean=uaa.T.StandardRoiMean;
    ds.StandardPolyMean=uaa.T.StandardPolyMean;
end
[FileName,PathName,FilterIndex] = uiputfile('*.txt','Export Results');
export(ds,'file',[PathName,FileName]);



function currentFrameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to currentFrameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
newFrame=round(str2double(get(hObject,'String')));

if newFrame>0 && newFrame<=size(uaa.T,1)
    uaa.currentFrame=newFrame;
    uaa_changeFrame(2);
else
    disp('Frame out of bounds');
end
% Hints: get(hObject,'String') returns contents of currentFrameEdit as text
%        str2double(get(hObject,'String')) returns contents of currentFrameEdit as a double


% --- Executes during object creation, after setting all properties.
function currentFrameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentFrameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function currentFrameText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentFrameText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function totalFramesEdit_Callback(hObject, eventdata, handles)
% hObject    handle to totalFramesEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of totalFramesEdit as text
%        str2double(get(hObject,'String')) returns contents of totalFramesEdit as a double


% --- Executes during object creation, after setting all properties.
function totalFramesEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to totalFramesEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function calculationsMenu_Callback(hObject, eventdata, handles)
% hObject    handle to calculationsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function watershedMenu_Callback(hObject, eventdata, handles)
% hObject    handle to watershedMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
% profile -memory on

if size(uaa.T.Roi,2)<2 || ~uaa.settings.watershed.doWatershed
    beep;
    errordlg('Set At Least One Circle ROI and make sure Watershed is turned on');
    set(uaa.handles.uaa_main.calcAllPushbutton,'String','Calculate All','ForegroundColor','k');
    return;
end
buttonStr=get(uaa.handles.uaa_main.calcAllPushbutton,'String');
switch buttonStr
    case 'Calculate All'
        set(uaa.handles.uaa_main.calcAllPushbutton,'String','Abort','ForegroundColor','r');
        uaa_calcAll('watershed');
    case 'Abort'
        set(uaa.handles.uaa_main.calcAllPushbutton,'String','Calculate All','ForegroundColor','k');
end



function totalChanEdit_Callback(hObject, eventdata, handles)
% hObject    handle to totalChanEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
uaa.settings.totalChan=str2double(get(hObject,'String'));
uaa_saveSettings;
% Hints: get(hObject,'String') returns contents of totalChanEdit as text
%        str2double(get(hObject,'String')) returns contents of totalChanEdit as a double


% --- Executes during object creation, after setting all properties.
function totalChanEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to totalChanEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global uaa
set(hObject,'String',num2str(uaa.settings.totalChan));


% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ignoreEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ignoreEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
uaa.settings.ignoreFiles=get(hObject,'String');
uaa_saveSettings;
% Hints: get(hObject,'String') returns contents of ignoreEdit as text
%        str2double(get(hObject,'String')) returns contents of ignoreEdit as a double


% --- Executes during object creation, after setting all properties.
function ignoreEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ignoreEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global uaa
set(hObject,'String',uaa.settings.ignoreFiles);

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function optionsMenu_Callback(hObject, eventdata, handles)
% hObject    handle to optionsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_autoOptions;


% --------------------------------------------------------------------
function projectMenu_Callback(hObject, eventdata, handles)
% hObject    handle to projectMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function projectSumMenu_Callback(hObject, eventdata, handles)
% hObject    handle to projectSumMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_projectImage('sum');

% --------------------------------------------------------------------
function projectMaxMenu_Callback(hObject, eventdata, handles)
% hObject    handle to projectMaxMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_projectImage('max');


% --------------------------------------------------------------------
function branchImageMenu_Callback(hObject, eventdata, handles)
% hObject    handle to branchImageMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_makeAndSave3DBranchimages;


% --------------------------------------------------------------------
function autofocusAnalysisMenu_Callback(hObject, eventdata, handles)
% hObject    handle to autofocusAnalysisMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
AutofocusTest;


% --------------------------------------------------------------------
function customSegmentationMenu_Callback(hObject, eventdata, handles)
% hObject    handle to customSegmentationMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
functionsGui;


% --------------------------------------------------------------------
function depthIntensityCorrectionMenu_Callback(hObject, eventdata, handles)
% hObject    handle to depthIntensityCorrectionMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_depthIntensityCorrection;


% --------------------------------------------------------------------
function saveImageMenu_Callback(hObject, eventdata, handles)
% hObject    handle to saveImageMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
button = questdlg('Select How Images Will Be Saved',...
    'Image Export Options','Current Frame Only',...
    'All Frames in 1 TIFF', 'One Frame Per Tiff',...
    'All Frames in 1 TIFF');
switch button
    case 'Current Frame Only'
        [fname,pname] = uiputfile('*.tif');
        imwrite(uaa_getCurrentImageFrame,[pname,fname]);
    case 'All Frames in 1 TIFF'
        [fname,pname] = uiputfile('*.tif');
        imwrite(uaa_getCurrentImageFrame(1),[pname,fname]);
        for i=2:length(uaa.T.Image(:))
            imwrite(uaa_getCurrentImageFrame(i),[pname,fname],'WriteMode','append');
        end
    case 'One Frame Per Tiff'
        [fname,pname] = uiputfile('*.tif','Save Image Sequence As');
        numStrLength = length(num2str(length(uaa.T.Image(:))));
        for i=1:length(uaa.T.Image(:))
            numberField = sprintf(['%0',num2str(numStrLength),'.f'],(i));
            fNameNumbered = regexprep(fname,'.tif',[numberField,'.tif']);
            fileName = fullfile(pname,fNameNumbered);
            imwrite(uaa_getCurrentImageFrame(i),fileName);
            disp(fileName);
        end
end

% --------------------------------------------------------------------
function machineLearningMenu_Callback(hObject, eventdata, handles)
% hObject    handle to machineLearningMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SpineSelectionToolMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SpineSelectionToolMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_spineSelectionTool;


% --------------------------------------------------------------------
function addDataMenu_Callback(hObject, eventdata, handles)
% hObject    handle to addDataMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa

pathName = '';
if isfield(uaa,'pathName') && ~isempty(uaa.pathName) && ischar(uaa.pathName)
    pathName = uaa.pathName;
end
[fileName,pathName,~]=uigetfile('*.mat','Select Data File to Add',pathName);
uaa.pathName = pathName;

try
    S=load([pathName,'\',fileName]);
    fields = fieldnames(S.uaaCopy);
    if sum(contains(fields,'ds'))
        loadedDS = S.uaaCopy.ds;
        loaded_table = dataset2table(loadedDS);
    else
        loaded_table = S.uaaCopy.T;
    end
    uaa_addNewDataset(loaded_table);
    disp([fileName, ' loaded successfully']);
catch err
    disp(err);
end



% --------------------------------------------------------------------
function projectStdMenu_Callback(hObject, eventdata, handles)
% hObject    handle to projectStdMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_projectImage('std');



function eliminateChannelED_Callback(hObject, eventdata, handles)
% hObject    handle to eliminateChannelED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eliminateChannelED as text
%        str2double(get(hObject,'String')) returns contents of eliminateChannelED as a double


% --- Executes during object creation, after setting all properties.
function eliminateChannelED_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eliminateChannelED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in eliminateChannelPB.
function eliminateChannelPB_Callback(hObject, eventdata, handles)
% hObject    handle to eliminateChannelPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
channel = str2double(get(handles.eliminateChannelED,'String'));
channel = channel:channel:size(uaa.T,1);
uaa.T(channel,:) = [];
uaa.currentFrame = 1;
uaa_changeFrame(2);
uaa_updateImage;


% --- Executes on button press in showInvertedCB.
function showInvertedCB_Callback(hObject, eventdata, handles)
% hObject    handle to showInvertedCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_updateImage;
% Hint: get(hObject,'Value') returns toggle state of showInvertedCB


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function open_bens_fov_file_Callback(hObject, eventdata, handles)
% hObject    handle to open_bens_fov_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_open('bens_fov');


% --------------------------------------------------------------------
function ViewMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ViewMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function imadjustMenu_Callback(hObject, eventdata, handles)
% hObject    handle to imadjustMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
uaa.handles.CLim_slider_figure = figure('Name','Image Adjustment',...
    'Position',[100,100,340,200],'Menubar','none','numbertitle','off');
info_label = uicontrol(uaa.handles.CLim_slider_figure,'Style','text','Position',[20 160 280 20],...
    'String','Close this window to enable automatic color limits');
low_slider = uicontrol(uaa.handles.CLim_slider_figure,'Style','Slider', 'SliderStep',[1/255,1/255],'Min', 0, 'Max', 255, 'Value', 0,...
    'Position', [20,80,300,20],'Tag','low_slider','Callback',@uaa_updateImage);
high_slider = uicontrol(uaa.handles.CLim_slider_figure,'Style','Slider', 'SliderStep',[1/255,1/255], 'Min', 0, 'Max', 255, 'Value', 255,...
    'Position', [20,20,300,20],'Tag','high_slider','Callback',@uaa_updateImage);
