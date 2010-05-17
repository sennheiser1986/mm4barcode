function varargout = barcodereader_gui(varargin)
% BARCODEREADER_GUI M-file for barcodereader_gui.fig
%      BARCODEREADER_GUI, by itself, creates a new BARCODEREADER_GUI or raises the existing
%      singleton*.
%
%      H = BARCODEREADER_GUI returns the handle to a new BARCODEREADER_GUI or the handle to
%      the existing singleton*.
%
%      BARCODEREADER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BARCODEREADER_GUI.M with the given input arguments.
%
%      BARCODEREADER_GUI('Property','Value',...) creates a new BARCODEREADER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before barcodereader_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to barcodereader_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help barcodereader_gui

% Last Modified by GUIDE v2.5 17-May-2010 13:28:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @barcodereader_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @barcodereader_gui_OutputFcn, ...
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


% --- Executes just before barcodereader_gui is made visible.
function barcodereader_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to barcodereader_gui (see VARARGIN)
axes(handles.orgIm);
axis equal;
axis tight;
axis off;
axes(handles.turned_im);
axis equal;
axis tight;
axis off;
axes(handles.readim);
axis equal;
axis tight;
axis off;

% Choose default command line output for barcodereader_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes barcodereader_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = barcodereader_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_original

[FileName, PathName] = uigetfile({'*.jpg'; '*.tif';'*.gif'}, 'Select the file');
fullFileName = fullfile(PathName, FileName);

[im_original,map]=imread(char(fullFileName));
if ~isempty(map)
   im_original = ind2rgb(im_original,map); 
end
%read the image
if ~isempty(im_original)
set(handles.orgIm,'HandleVisibility','ON');
axes(handles.orgIm);
image(im_original);
axis equal;
axis tight;
axis off;
end;

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%turn image
global im_original;
[I2,flag] = anglex(im_original);
set(handles.turned_im,'HandleVisibility','ON');
axes(handles.turned_im);
imagesc(I2);
axis equal;
axis tight;
axis off;
%read image
[ans, new_bar, flag]= readimage(I2);
set(handles.readim,'HandleVisibility','ON');
axes(handles.readim);
imagesc(ans);
axis equal;
axis tight;
axis off;
%convert 
ans2= decodeEan(ans);
ans3 = mat2str(ans2);
set(handles.code, 'String', ans3)
