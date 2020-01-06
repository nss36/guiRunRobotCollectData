function varargout = guiExtractPlotData(varargin)
% GUIEXTRACTPLOTDATA MATLAB code for guiExtractPlotData.fig
%      GUIEXTRACTPLOTDATA, by itself, creates a new GUIEXTRACTPLOTDATA or raises the existing
%      singleton*.
%
%      H = GUIEXTRACTPLOTDATA returns the handle to a new GUIEXTRACTPLOTDATA or the handle to
%      the existing singleton*.
%
%      GUIEXTRACTPLOTDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIEXTRACTPLOTDATA.M with the given input arguments.
%
%      GUIEXTRACTPLOTDATA('Property','Value',...) creates a new GUIEXTRACTPLOTDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiExtractPlotData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiExtractPlotData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiExtractPlotData

% Last Modified by GUIDE v2.5 03-Jan-2020 15:25:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiExtractPlotData_OpeningFcn, ...
                   'gui_OutputFcn',  @guiExtractPlotData_OutputFcn, ...
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

function handles = initVariables(handles,dataStruct)
handles.figureDirectory = [];
handles.figureNames = {};
handles.numRows = 1;
handles.numColumns = 1;
handles.numPlots = 0;
handles.startTime = min(dataStruct.time);
handles.endTime = max(dataStruct.time);
handles.dataStruct = dataStruct; 
handles.plotStyleFlag = 0;

% --- Executes just before guiExtractPlotData is made visible.
function guiExtractPlotData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiExtractPlotData (see VARARGIN)

% Choose default command line output for guiExtractPlotData
dataStruct = varargin{1};

handles.output = hObject;

handles = initVariables(handles,dataStruct);

if nargin == 4
    set(handles.listboxNotToPlot,'String',handles.dataStruct.colheaders);
%     handles.listboxNotToPlot.String = handles.dataStruct.colheaders;
    guidata(hObject,handles);
    
end

%Fill in appropriate start and end times
% handles.editStartTime.String = num2str(min(handles.dataStruct.time));
% handles.editEndTime.String = num2str(max(handles.dataStruct.time));
set(handles.editStartTime,'String',num2str(min(handles.dataStruct.time)));
set(handles.editEndTime,'String',num2str(max(handles.dataStruct.time)));

%Set the plot style flag
% 0 - Multiple subplots
% 1 - Single plot (shared y axis)
% 2 - Versus (2D or 3D "portrait" plot)
handles.plotStyleFlag = 0;
set(handles.radiobuttonMulti,'Value',1);
set(handles.radiobuttonSingle,'Value',0);
set(handles.radiobuttonVersus,'Value',0);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiExtractPlotData wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiExtractPlotData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listboxNotToPlot.
function listboxNotToPlot_Callback(hObject, eventdata, handles)
% hObject    handle to listboxNotToPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxNotToPlot contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxNotToPlot


% --- Executes during object creation, after setting all properties.
function listboxNotToPlot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxNotToPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in listboxToPlot.
function listboxToPlot_Callback(hObject, eventdata, handles)
% hObject    handle to listboxToPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxToPlot contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxToPlot


% --- Executes during object creation, after setting all properties.
function listboxToPlot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxToPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonInclude.
function pushbuttonInclude_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonInclude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.listboxNotToPlot.String)
    input = handles.listboxNotToPlot.String{handles.listboxNotToPlot.Value};
    handles.listboxNotToPlot.String(handles.listboxNotToPlot.Value) = [];
    if isempty(handles.listboxToPlot.String)
        handles.listboxToPlot.String = {input};
        handles.listboxToPlot.Value = 1;
    else
        handles.listboxToPlot.String = [handles.listboxToPlot.String;input];
    end
    %Removing the last index from the list causes a problem, because the
    %listbox will have a Value that is longer than its length. In that case,
    %adjust the value.
    if handles.listboxNotToPlot.Value > length(handles.listboxNotToPlot.String)
        handles.listboxNotToPlot.Value = length(handles.listboxNotToPlot.String);
    elseif handles.listboxNotToPlot.Value < 0
        handles.listboxNotToPlot.Value = 0;
    end
end
handles.numPlots = length(handles.listboxToPlot.String);
handles.textNumEntries.String = num2str(handles.numPlots);

handles.numRows = handles.numPlots;
handles.textNumRows.String = num2str(handles.numRows);

handles.graphs = handles.listboxToPlot.String;
guidata(hObject,handles);

% --- Executes on button press in pushbuttonExclude.
function pushbuttonExclude_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonExclude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.listboxToPlot.String)
    input = handles.listboxToPlot.String{handles.listboxToPlot.Value};
    handles.listboxToPlot.String(handles.listboxToPlot.Value) = [];
    if isempty(handles.listboxNotToPlot.String)
        handles.listboxNotToPlot.String = {input};
        handles.listboxNotToPlot.Value = 1;
    else
        handles.listboxNotToPlot.String = [handles.listboxNotToPlot.String;input];
    end
    %Removing the last index from the list causes a problem, because the
    %listbox will have a Value that is longer than its length. In that case,
    %adjust the value.
    if handles.listboxToPlot.Value > length(handles.listboxToPlot.String)
        handles.listboxToPlot.Value = length(handles.listboxToPlot.String);
    elseif handles.listboxToPlot.Value < 0
        handles.listboxToPlot.Value = 0;
    end
end
handles.numPlots = length(handles.listboxToPlot.String);
handles.textNumEntries.String = num2str(handles.numPlots);

handles.numRows = handles.numPlots;
handles.textNumRows.String = num2str(handles.numRows);

handles.graphs = handles.listboxToPlot.String;
guidata(hObject,handles);

