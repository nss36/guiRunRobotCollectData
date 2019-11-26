function varargout = guiRunRobotCollectData(varargin)
% GUIRUNROBOTCOLLECTDATA MATLAB code for guiRunRobotCollectData.fig
%      GUIRUNROBOTCOLLECTDATA, by itself, creates a new GUIRUNROBOTCOLLECTDATA or raises the existing
%      singleton*.
%
%      H = GUIRUNROBOTCOLLECTDATA returns the handle to a new GUIRUNROBOTCOLLECTDATA or the handle to
%      the existing singleton*.
%
%      GUIRUNROBOTCOLLECTDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIRUNROBOTCOLLECTDATA.M with the given input arguments.
%
%      GUIRUNROBOTCOLLECTDATA('Property','Value',...) creates a new GUIRUNROBOTCOLLECTDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiRunRobotCollectData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiRunRobotCollectData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiRunRobotCollectData

% Last Modified by GUIDE v2.5 18-Nov-2019 12:17:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiRunRobotCollectData_OpeningFcn, ...
                   'gui_OutputFcn',  @guiRunRobotCollectData_OutputFcn, ...
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


% --- Executes just before guiRunRobotCollectData is made visible.
function guiRunRobotCollectData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiRunRobotCollectData (see VARARGIN)

% Choose default command line output for guiRunRobotCollectData
handles.output = hObject;

handles = initVariables(handles);
handles.animatlabPathIndicator.String = handles.animatlabSimulator;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiRunRobotCollectData wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function handles = initVariables(handles)
handles.asimFile = [];
handles.asimPath = [];
handles.toSaveData = 1;
handles.toRunRobot = 1;
handles.isRobot = 1;
handles.animatlabSimulator = 'C:\AnimatLabSDK\AnimatLabPublicSource\bin\AnimatSimulator.exe';
handles.graphs = {};
handles.toPlotGUI = [];
handles.delayTime = 0;

% --- Outputs from this function are returned to the command line.
function varargout = guiRunRobotCollectData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbuttonSelectAsim.
function pushbuttonSelectAsim_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSelectAsim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('.asim');
if ~isequal(file,0)
    if strcmp(file(end-4:end),'.asim')
        handles.asimFile = file;
        handles.asimPath = path;
        handles.filenameIndicator.String = handles.asimFile;
        handles.pathIndicator.String = handles.asimPath;
        %Find all of the .aform files in this folder. This is the list of
        %possible plots.
        figureStruct = dir([handles.pathIndicator.String,'\*.aform']);
        %To extract just a list of names, we need to put one field from
        %every entry in a cell. But we need to process the names before we
        %can use them.
        numCharts = length({figureStruct.name});
        %Create a cell array to store the processed names.
        chartCell = cell(numCharts,1);
        for i=1:numCharts
            chartName = figureStruct(i).name;
            %Remove the file extension, because we will eventually import
            %.txt files with the same name.
            if strcmp(chartName(end-5:end),'.aform')
                chartName = chartName(1:end-6);
            end
            %Remove the underscores, because Animatlab changes them to
            %spaces. I don't know why.
            %chartName = strrep(chartName,'_',' ');
            %As of 31 Oct 19, this is no longer a problem. 
            chartCell{i} = chartName;
        end
        handles.aformListbox.String = chartCell;
        handles.plotsToExclude = chartCell;
    else
        fprintf('Please select a ".asim" file.\n')
    end
else
    fprintf('Please select a file.\n')
end
guidata(hObject,handles);

% --- Executes on button press in pushbuttonSelectAnimatlabPath.
function pushbuttonSelectAnimatlabPath_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSelectAnimatlabPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('.exe');
if ~isequal(file,0)
    if strcmp(file,'AnimatSimulator.exe')
        handles.animatlabSimulator = [path,file];
        handles.animatlabPathIndicator.String = handles.animatlabSimulator;
    else
        fprintf('Please find AnimatSimulator.exe, and point the "source" field to it.\n')
    end
end
guidata(hObject,handles);

% --- Executes on button press in checkboxSaveData.
function checkboxSaveData_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxSaveData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSaveData
handles.toSaveData = get(hObject,'Value');
guidata(hObject,handles);

