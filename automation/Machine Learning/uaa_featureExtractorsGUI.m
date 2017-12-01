function varargout = uaa_featureExtractorsGUI(varargin)
% UAA_FEATUREEXTRACTORSGUI MATLAB code for uaa_featureExtractorsGUI.fig
%      UAA_FEATUREEXTRACTORSGUI, by itself, creates a new UAA_FEATUREEXTRACTORSGUI or raises the existing
%      singleton*.
%
%      H = UAA_FEATUREEXTRACTORSGUI returns the handle to a new UAA_FEATUREEXTRACTORSGUI or the handle to
%      the existing singleton*.
%
%      UAA_FEATUREEXTRACTORSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UAA_FEATUREEXTRACTORSGUI.M with the given input arguments.
%
%      UAA_FEATUREEXTRACTORSGUI('Property','Value',...) creates a new UAA_FEATUREEXTRACTORSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before uaa_featureExtractorsGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to uaa_featureExtractorsGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help uaa_featureExtractorsGUI

% Last Modified by GUIDE v2.5 17-Jan-2017 13:16:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uaa_featureExtractorsGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @uaa_featureExtractorsGUI_OutputFcn, ...
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


% --- Executes just before uaa_featureExtractorsGUI is made visible.
function uaa_featureExtractorsGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to uaa_featureExtractorsGUI (see VARARGIN)

% Choose default command line output for uaa_featureExtractorsGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes uaa_featureExtractorsGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = uaa_featureExtractorsGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pdfdbCB.
function pdfdbCB_Callback(hObject, eventdata, handles)
% hObject    handle to pdfdbCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
uaa.featureExtractors.pdfdb = get(hObject,'Value');
uaa_saveFeatureExtractorSettings;
% Hint: get(hObject,'Value') returns toggle state of pdfdbCB


% --- Executes on button press in pdfsbCB.
function pdfsbCB_Callback(hObject, eventdata, handles)
% hObject    handle to pdfsbCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
uaa.featureExtractors.pdfsb = get(hObject,'Value');
uaa_saveFeatureExtractorSettings;

% Hint: get(hObject,'Value') returns toggle state of pdfsbCB


% --- Executes on button press in sttdbilCB.
function sttdbilCB_Callback(hObject, eventdata, handles)
% hObject    handle to sttdbilCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
uaa.featureExtractors.sttdbil = get(hObject,'Value');
uaa_saveFeatureExtractorSettings;

% Hint: get(hObject,'Value') returns toggle state of sttdbilCB


% --- Executes during object creation, after setting all properties.
function pdfdbCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pdfdbCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global uaa
set(hObject,'Value',uaa.featureExtractors.pdfdb);


% --- Executes during object creation, after setting all properties.
function pdfsbCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pdfsbCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global uaa
set(hObject,'Value',uaa.featureExtractors.pdfsb);


% --- Executes during object creation, after setting all properties.
function sttdbilCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sttdbilCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global uaa
set(hObject,'Value',uaa.featureExtractors.sttdbil);
