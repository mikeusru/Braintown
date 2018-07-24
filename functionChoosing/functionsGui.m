function varargout = functionsGui(varargin)
% FUNCTIONSGUI MATLAB code for functionsGui.fig
%      FUNCTIONSGUI, by itself, creates a new FUNCTIONSGUI or raises the existing
%      singleton*.
%
%      H = FUNCTIONSGUI returns the handle to a new FUNCTIONSGUI or the handle to
%      the existing singleton*.
%
%      FUNCTIONSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FUNCTIONSGUI.M with the given input arguments.
%
%      FUNCTIONSGUI('Property','Value',...) creates a new FUNCTIONSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before functionsGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to functionsGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help functionsGui

% Last Modified by GUIDE v2.5 03-Apr-2018 10:37:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @functionsGui_OpeningFcn, ...
                   'gui_OutputFcn',  @functionsGui_OutputFcn, ...
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


% --- Executes just before functionsGui is made visible.
function functionsGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to functionsGui (see VARARGIN)

% Choose default command line output for functionsGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global uaa
uaa.handles.functionsGui = handles;
uaa.fxnChoosing.optionalInputVars = {};


% UIWAIT makes functionsGui wait for user response (see UIRESUME)
% uiwait(handles.functionsGUI);


% --- Outputs from this function are returned to the command line.
function varargout = functionsGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in fxnsLibLB.
function fxnsLibLB_Callback(hObject, eventdata, handles)
% hObject    handle to fxnsLibLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
val = get(hObject,'value');
helpString = uaa.FLib{val,2};
showPluginInfo(handles,helpString);
% Hints: contents = cellstr(get(hObject,'String')) returns fxnsLibLB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fxnsLibLB


% --- Executes during object creation, after setting all properties.
function fxnsLibLB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fxnsLibLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

global uaa
fnList = uaa_loadPluginList;
uaa.FLib = fnList;

set(hObject,'String',fnList(:,1));


% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addFcnToListPb.
function addFcnToListPb_Callback(hObject, eventdata, handles)
% hObject    handle to addFcnToListPb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
val = get(handles.fxnsLibLB,'Value');
fxn = uaa.FLib{val,1};

% fxn = uaa.FLib{val,3};
% ind = length(uaa.FL) + 1;
ind = length(uaa.FL) + 1;

uaa.FL(ind).funName = fxn;

uaa.FL(ind).funIn = nargin(fxn); %amount of inputs
uaa.FL(ind).funOut = nargout(fxn); %amount of outputs
for i=1:uaa.FL(ind).funIn
    uaa.FL(ind).inputs(i).varLabel = 'Input Needed';
end
uaa.FL(ind).pluginInfo = uaa.FLib{val,2};
[inputVars, outputVars] = getFunctionInOuts(uaa.FL(ind).pluginInfo);
uaa.FL(ind).funInVars = inputVars;
uaa.FL(ind).funOutVars = outputVars;
uaa.FL(ind).funOutVarLabels = cellfun(@(x) [x, ' (', num2str(ind),')'], uaa.FL(ind).funOutVars, 'UniformOutput', false);

updateFunctionsList(handles.workingFunUIT);

% --- Executes on selection change in fxnsListLB.
function fxnsListLB_Callback(hObject, eventdata, handles)
% hObject    handle to fxnsListLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fxnsListLB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fxnsListLB


% --- Executes during object creation, after setting all properties.
function fxnsListLB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fxnsListLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in removeFunPB.
function removeFunPB_Callback(hObject, eventdata, handles)
% hObject    handle to removeFunPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
val = get(handles.workingFunUIT,'UserData');
uaa.FL(val(1)) = [];
updateFunctionsList(handles.workingFunUIT);

function updateFunctionsList(hObject)

global uaa
inputVars = {};
if uaa.fxnChoosing.inputCurrentFrame
    inputVars{1} = 'Current Frame';
end
if isfield(uaa.fxnChoosing,'optionalInputVars')
    inputVars = [inputVars, uaa.fxnChoosing.optionalInputVars];
end

