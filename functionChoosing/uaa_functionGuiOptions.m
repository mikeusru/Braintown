function varargout = uaa_functionGuiOptions(varargin)
% UAA_FUNCTIONGUIOPTIONS MATLAB code for uaa_functionGuiOptions.fig
%      UAA_FUNCTIONGUIOPTIONS, by itself, creates a new UAA_FUNCTIONGUIOPTIONS or raises the existing
%      singleton*.
%
%      H = UAA_FUNCTIONGUIOPTIONS returns the handle to a new UAA_FUNCTIONGUIOPTIONS or the handle to
%      the existing singleton*.
%
%      UAA_FUNCTIONGUIOPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UAA_FUNCTIONGUIOPTIONS.M with the given input arguments.
%
%      UAA_FUNCTIONGUIOPTIONS('Property','Value',...) creates a new UAA_FUNCTIONGUIOPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before uaa_functionGuiOptions_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to uaa_functionGuiOptions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help uaa_functionGuiOptions

% Last Modified by GUIDE v2.5 01-Nov-2016 08:55:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uaa_functionGuiOptions_OpeningFcn, ...
                   'gui_OutputFcn',  @uaa_functionGuiOptions_OutputFcn, ...
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


% --- Executes just before uaa_functionGuiOptions is made visible.
function uaa_functionGuiOptions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to uaa_functionGuiOptions (see VARARGIN)

% Choose default command line output for uaa_functionGuiOptions
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes uaa_functionGuiOptions wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = uaa_functionGuiOptions_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in currentFrameCB.
function currentFrameCB_Callback(hObject, eventdata, handles)
% hObject    handle to currentFrameCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
uaa.fxnChoosing.inputCurrentFrame = get(hObject,'value');
% Hint: get(hObject,'Value') returns toggle state of currentFrameCB



function optionalInputED_Callback(hObject, eventdata, handles)
% hObject    handle to optionalInputED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
uaa.fxnChoosing.optionalInput = get(hObject,'String');
numVars = size(uaa.fxnChoosing.optionalInput,1);
% split into lines
varLabels = mat2cell(uaa.fxnChoosing.optionalInput,ones(1,numVars));
varLabels = regexprep(varLabels,' ','');
uaa.fxnChoosing.optionalInputVars = reshape(varLabels,1,[]);
functionsGui('updateFunctionsList',uaa.handles.functionsGui.workingFunUIT);

% Hints: get(hObject,'String') returns contents of optionalInputED as text
%        str2double(get(hObject,'String')) returns contents of optionalInputED as a double


% --- Executes during object creation, after setting all properties.
function optionalInputED_CreateFcn(hObject, eventdata, handles)
% hObject    handle to optionalInputED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global uaa
if ~isfield (uaa.fxnChoosing, 'optionalInput')
    uaa.fxnChoosing.optionalInput = '';
end



set(hObject,'String',uaa.fxnChoosing.optionalInput);

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function currentFrameCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentFrameCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global uaa
if ~isfield(uaa.fxnChoosing,'inputCurrentFrame')
    uaa.fxnChoosing.inputCurrentFrame = 1;
end
set(hObject,'value',uaa.fxnChoosing.inputCurrentFrame);
