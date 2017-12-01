function varargout = uaa_autoOptions(varargin)
% UAA_AUTOOPTIONS MATLAB code for uaa_autoOptions.fig
%      UAA_AUTOOPTIONS, by itself, creates a new UAA_AUTOOPTIONS or raises the existing
%      singleton*.
%
%      H = UAA_AUTOOPTIONS returns the handle to a new UAA_AUTOOPTIONS or the handle to
%      the existing singleton*.
%
%      UAA_AUTOOPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UAA_AUTOOPTIONS.M with the given input arguments.
%
%      UAA_AUTOOPTIONS('Property','Value',...) creates a new UAA_AUTOOPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before uaa_autoOptions_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to uaa_autoOptions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help uaa_autoOptions

% Last Modified by GUIDE v2.5 09-Oct-2015 15:04:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @uaa_autoOptions_OpeningFcn, ...
    'gui_OutputFcn',  @uaa_autoOptions_OutputFcn, ...
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


% --- Executes just before uaa_autoOptions is made visible.
function uaa_autoOptions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to uaa_autoOptions (see VARARGIN)

% Choose default command line output for uaa_autoOptions
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global uaa
uaa.handles.uaa_autoOptions=handles;
uaa_updateGUI(1);


% UIWAIT makes uaa_autoOptions wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = uaa_autoOptions_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function tfdvEdit_Callback(hObject, eventdata, handles)
% hObject    handle to tfdvEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
% uaa.settings.watershed.tophatDisk=str2double(get(hObject,'String'));
setWatershedSetting(hObject);
uaa_updateImage;
% Hints: get(hObject,'String') returns contents of tfdvEdit as text
%        str2double(get(hObject,'String')) returns contents of tfdvEdit as a double


% --- Executes during object creation, after setting all properties.
function tfdvEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tfdvEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% global uaa
% set(hObject,'String',num2str(uaa.settings.watershed.tfd));
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function tophatDiskSlider_Callback(hObject, eventdata, handles)
% hObject    handle to tophatDiskSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function tophatDiskSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tophatDiskSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in inverseCheckbox.
function inverseCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to inverseCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
uaa.settings.watershed.inverseImage=get(hObject,'Value');
uaa_updateImage;
% Hint: get(hObject,'Value') returns toggle state of inverseCheckbox



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function bw3iovEdit_Callback(hObject, eventdata, handles)
% hObject    handle to bw3iovEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
% uaa.settings.watershed.bw3imopen=str2double(get(hObject,'String'));
setWatershedSetting(hObject);
uaa_updateImage;

% Hints: get(hObject,'String') returns contents of bw3iovEdit as text
%        str2double(get(hObject,'String')) returns contents of bw3iovEdit as a double


% --- Executes during object creation, after setting all properties.
function bw3iovEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw3iovEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% global uaa
% set(hObject,'String',num2str(uaa.settings.watershed.bw3imopen));
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function bw4aovEdit_Callback(hObject, eventdata, handles)
% hObject    handle to bw4aovEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
% uaa.settings.watershed.bw4areaOpen=str2double(get(hObject,'String'));
setWatershedSetting(hObject);
uaa_updateImage;
% Hints: get(hObject,'String') returns contents of bw4aovEdit as text
%        str2double(get(hObject,'String')) returns contents of bw4aovEdit as a double


% --- Executes during object creation, after setting all properties.
function bw4aovEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw4aovEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% global uaa
% set(hObject,'String',num2str(uaa.settings.watershed.bw4areaOpen));
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function mslvEdit_Callback(hObject, eventdata, handles)
% hObject    handle to mslvEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
% uaa.settings.watershed.bw5spur=str2double(get(hObject,'String'));
setWatershedSetting(hObject);
uaa_updateImage;

% Hints: get(hObject,'String') returns contents of mslvEdit as text
%        str2double(get(hObject,'String')) returns contents of mslvEdit as a double