funNameAll = {uaa.FL.funName}';
funOutVars = [uaa.FL.funOutVars];
funInInd = [uaa.FL.funIn];
totalVarList = funOutVars;
ii = 1;
SelectedVariable = cell(length(funNameAll),max(funInInd));
%create list of variables for selection
for i=1:length(funNameAll)
    % Selected Variables Matrix
    for j = 1:uaa.FL(i).funIn
        SelectedVariable{i,j} = uaa.FL(i).inputs(j).varLabel;
    end
    %total list of variables for selection
    for j = 1:uaa.FL(i).funOut
        totalVarList{ii} = uaa.FL(i).funOutVarLabels{j};
        ii = ii + 1;
    end
end
totalVarList = [inputVars,totalVarList];
uiData = [funNameAll,SelectedVariable];

set(hObject,'Data',uiData);
set(hObject,'ColumnName',['Fxn',repmat({'Input'},1,max(funInInd))]);
set(hObject, 'ColumnEditable', [false true(1,max(funInInd))]);
set(hObject, 'ColumnFormat', ['char', repmat({totalVarList},1,max(funInInd))]);

uaa.fxnChoosing.totalVarList = totalVarList;

FL = uaa.FL;
p = mfilename('fullpath');
[a,~,~] = fileparts(p);
fName = [a,'\functionsList.mat'];
save(fName,'FL');



% --- Executes during object creation, after setting all properties.
function functionsGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to functionsGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global uaa
p = mfilename('fullpath');
[a,~,~] = fileparts(p);
fName = [a,'\functionsList.mat'];
if exist(fName,'file')
    S = load(fName);
    uaa.FL = S.FL;
else
    uaa.FL = struct([]);
end


function umPerPixED_Callback(hObject, eventdata, handles)
% hObject    handle to umPerPixED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
uaa.imageInfo.umPerPixel = str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of umPerPixED as text
%        str2double(get(hObject,'String')) returns contents of umPerPixED as a double


% --- Executes during object creation, after setting all properties.
function umPerPixED_CreateFcn(hObject, eventdata, handles)
% hObject    handle to umPerPixED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function workingFunUIT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to workingFunUIT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global uaa

if ~isempty(uaa.FL)
    updateFunctionsList(hObject)
else
    set(hObject,'Data',{});
    set(hObject,'ColumnName',{});
end