function checkboxSaveData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkboxSaveData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSaveData
handles.toSaveData = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes on button press in checkboxRunRobot.
function checkboxRunRobot_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxSaveData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSaveData
handles.toRunRobot = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes on button press in checkboxRunRobot.
function checkboxRunRobot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkboxSaveData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSaveData
handles.toRunRobot = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes on selection change in aformListbox.
function aformListbox_Callback(hObject, eventdata, handles)
% hObject    handle to aformListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns aformListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from aformListbox

% --- Executes on selection change in aformListboxInclude.
function aformListboxInclude_Callback(hObject, eventdata, handles)
% hObject    handle to aformListboxInclude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns aformListboxInclude contents as cell array
%        contents{get(hObject,'Value')} returns selected item from aformListboxInclude

% --- Executes on button press in pushbuttonExclude.
function pushbuttonExclude_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to pushbuttonExclude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.aformListboxInclude.String)
    input = handles.aformListboxInclude.String{handles.aformListboxInclude.Value};
    handles.aformListboxInclude.String(handles.aformListboxInclude.Value) = [];
    if isempty(handles.aformListbox.String)
        handles.aformListbox.String = {input};
        handles.aformListbox.Value = 1;
    else
        handles.aformListbox.String = [handles.aformListbox.String;input];
    end
    %Removing the last index from the list causes a problem, because the
    %listbox will have a Value that is longer than its length. In that case,
    %adjust the value.
    if handles.aformListboxInclude.Value > length(handles.aformListboxInclude.String)
        handles.aformListboxInclude.Value = length(handles.aformListboxInclude.String);
    elseif handles.aformListboxInclude.Value < 0
        handles.aformListboxInclude.Value = 0;
    end
end
handles.graphs = handles.aformListboxInclude.String;
guidata(hObject,handles);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbuttonInclude.
function pushbuttonInclude_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to pushbuttonInclude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.aformListbox.String)
    input = handles.aformListbox.String{handles.aformListbox.Value};
    handles.aformListbox.String(handles.aformListbox.Value) = [];
    if isempty(handles.aformListboxInclude.String)
        handles.aformListboxInclude.String = {input};
        handles.aformListboxInclude.Value = 1;
    else
        handles.aformListboxInclude.String = [handles.aformListboxInclude.String;input];
    end
    %Removing the last index from the list causes a problem, because the
    %listbox will have a Value that is longer than its length. In that case,
    %adjust the value.
    if handles.aformListbox.Value > length(handles.aformListbox.String)
        handles.aformListbox.Value = length(handles.aformListbox.String);
    elseif handles.aformListbox.Value < 0
        handles.aformListbox.Value = 0;
    end
end
handles.graphs = handles.aformListboxInclude.String;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function aformListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aformListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function aformListboxInclude_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aformListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbuttonRunRobot.
function pushbuttonRunRobot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRunRobot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.toPlotGUI) && isvalid(handles.toPlotGUI)
    close(handles.toPlotGUI)
end
[status,message,dataStructure] = ...
    fRunRobotCollectData(handles.asimPath,handles.asimFile,...
    handles.animatlabSimulator,handles.graphs,handles.toRunRobot,handles.isRobot,handles.delayTime,handles.toSaveData);
if status == 0 || status == -1
    %No errors, or just plotting
    handles.toPlotGUI = guiExtractPlotData(dataStructure);
%     if isempty(handles.toPlotGUI)
%         handles.toPlotGUI = guiExtractPlotData(true,figureDirectory);
%     else
%         close(handles.toPlotGUI);
%         handles.toPlotGUI = guiExtractPlotData(true,figureDirectory);
%     end
else
    error(message)
end
guidata(hObject,handles);



function editDelayTime_Callback(hObject, eventdata, handles)
% hObject    handle to editDelayTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDelayTime as text
%        str2double(get(hObject,'String')) returns contents of editDelayTime as a double
handles.delayTime = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function editDelayTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDelayTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxIsRobot.
function checkboxIsRobot_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxSaveData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSaveData
handles.isRobot = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes on button press in checkboxIsRobot.
function checkboxIsRobot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkboxSaveData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSaveData
handles.isRobot = get(hObject,'Value');
guidata(hObject,handles);