% --- Executes during object creation, after setting all properties.
function mslvEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mslvEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% global uaa
% set(hObject,'String',num2str(uaa.settings.watershed.bw5spur));
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function bw5aovEdit_Callback(hObject, eventdata, handles)
% hObject    handle to bw5aovEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
% uaa.settings.watershed.bw5areaOpen=str2double(get(hObject,'String'));
setWatershedSetting(hObject);
uaa_updateImage;
% Hints: get(hObject,'String') returns contents of bw5aovEdit as text
%        str2double(get(hObject,'String')) returns contents of bw5aovEdit as a double


% --- Executes during object creation, after setting all properties.
function bw5aovEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw5aovEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% global uaa
% set(hObject,'String',num2str(uaa.settings.watershed.bw5areaOpen));
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function bw6imcvEdit_Callback(hObject, eventdata, handles)
% hObject    handle to bw6imcvEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
% uaa.settings.watershed.bw6imcloseDisk=str2double(get(hObject,'String'));
setWatershedSetting(hObject);
uaa_updateImage;
% Hints: get(hObject,'String') returns contents of bw6imcvEdit as text
%        str2double(get(hObject,'String')) returns contents of bw6imcvEdit as a double


% --- Executes during object creation, after setting all properties.
function bw6imcvEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw6imcvEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% global uaa
% set(hObject,'String',num2str(uaa.settings.watershed.bw6imcloseDisk));
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function bw7aovEdit_Callback(hObject, eventdata, handles)
% hObject    handle to bw7aovEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
% uaa.settings.watershed.bw7areaopen=str2double(get(hObject,'String'));
setWatershedSetting(hObject);
uaa_updateImage;
% Hints: get(hObject,'String') returns contents of bw7aovEdit as text
%        str2double(get(hObject,'String')) returns contents of bw7aovEdit as a double


% --- Executes during object creation, after setting all properties.
function bw7aovEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw7aovEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% global uaa
% set(hObject,'String',num2str(uaa.settings.watershed.bw7areaopen));
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function imexvEdit_Callback(hObject, eventdata, handles)
% hObject    handle to imexvEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
% uaa.settings.watershed.imextendedmaxInput=str2double(get(hObject,'String'));
setWatershedSetting(hObject);
uaa_updateImage;
% Hints: get(hObject,'String') returns contents of imexvEdit as text
%        str2double(get(hObject,'String')) returns contents of imexvEdit as a double


