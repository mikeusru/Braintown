function varargout = uaa_largeImageGui(varargin)
% UAA_LARGEIMAGEGUI MATLAB code for uaa_largeImageGui.fig
%      UAA_LARGEIMAGEGUI, by itself, creates a new UAA_LARGEIMAGEGUI or raises the existing
%      singleton*.
%
%      H = UAA_LARGEIMAGEGUI returns the handle to a new UAA_LARGEIMAGEGUI or the handle to
%      the existing singleton*.
%
%      UAA_LARGEIMAGEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UAA_LARGEIMAGEGUI.M with the given input arguments.
%
%      UAA_LARGEIMAGEGUI('Property','Value',...) creates a new UAA_LARGEIMAGEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before uaa_largeImageGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to uaa_largeImageGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help uaa_largeImageGui

% Last Modified by GUIDE v2.5 01-Oct-2015 14:53:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uaa_largeImageGui_OpeningFcn, ...
                   'gui_OutputFcn',  @uaa_largeImageGui_OutputFcn, ...
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


% --- Executes just before uaa_largeImageGui is made visible.
function uaa_largeImageGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to uaa_largeImageGui (see VARARGIN)

% Choose default command line output for uaa_largeImageGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global uaa

uaa.handles.uaa_largeImageGui=handles;
uaa.imageAnalysis.largeImage=1;
uaa_updateGUI(0,hObject);

% UIWAIT makes uaa_largeImageGui wait for user response (see UIRESUME)
% uiwait(handles.largeImageGui);


% --- Outputs from this function are returned to the command line.
function varargout = uaa_largeImageGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in leftPushbutton.
function leftPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to leftPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
if uaa.imageAnalysis.largeImage>1
   uaa.imageAnalysis.largeImage=uaa.imageAnalysis.largeImage-1;
end
uaa_updateGUI(0,hObject);


% --- Executes on button press in rightPushbutton.
function rightPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to rightPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
if uaa.imageAnalysis.largeImage < length(uaa.imageAnalysis.analyzedFigs)
    uaa.imageAnalysis.largeImage=uaa.imageAnalysis.largeImage+1;
    uaa_updateGUI(0,hObject);
else
    disp('no more images');
end