% --- Executes when selected cell(s) is changed in workingFunUIT.
function workingFunUIT_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to workingFunUIT (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
global uaa
set(hObject,'UserData',eventdata.Indices);
if ~isempty(eventdata.Indices)
    helpString = uaa.FL(eventdata.Indices(1)).pluginInfo;
    showPluginInfo(handles,helpString);
end

function showPluginInfo(handles,helpString)
set(handles.pluginInfoTX,'String',helpString);


% --------------------------------------------------------------------
function saveUipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to saveUipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateFunctionsList(handles.workingFunUIT);


% --- Executes when functionsGUI is resized.
function functionsGUI_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to functionsGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in runFcnsPB.
function runFcnsPB_Callback(hObject, eventdata, handles)
% hObject    handle to runFcnsPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_runFunctionList;



function smallestFeatureED_Callback(hObject, eventdata, handles)
% hObject    handle to smallestFeatureED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
uaa.imageInfo.smallestFeature = str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of smallestFeatureED as text
%        str2double(get(hObject,'String')) returns contents of smallestFeatureED as a double


% --- Executes during object creation, after setting all properties.
function smallestFeatureED_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smallestFeatureED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over fxnsLibLB.
function fxnsLibLB_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to fxnsLibLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in workingFunUIT.
function workingFunUIT_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to workingFunUIT (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
global uaa
i = eventdata.Indices(1);
j = eventdata.Indices(2)-1;
varLabel = eventdata.NewData;
% uaa.test.i = i;
% uaa.test.j = j;
% uaa.test.varLabel = varLabel;
% if strcmp(varLabel,'Current Frame')
uaa.FL(i).inputs(j).varLabel = varLabel;

% for k=1:length(uaa.FL)
%     ind = find(~cellfun(@isempty,strfind(uaa.FL(k).funOutVarLabels,varLabel)),1);
%     if ~isempty(ind)
%         uaa.FL(i).inputs(j).varLabel = varLabel;
%         break
%     end
% end


updateFunctionsList(handles.workingFunUIT);

% 
% ind = cellfun(@(x) strfind(x,varLabel), {uaa.FL.funOutVarLabels}, 'UniformOutput',false);
% ind = cellfun(@find, ind)
% ind = strcmp(uaa.figNamesRC,eventdata.NewData);
% [r,c] = ind2sub(size(uaa.figNamesRC),find(ind));
% uaa.FL(i).indIn{j} = [c,r];


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function loadConfigMenu_Callback(hObject, eventdata, handles)
% hObject    handle to loadConfigMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
[fName,pName] = uigetfile('*.mat');
if ~fName
    return
end
S = load([pName,fName]);
uaa.FL = S.FL;
updateFunctionsList(handles.workingFunUIT);
    
% --------------------------------------------------------------------
function saveConfigMenu_Callback(hObject, eventdata, handles)
% hObject    handle to saveConfigMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
FL = uaa.FL;
[fName,pName] = uiputfile('*.mat');
if isempty(fName)
    return
end
save([pName,fName],'FL');


% --- Executes on button press in configDescPB.
function configDescPB_Callback(hObject, eventdata, handles)
% hObject    handle to configDescPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [configInfo,ind] = uaa_loadConfigInfo;
% dispCells = {};
% if ~isempty(find(ind,1))
%     r = configInfo(ind).review;
%     for i=1:length(r)
%         dispCells{i} = sprintf('%d%s\n\n%s\n\n',r(i).stars,' Stars',r(i).purpose);
%     end
% else
%     %if the config doesn't exist, make a blank description for it
% end
% h = configDescGUI;
% h = findobj(h,'Tag','configInfoED');
% set(h,'String',dispCells);
% % disp(configInfo(ind).review.purpose)
% disp([num2str(configInfo(ind).review.stars),' Stars']);
configDescGUI;

function [inputVars, outputVars] = getFunctionInOuts(fxn)
disp(fxn);
outputIndex = regexp(fxn,'=');
if ~isempty(outputIndex)
    outputIndex = 1:outputIndex(1);
else
    outputIndex = [];
end
[sInd,eInd] = regexp(fxn,'\(.*?\)');

outputVars = regexp(fxn(outputIndex),'\w*','match');
inputVars = regexp(fxn(sInd(1):eInd(1)),'\w*','match');


% --------------------------------------------------------------------
function OptionsMenu_Callback(hObject, eventdata, handles)
% hObject    handle to OptionsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_functionGuiOptions;


% --- Executes on button press in convertUmToPxPB.
function convertUmToPxPB_Callback(hObject, eventdata, handles)
% hObject    handle to convertUmToPxPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
target = str2double(get(handles.convertED,'String'));
rc = uaa.imageInfo.umPerPixel / target; %resize constant
for i=1:length(uaa.T.Image)
    uaa.T.Image{i} = imresize(uaa.T.Image{i},rc);
end
uaa.imageInfo.umPerPixel = target;
set(handles.umPerPixED,'String',num2str(uaa.imageInfo.umPerPixel));
uaa_updateImage;

function convertED_Callback(hObject, eventdata, handles)
% hObject    handle to convertED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of convertED as text
%        str2double(get(hObject,'String')) returns contents of convertED as a double


% --- Executes during object creation, after setting all properties.
function convertED_CreateFcn(hObject, eventdata, handles)
% hObject    handle to convertED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pixel_per_um_ED_Callback(hObject, eventdata, handles)
% hObject    handle to pixel_per_um_ED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
pixels_per_um = str2double(get(hObject,'String'));
uaa.T.Scale{uaa.currentFrame} = pixels_per_um;
% Hints: get(hObject,'String') returns contents of pixel_per_um_ED as text
%        str2double(get(hObject,'String')) returns contents of pixel_per_um_ED as a double


% --- Executes during object creation, after setting all properties.
function pixel_per_um_ED_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixel_per_um_ED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