% --- Executes during object creation, after setting all properties.
function imexvEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imexvEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% global uaa
% set(hObject,'String',num2str(uaa.settings.watershed.imextendedmaxInput));
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider9_Callback(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function micvEdit_Callback(hObject, eventdata, handles)
% hObject    handle to micvEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
% uaa.settings.watershed.maskImclose=str2double(get(hObject,'String'));
setWatershedSetting(hObject);
uaa_updateImage;
% Hints: get(hObject,'String') returns contents of micvEdit as text
%        str2double(get(hObject,'String')) returns contents of micvEdit as a double


% --- Executes during object creation, after setting all properties.
function micvEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to micvEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% global uaa
% set(hObject,'String',num2str(uaa.settings.watershed.mic));
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider10_Callback(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function mbwaovEdit_Callback(hObject, eventdata, handles)
% hObject    handle to mbwaovEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
% uaa.settings.watershed.maskBwareaopen=str2double(get(hObject,'String'));
setWatershedSetting(hObject);
uaa_updateImage;
% Hints: get(hObject,'String') returns contents of mbwaovEdit as text
%        str2double(get(hObject,'String')) returns contents of mbwaovEdit as a double


% --- Executes during object creation, after setting all properties.
function mbwaovEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mbwaovEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% global uaa
% set(hObject,'String',num2str(uaa.settings.watershed.mbwao));
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider11_Callback(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit3_CreateFcn(hObject, eventdata, handles)
function slider1_CreateFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function inverseCheckbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inverseCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global uaa
set(hObject,'Value',uaa.settings.watershed.inverseImage);


% --- Executes on button press in runAutoAnalysisButton.
function runAutoAnalysisButton_Callback(hObject, eventdata, handles)
% hObject    handle to runAutoAnalysisButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% uaa_analyzeSingleImage;
uaa_updateImage;

% --- Executes on button press in largeImageAnalysisPushbutton.
function largeImageAnalysisPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to largeImageAnalysisPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_largeImageGui;


% --- Executes on button press in removeTransparencyCheckbox.
function removeTransparencyCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to removeTransparencyCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
uaa.settings.watershed.removeTransparency=get(hObject,'Value');
% Hint: get(hObject,'Value') returns toggle state of removeTransparencyCheckbox


% --- Executes during object creation, after setting all properties.
function removeTransparencyCheckbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to removeTransparencyCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global uaa
set(hObject,'Value',uaa.settings.watershed.removeTransparency);


% --- Executes on button press in doWatershedCheckbox.
function doWatershedCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to doWatershedCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
uaa.settings.watershed.doWatershed=get(hObject,'Value');
uaa_updateGUI;
uaa_makeFig( 1 );
uaa_updateImage;
uaa_saveSettings;
% Hint: get(hObject,'Value') returns toggle state of doWatershedCheckbox


% --- Executes during object creation, after setting all properties.
function doWatershedCheckbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to doWatershedCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global uaa
set(hObject,'Value',uaa.settings.watershed.doWatershed);


% --- Executes on selection change in watershedSettingsPopup.
function watershedSettingsPopup_Callback(hObject, eventdata, handles)
% hObject    handle to watershedSettingsPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
wshedOff=false;
if ~uaa.settings.watershed.doWatershed
    wshedOff=true;
end

val=get(hObject,'Value');
% settingsNames=get(hObject,'String');
fName=uaa.wShed.propNames{val,2};

fPath=mfilename('fullpath');
[pName,~,~]=fileparts(fPath);
pName=[pName,'\automation\watershed_settings\',fName];

if exist(pName,'file')
    S=load(pName);
    uaa.settings.watershed=S;
else
    disp('ERROR - File Does Not Exist');
    disp(pName);
end
if wshedOff && uaa.settings.watershed.doWatershed
    uaa_makeFig( 1 );
end
uaa_updateGUI( 1 );
uaa_updateImage;


% Hints: contents = cellstr(get(hObject,'String')) returns watershedSettingsPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from watershedSettingsPopup


% --- Executes during object creation, after setting all properties.
function watershedSettingsPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to watershedSettingsPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global uaa
fPath=mfilename('fullpath');
[pName,~,~]=fileparts(fPath);
pName=[pName,'\automation\watershed_settings\'];
listing=dir(pName);
propNames=cell(1,2);
ii=1;
for i=1:length(listing)
    if ~isempty(strfind(listing(i).name,'.mat'))
        try
            S=load(listing(i).name,'fName');
            propNames{ii,1}=S.fName;
            propNames{ii,2}=[listing(i).name];
            ii=ii+1;
        catch ME
            disp(ME.message);
        end
    end
end
uaa.wShed.propNames=propNames;
set(hObject,'String',propNames(:,1));
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in updateSettingPushbutton.
function updateSettingPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to updateSettingPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uaa_saveSettings(1);

% --- Executes on button press in newSettingPushbutton.
function newSettingPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to newSettingPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
fName=cell2mat(inputdlg('Settings Name'));
uaa.settings.watershed.fName=fName;
uaa_saveSettings(1);
watershedSettingsPopup_CreateFcn(uaa.handles.uaa_autoOptions.watershedSettingsPopup);
settingsStr=get(uaa.handles.uaa_autoOptions.watershedSettingsPopup,'String');
val=strfind(settingsStr,fName);
val=find(~cellfun(@isempty,val));
if ~isempty(val)
    set(uaa.handles.uaa_autoOptions.watershedSettingsPopup,'Value',val(1));
end


function gbrvEdit_Callback(hObject, eventdata, handles)
% hObject    handle to gbrvEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uaa
setWatershedSetting(hObject);
% uaa.settings.watershed.gaussSigma=str2double(get(hObject,'String'));
uaa_updateImage;
% Hints: get(hObject,'String') returns contents of gbrvEdit as text
%        str2double(get(hObject,'String')) returns contents of gbrvEdit as a double


% --- Executes during object creation, after setting all properties.
function gbrvEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gbrvEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% global uaa
% set(hObject,'String',num2str(uaa.settings.watershed.gbr));
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tfdre1_Callback(hObject, eventdata, handles)
% hObject    handle to tfdre1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of tfdre1 as text
%        str2double(get(hObject,'String')) returns contents of tfdre1 as a double


% --- Executes during object creation, after setting all properties.
function tfdre1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tfdre1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bw3iore1_Callback(hObject, eventdata, handles)
% hObject    handle to bw3iore1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of bw3iore1 as text
%        str2double(get(hObject,'String')) returns contents of bw3iore1 as a double


% --- Executes during object creation, after setting all properties.
function bw3iore1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw3iore1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bw4aore1_Callback(hObject, eventdata, handles)
% hObject    handle to bw4aore1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of bw4aore1 as text
%        str2double(get(hObject,'String')) returns contents of bw4aore1 as a double


% --- Executes during object creation, after setting all properties.
function bw4aore1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw4aore1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mslre1_Callback(hObject, eventdata, handles)
% hObject    handle to mslre1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of mslre1 as text
%        str2double(get(hObject,'String')) returns contents of mslre1 as a double


% --- Executes during object creation, after setting all properties.
function mslre1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mslre1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bw5aore1_Callback(hObject, eventdata, handles)
% hObject    handle to bw5aore1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of bw5aore1 as text
%        str2double(get(hObject,'String')) returns contents of bw5aore1 as a double


% --- Executes during object creation, after setting all properties.
function bw5aore1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw5aore1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bw6imcre1_Callback(hObject, eventdata, handles)
% hObject    handle to bw6imcre1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of bw6imcre1 as text
%        str2double(get(hObject,'String')) returns contents of bw6imcre1 as a double


% --- Executes during object creation, after setting all properties.
function bw6imcre1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw6imcre1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bw7aore1_Callback(hObject, eventdata, handles)
% hObject    handle to bw7aore1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of bw7aore1 as text
%        str2double(get(hObject,'String')) returns contents of bw7aore1 as a double


% --- Executes during object creation, after setting all properties.
function bw7aore1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw7aore1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function imexre1_Callback(hObject, eventdata, handles)
% hObject    handle to imexre1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of imexre1 as text
%        str2double(get(hObject,'String')) returns contents of imexre1 as a double


% --- Executes during object creation, after setting all properties.
function imexre1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imexre1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function micre1_Callback(hObject, eventdata, handles)
% hObject    handle to micre1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of micre1 as text
%        str2double(get(hObject,'String')) returns contents of micre1 as a double


% --- Executes during object creation, after setting all properties.
function micre1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to micre1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mbwaore1_Callback(hObject, eventdata, handles)
% hObject    handle to mbwaore1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of mbwaore1 as text
%        str2double(get(hObject,'String')) returns contents of mbwaore1 as a double


% --- Executes during object creation, after setting all properties.
function mbwaore1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mbwaore1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gbre1_Callback(hObject, eventdata, handles)
% hObject    handle to gbre1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of gbre1 as text
%        str2double(get(hObject,'String')) returns contents of gbre1 as a double


% --- Executes during object creation, after setting all properties.
function gbre1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gbre1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tfdre2_Callback(hObject, eventdata, handles)
% hObject    handle to tfdre2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of tfdre2 as text
%        str2double(get(hObject,'String')) returns contents of tfdre2 as a double


% --- Executes during object creation, after setting all properties.
function tfdre2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tfdre2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bw3iore2_Callback(hObject, eventdata, handles)
% hObject    handle to bw3iore2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of bw3iore2 as text
%        str2double(get(hObject,'String')) returns contents of bw3iore2 as a double


% --- Executes during object creation, after setting all properties.
function bw3iore2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw3iore2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bw4aore2_Callback(hObject, eventdata, handles)
% hObject    handle to bw4aore2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of bw4aore2 as text
%        str2double(get(hObject,'String')) returns contents of bw4aore2 as a double


% --- Executes during object creation, after setting all properties.
function bw4aore2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw4aore2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mslre2_Callback(hObject, eventdata, handles)
% hObject    handle to mslre2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of mslre2 as text
%        str2double(get(hObject,'String')) returns contents of mslre2 as a double


% --- Executes during object creation, after setting all properties.
function mslre2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mslre2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bw5aore2_Callback(hObject, eventdata, handles)
% hObject    handle to bw5aore2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of bw5aore2 as text
%        str2double(get(hObject,'String')) returns contents of bw5aore2 as a double


% --- Executes during object creation, after setting all properties.
function bw5aore2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw5aore2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bw6imcre2_Callback(hObject, eventdata, handles)
% hObject    handle to bw6imcre2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of bw6imcre2 as text
%        str2double(get(hObject,'String')) returns contents of bw6imcre2 as a double


% --- Executes during object creation, after setting all properties.
function bw6imcre2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw6imcre2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bw7aore2_Callback(hObject, eventdata, handles)
% hObject    handle to bw7aore2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of bw7aore2 as text
%        str2double(get(hObject,'String')) returns contents of bw7aore2 as a double


% --- Executes during object creation, after setting all properties.
function bw7aore2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw7aore2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function imexre2_Callback(hObject, eventdata, handles)
% hObject    handle to imexre2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of imexre2 as text
%        str2double(get(hObject,'String')) returns contents of imexre2 as a double


% --- Executes during object creation, after setting all properties.
function imexre2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imexre2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function micre2_Callback(hObject, eventdata, handles)
% hObject    handle to micre2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of micre2 as text
%        str2double(get(hObject,'String')) returns contents of micre2 as a double


% --- Executes during object creation, after setting all properties.
function micre2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to micre2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mbwaore2_Callback(hObject, eventdata, handles)
% hObject    handle to mbwaore2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of mbwaore2 as text
%        str2double(get(hObject,'String')) returns contents of mbwaore2 as a double


% --- Executes during object creation, after setting all properties.
function mbwaore2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mbwaore2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gbre2_Callback(hObject, eventdata, handles)
% hObject    handle to gbre2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uaa_setRange(hObject);
% Hints: get(hObject,'String') returns contents of gbre2 as text
%        str2double(get(hObject,'String')) returns contents of gbre2 as a double


% --- Executes during object creation, after setting all properties.
function gbre2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gbre2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
uaa_getRangeForCreate(hObject);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function uaa_setRange(hObject)

global uaa
uaa.learningAnalysis.ranges.(get(hObject,'Tag'))=str2double(get(hObject,'String'));
uaa_setWatershedRanges;
%update slider
etag=get(hObject,'Tag');
hNames=fieldnames(uaa.handles.uaa_autoOptions);
if strfind(etag,'gbr')
    etag='gbrSlider';
else
    etag=[etag(1:end-3),'Slider'];
end
setSliderRange(uaa.handles.uaa_autoOptions.(etag));

uaa_saveSettings(0,1);
    
function uaa_getRangeForCreate(hObject)

global uaa
try
    objTag=get(hObject,'Tag');
    set(hObject,'String',num2str(uaa.learningAnalysis.ranges.(objTag)));
end


% --- Executes on button press in learningAnalysisTogglebutton.
function learningAnalysisTogglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to learningAnalysisTogglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function gbrSlider_Callback(hObject, eventdata, handles)
% hObject    handle to gbrSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setWatershedSetting(hObject);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function gbrSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gbrSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
setSliderRange(hObject);
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function tfdSlider_Callback(hObject, eventdata, handles)
% hObject    handle to tfdSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setWatershedSetting(hObject);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function tfdSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tfdSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
setSliderRange(hObject);

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function bw3ioSlider_Callback(hObject, eventdata, handles)
% hObject    handle to bw3ioSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setWatershedSetting(hObject);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function bw3ioSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw3ioSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
setSliderRange(hObject);
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function bw4aoSlider_Callback(hObject, eventdata, handles)
% hObject    handle to bw4aoSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setWatershedSetting(hObject);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function bw4aoSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw4aoSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
setSliderRange(hObject);
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function mslSlider_Callback(hObject, eventdata, handles)
% hObject    handle to mslSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setWatershedSetting(hObject);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function mslSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mslSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
setSliderRange(hObject);
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function bw5aoSlider_Callback(hObject, eventdata, handles)
% hObject    handle to bw5aoSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setWatershedSetting(hObject);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function bw5aoSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw5aoSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
setSliderRange(hObject);
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function bw6imcSlider_Callback(hObject, eventdata, handles)
% hObject    handle to bw6imcSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setWatershedSetting(hObject);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function bw6imcSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw6imcSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
setSliderRange(hObject);
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function bw7aoSlider_Callback(hObject, eventdata, handles)
% hObject    handle to bw7aoSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setWatershedSetting(hObject);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function bw7aoSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw7aoSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
setSliderRange(hObject);
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function imexSlider_Callback(hObject, eventdata, handles)
% hObject    handle to imexSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setWatershedSetting(hObject);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function imexSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imexSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
setSliderRange(hObject);
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function micSlider_Callback(hObject, eventdata, handles)
% hObject    handle to micSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setWatershedSetting(hObject);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function micSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to micSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
setSliderRange(hObject);
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function mbwaoSlider_Callback(hObject, eventdata, handles)
% hObject    handle to mbwaoSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setWatershedSetting(hObject);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function mbwaoSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mbwaoSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
setSliderRange(hObject);
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function setSliderRange(hObject)
global uaa
fNamesRange=fieldnames(uaa.learningAnalysis.ranges);
sliderTag=get(hObject,'Tag');
sliderName=sliderTag(1:end-6);
ind=~cellfun(@isempty,strfind(fNamesRange,sliderName));
rangeNames=fNamesRange(ind);

if length(rangeNames)~=2
    disp(['error - cannot find appropriate range for slider ', sliderTag]);
    return
end

if strcmp(rangeNames{1}(end),'1')
    minRangeName=rangeNames{1};
    maxRangeName=rangeNames{2};
else
    minRangeName=rangeNames{2};
    maxRangeName=rangeNames{1};
end

minRange=uaa.learningAnalysis.ranges.(minRangeName);
maxRange=uaa.learningAnalysis.ranges.(maxRangeName);
set(hObject,'Min',minRange);
set(hObject,'Max',maxRange);
set(hObject,'SliderStep',[1/(maxRange-minRange),1/(maxRange-minRange)]);
set(hObject,'Value',uaa.settings.watershed.(sliderName));

function setWatershedSetting(hObject)
global uaa
settingStyle=get(hObject,'Style');
settingTag=get(hObject,'Tag');
switch settingStyle
    case 'slider'
        settingName=settingTag(1:end-6);
        uaa.imageAnalysis.lastUsedOptions=settingName;
        uaa.settings.watershed.(settingName)=get(hObject,'Value');
        set(uaa.handles.uaa_autoOptions.([settingName,'vEdit']),'String',num2str(uaa.settings.watershed.(settingName)));
        if get(uaa.handles.uaa_autoOptions.imgSliderUpdateCheckbox,'Value')
            uaa_updateImage;
        end
    case 'edit'
        settingName=settingTag(1:end-5);
        uaa.imageAnalysis.lastUsedOptions=settingName;
        uaa.settings.watershed.(settingName)=str2double(get(hObject,'String'));
        set(uaa.handles.uaa_autoOptions.([settingName,'Slider']),'Value',uaa.settings.watershed.(settingName));
end




% --- Executes on button press in imgSliderUpdateCheckbox.
function imgSliderUpdateCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to imgSliderUpdateCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of imgSliderUpdateCheckbox


% --- Executes on button press in updateSingleImageCheckbox.
function updateSingleImageCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to updateSingleImageCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of updateSingleImageCheckbox
