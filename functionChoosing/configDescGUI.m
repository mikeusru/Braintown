function varargout = configDescGUI(varargin)
% CONFIGDESCGUI MATLAB code for configDescGUI.fig
%      CONFIGDESCGUI, by itself, creates a new CONFIGDESCGUI or raises the existing
%      singleton*.
%
%      H = CONFIGDESCGUI returns the handle to a new CONFIGDESCGUI or the handle to
%      the existing singleton*.
%
%      CONFIGDESCGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONFIGDESCGUI.M with the given input arguments.
%
%      CONFIGDESCGUI('Property','Value',...) creates a new CONFIGDESCGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before configDescGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to configDescGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help configDescGUI

% Last Modified by GUIDE v2.5 20-Jun-2016 11:05:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @configDescGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @configDescGUI_OutputFcn, ...
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


% --- Executes just before configDescGUI is made visible.
function configDescGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to configDescGUI (see VARARGIN)

% Choose default command line output for configDescGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes configDescGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = configDescGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function configInfoED_Callback(hObject, eventdata, handles)
% hObject    handle to configInfoED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of configInfoED as text
%        str2double(get(hObject,'String')) returns contents of configInfoED as a double


% --- Executes during object creation, after setting all properties.
function configInfoED_CreateFcn(hObject, eventdata, handles)
% hObject    handle to configInfoED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
[configInfo,ind] = uaa_loadConfigInfo;
if ~isempty(configInfo(ind))
    uaa_makeReviewDisp(configInfo(ind).review,hObject);
else
    set(hObject,'String','No Description Available');
end

function uaa_makeReviewDisp(r,hObject)
dispCells = cell(length(r),1);
lineBrk = '--------------------------';
for i=1:length(r)
    if isfield(r(i),'stars')
        stars = [num2str(r(i).stars),' Stars'];
    else stars = ''; 
    end
    if isfield(r(i),'purpose')
        purpose = r(i).purpose;
    else purpose = '';
    end
    dispCells{i} = sprintf('%s\n\n%s\n%s\n',stars,purpose,lineBrk);
end
set(hObject,'String',dispCells);



function purposeED_Callback(hObject, eventdata, handles)
% hObject    handle to purposeED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of purposeED as text
%        str2double(get(hObject,'String')) returns contents of purposeED as a double


% --- Executes during object creation, after setting all properties.
function purposeED_CreateFcn(hObject, eventdata, handles)
% hObject    handle to purposeED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function starsED_Callback(hObject, eventdata, handles)
% hObject    handle to starsED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of starsED as text
%        str2double(get(hObject,'String')) returns contents of starsED as a double


% --- Executes during object creation, after setting all properties.
function starsED_CreateFcn(hObject, eventdata, handles)
% hObject    handle to starsED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addReviewPB.
function addReviewPB_Callback(hObject, eventdata, handles)
% hObject    handle to addReviewPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%load fresh config file
[configInfo,ind] = uaa_loadConfigInfo;
%save info from edit boxes
stars = str2double(get(handles.starsED,'String'));
purpose = get(handles.purposeED,'String');
%append to review
if ~isempty(configInfo(ind))
    len = length(configInfo(ind).review) + 1;
else
    ind = length(configInfo) + 1;
    len = 1;
end
configInfo(ind).review(len).stars = stars;
configInfo(ind).review(len).purpose = purpose;
%save file
dirStr = which('configInfo.mat');
save(dirStr,'configInfo');
%update gui
uaa_makeReviewDisp(configInfo(ind).review,handles.configInfoED);