% --- Executes on button press in pushbuttonIncreaseRows.
function pushbuttonIncreaseRows_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonIncreaseRows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.numRows = handles.numRows + 1;
handles.textNumRows.String = num2str(handles.numRows);
guidata(hObject,handles);

% --- Executes on button press in pushbuttonDecreaseRows.
function pushbuttonDecreaseRows_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonDecreaseRows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.numRows >= 1
    handles.numRows = handles.numRows - 1;
end
handles.textNumRows.String = num2str(handles.numRows);
guidata(hObject,handles);

% --- Executes on button press in pushbuttonIncreaseColumns.
function pushbuttonIncreaseColumns_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonIncreaseColumns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.numColumns = handles.numColumns + 1;
handles.textNumColumns.String = num2str(handles.numColumns);
guidata(hObject,handles);

% --- Executes on button press in pushbuttonDecreaseColumns.
function pushbuttonDecreaseColumns_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonDecreaseColumns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.numColumns >= 1
    handles.numColumns = handles.numColumns - 1;
end
handles.textNumColumns.String = num2str(handles.numColumns);
guidata(hObject,handles);


% --- Executes on button press in pushbuttonPlot.
function pushbuttonPlot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.numRows*handles.numColumns < handles.numPlots
    warning('Must have rows*columns >= entries.')
end
fprintf('start: %f, end: %f.\n',handles.startTime,handles.endTime);
nCols = length(handles.listboxToPlot.String);
columnsToPlot = NaN(nCols,1);
for i=1:nCols
    try columnsToPlot(i) = find(strcmp(handles.listboxToPlot.String{i},handles.dataStruct.colheaders),1,'first');
    catch
        keyboard
    end
end
timeRange = [handles.startTime,handles.endTime];
subplotSize = [handles.numRows,handles.numColumns];
fExtractPlotData(handles.dataStruct,columnsToPlot,timeRange,subplotSize,handles.plotStyleFlag);
guidata(hObject,handles);



function editStartTime_Callback(hObject, eventdata, handles)
% hObject    handle to editStartTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStartTime as text
%        str2double(get(hObject,'String')) returns contents of editStartTime as a double
handles.startTime = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function editStartTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editStartTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editEndTime_Callback(hObject, eventdata, handles)
% hObject    handle to editEndTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editEndTime as text
%        str2double(get(hObject,'String')) returns contents of editEndTime as a double
handles.endTime = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function editEndTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editEndTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function figure1_DeleteFcn(hObject, eventdata, handles)


% --- Executes on button press in radiobuttonMulti.
function radiobuttonMulti_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonMulti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobuttonMulti
if get(hObject,'Value')
    %turn off other radio buttons
    set(handles.radiobuttonMulti,'Value',1);
    set(handles.radiobuttonSingle,'Value',0);
    set(handles.radiobuttonVersus,'Value',0);
    
    %set plot style flag
    handles.plotStyleFlag = 0;
    
    set(handles.text4,'Visible','on')
    set(handles.text6,'Visible','on')
    set(handles.text8,'Visible','on')
    set(handles.textNumRows,'Visible','on')
    set(handles.textNumColumns,'Visible','on')
    set(handles.pushbuttonIncreaseRows,'Visible','on')
    set(handles.pushbuttonDecreaseRows,'Visible','on')
    set(handles.pushbuttonIncreaseColumns,'Visible','on')
    set(handles.pushbuttonDecreaseColumns,'Visible','on')
else
    %You cannot turn it off by clicking it. If the user turns it off, turn
    %it right back on.
    set(hObject,'Value',1);
end
guidata(hObject,handles);

% --- Executes on button press in radiobuttonSingle.
function radiobuttonSingle_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonSingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobuttonSingle
if get(hObject,'Value')
    %turn off other radio buttons
    set(handles.radiobuttonMulti,'Value',0);
    set(handles.radiobuttonSingle,'Value',1);
    set(handles.radiobuttonVersus,'Value',0);
    
    %set plot style flag
    handles.plotStyleFlag = 1;
    
    set(handles.text4,'Visible','off')
    set(handles.text6,'Visible','off')
    set(handles.text8,'Visible','off')
    set(handles.textNumRows,'Visible','off')
    set(handles.textNumColumns,'Visible','off')
    set(handles.pushbuttonIncreaseRows,'Visible','off')
    set(handles.pushbuttonDecreaseRows,'Visible','off')
    set(handles.pushbuttonIncreaseColumns,'Visible','off')
    set(handles.pushbuttonDecreaseColumns,'Visible','off')
else
    %You cannot turn it off by clicking it. If the user turns it off, turn
    %it right back on.
    set(hObject,'Value',1);
end
guidata(hObject,handles);

% --- Executes on button press in radiobuttonVersus.
function radiobuttonVersus_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonVersus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobuttonVersus
if get(hObject,'Value')
    %turn off other radio buttons
    set(handles.radiobuttonMulti,'Value',0);
    set(handles.radiobuttonSingle,'Value',0);
    set(handles.radiobuttonVersus,'Value',1);
    
    %set plot style flag
    handles.plotStyleFlag = 2;
    
    set(handles.text4,'Visible','off')
    set(handles.text6,'Visible','off')
    set(handles.text8,'Visible','off')
    set(handles.textNumRows,'Visible','off')
    set(handles.textNumColumns,'Visible','off')
    set(handles.pushbuttonIncreaseRows,'Visible','off')
    set(handles.pushbuttonDecreaseRows,'Visible','off')
    set(handles.pushbuttonIncreaseColumns,'Visible','off')
    set(handles.pushbuttonDecreaseColumns,'Visible','off')
else
    %You cannot turn it off by clicking it. If the user turns it off, turn
    %it right back on.
    set(hObject,'Value',1);
end
guidata(hObject,handles);