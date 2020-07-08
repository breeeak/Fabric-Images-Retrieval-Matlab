function varargout = Run(varargin)
% RUN M-file for Run.fig
%      RUN, by itself, creates a new RUN or raises the existing
%      singleton*.
%
%      H = RUN returns the handle to a new RUN or the handle to
%      the existing singleton*.
%
%      RUN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUN.M with the given input arguments.
%
%      RUN('Property','Value',...) creates a new RUN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Run_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Run_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Run

% Last Modified by GUIDE v2.5 01-Jun-2017 00:09:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Run_OpeningFcn, ...
    'gui_OutputFcn',  @Run_OutputFcn, ...
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


% --- Executes just before Run is made visible.
function Run_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Run (see VARARGIN)


% 程序一起动便读取图像，防止检索过慢的现象。
file_path = get( handles.edit_file_path , 'String' ) ;
num = 50 ;%现在只做了50个数据，数据过大的话启动会很慢
handles.num=num;
for i = 1:num
    file_index = [ file_path,num2str(i),'.jpg' ];
    File_store{i} = imread(file_index);%存入图像
    T(i) = GLCM(file_index);%存入图像(共生矩阵特征提取)
end
handles.File_store=File_store;
handles.T=T;

% 计算HSV的一、二、三阶颜色矩，共9个量作为颜色特征 ； 
    T = 0 ;%进度条
    hwait = waitbar(0,'对象库正在加载，请耐心等待=￣ω￣=');
    waitbar( T/100 , hwait  ) 
    
    HSV_f_store_1 = zeros( num , 3 ) ;%全为0的矩阵
    HSV_f_store_2 = zeros( num , 3 ) ;
    HSV_f_store_3 = zeros( num , 3 ) ;
    for i = 1:num
        % 调用函数hsvfeature 此函数即颜色矩的计算
        [ HSV_f_store_1(i,:) , HSV_f_store_2(i,:) , HSV_f_store_3(i,:) ] = hsvfeature( File_store{i} ) ;
        T = i/2 ;
        waitbar( T/100 , hwait ) 
    end
    handles.HSV_f_store_1=HSV_f_store_1;
    handles.HSV_f_store_2=HSV_f_store_2;
    handles.HSV_f_store_3=HSV_f_store_3;
    
    
    % 计算数据库中每个图像的7个形状不变矩，用作图像的形状特征；
    Hu_f_store = zeros( num,7 ) ;
    for i = 1:num
        Hu_f_store( i,: ) = Shape_7_moment ( File_store{i} ) ;
        T = i/2+25 ;
        waitbar( T/100 ,  hwait ,'对象库马上建好了，请稍等=￣ω￣=' )
    end
    handles.Hu_f_store=Hu_f_store;
        
     %取256点傅氏变换的后241个点，去掉低频分量；
    F_h = zeros( num,241 ) ; %去除低频分量，保留边缘特征，增强图像特征与去噪相反
    for i = 1:num
        F_h(i,:) = Fourier_texture2 ( File_store{i} ) ; 
        T = i+50 ;
        waitbar( T/100 ,  hwait ,'对象库已经建立好了，选择您想找的类型吧=￣ω￣=' )
    end
    handles.F_h(i,:)=F_h(i,:);
    waitbar(1, hwait )
    close( hwait ); % 注意必须添加close函数关闭waitbar
%界面的初始化
handles.Chose = 6 ;
guidata(hObject, handles);
handles.To_be_matched = 0 ; 
guidata(hObject, handles);
handles.color_w = 0.5 ;
guidata(hObject, handles);
handles.edge_w = 0.01 ;
guidata(hObject, handles);
handles.texture_w =0.01 ;
guidata(hObject, handles);
handles.glcm_w=0.01;
guidata(hObject, handles);
% Choose default command line output for Run
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = Run_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_color_Callback(hObject, eventdata, handles)
% hObject    handle to slider_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%颜色的改变
temp_color_w = get( hObject , 'Value' ) ;
set( handles.edit_color , 'String' , num2str(temp_color_w) ) ;
handles.color_w = temp_color_w ;
guidata( hObject , handles ) ;



% --- Executes during object creation, after setting all properties.
function slider_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set ( hObject , 'Value' , 0 ) ;


% --- Executes on slider movement.
function slider_edge_Callback(hObject, eventdata, handles)
% hObject    handle to slider_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
temp_edge_w = get( hObject , 'Value' ) ;
set( handles.edit_edge , 'String' , num2str(temp_edge_w) ) ;
handles.edge_w = temp_edge_w ;
guidata( hObject , handles ) ;


% --- Executes during object creation, after setting all properties.
function slider_edge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set( hObject , 'Value' , 0 ) ;


% --- Executes on slider movement.
function slider_texture_Callback(hObject, eventdata, handles)
% hObject    handle to slider_texture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
temp_texture_w = get( hObject , 'Value' ) ;
set( handles.edit_texture , 'String' , num2str(temp_texture_w) ) ;
handles.texture_w = temp_texture_w ;
guidata( hObject , handles ) ;

% --- Executes during object creation, after setting all properties.
function slider_texture_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_texture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set( hObject , 'Value' , 0 ) ;



function edit_color_Callback(hObject, eventdata, handles)
% hObject    handle to edit_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_color as text
%        str2double(get(hObject,'String')) returns contents of edit_color as a double
value = str2double( get( hObject , 'String' ) ) ;
if isnan(value)
    msgbox('请输入0-1的数字!');
    set( hObject , 'String' , '0' );
    set( handles.slider_color , 'Value' , 0 );
elseif value<0 | value >1
    msgbox('请输入0-1的数字!');
    set( hObject , 'String' , '0' );
    set( handles.slider_color , 'Value' , value );
else
    set( handles.slider_color , 'Value' , 0 );
    handles.color_w = value ;
    guidata( hObject , handles ) ;
end



% --- Executes during object creation, after setting all properties.
function edit_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on slider movement.
function slider_GLCM_Callback(hObject, eventdata, handles)
% hObject    handle to slider_GLCM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%GLCM的改变
temp_GLCM_w = get( hObject , 'Value' ) ;
set( handles.edit_GLCM , 'String' , num2str(temp_GLCM_w) ) ;
handles.glcm_w = temp_GLCM_w ;
guidata( hObject , handles ) ;

% --- Executes during object creation, after setting all properties.
function slider_GLCM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_GLCM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set ( hObject , 'Value' , 0 ) ;



function edit_GLCM_Callback(hObject, eventdata, handles)
% hObject    handle to edit_GLCM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_GLCM as text
%        str2double(get(hObject,'String')) returns contents of edit_GLCM as a double
value = str2double( get( hObject , 'String' ) ) ;
if isnan(value)
    msgbox('请输入0-1的数字!');
    set( hObject , 'String' , '0' );
    set( handles.slider_GLCM , 'Value' , 0 );
elseif value<0 | value >1
    msgbox('请输入0-1的数字!');
    set( hObject , 'String' , '0' );
    set( handles.slider_GLCM , 'Value' , value );
else
    set( handles.slider_GLCM , 'Value' , 0 );
    handles.glcm_w = value ;
    guidata( hObject , handles ) ;
end

% --- Executes during object creation, after setting all properties.
function edit_GLCM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_GLCM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_edge_Callback(hObject, eventdata, handles)
% hObject    handle to edit_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_edge as text
%        str2double(get(hObject,'String')) returns contents of edit_edge as a double
value = str2double( get( hObject , 'String' ) ) ;
if isnan(value)
    msgbox('请输入0-1的数字!');
    set( hObject , 'String' , '0' );
    set( handles.slider_edge , 'Value' , 0 );
elseif value<0 | value >1
    msgbox('请输入0-1的数字!');
    set( hObject , 'String' , '0' );
    set( handles.slider_edge , 'Value' , 0 );
else
    set( handles.slider_edge , 'Value' , value );
    handles.edge_w = value ;
    guidata( hObject , handles ) ;
end


% --- Executes during object creation, after setting all properties.
function edit_edge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_texture_Callback(hObject, eventdata, handles)
% hObject    handle to edit_texture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_texture as text
%        str2double(get(hObject,'String')) returns contents of edit_texture as a double
value = str2double( get( hObject , 'String' ) ) ;
if isnan(value)
    msgbox('请输入0-1的数字!');
    set( hObject , 'String' , '0' );
    set( handles.slider_texture , 'Value' , 0 );
elseif value<0 | value >1
    msgbox('请输入0-1的数字!');
    set( hObject , 'String' , '0' );
    set( handles.slider_texture , 'Value' , 0 );
else
    set( handles.slider_texture , 'Value' , value );
    handles.texture_w = value ;
    guidata( hObject , handles ) ;
end



% --- Executes during object creation, after setting all properties.
function edit_texture_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_texture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,pathname]=uigetfile({'*.jpg';},'目标对象');%读取图片
str=[pathname filename ];
im=imread(str);
axes(handles.axes1);
imshow(im)
handles.str = str ;
guidata( hObject , handles ) ;


% --- Executes on button press in pushbutton_Start.
function pushbutton_Start_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

file_path = get( handles.edit_file_path , 'String' ) ;

% 选择待匹配图像To_be_matched ;
To_be_matched = handles.str ;
jj=handles.num+1;
File_store{jj}= imread(To_be_matched);
if To_be_matched == 0
    msgbox('您还没选找什么类型的对象(>▽<)哦! 点击 想找的对象 ←~( ﹁ ﹁ )！');
else
    T = 0 ;
    hwait  = waitbar(0,'正在找寻合适的对象。。。(￣_,￣ )');
    waitbar( T/50 ,  hwait  ) 
    %待检索的图像的HSV提取
    HSV_f_match_1 = zeros( 1 , 3 ) ;
    HSV_f_match_2 = zeros( 1 , 3 ) ;
    HSV_f_match_3 = zeros( 1 , 3 ) ;
    [ HSV_f_match_1(1,:) , HSV_f_match_2(1,:) , HSV_f_match_3(1,:) ] = hsvfeature( File_store{jj} ) ;
   
    % 度量颜色矩相似度，可以调节的；
    w_1 = 0.4 ;
    w_2 = 0.3 ;
    w_3 = 0.3 ;
    HSV_f_distance = zeros( 1,handles.num ) ;
    for i = 1:handles.num
        HSV_f_distance_1 = sum( abs( handles.HSV_f_store_1( i,: ) - HSV_f_match_1( 1 ,: ) ) );
        HSV_f_distance_2 = sum( abs( handles.HSV_f_store_2( i,: ) - HSV_f_match_2( 1 ,: ) ) );
        HSV_f_distance_3 = sum( abs( handles.HSV_f_store_3( i,: ) - HSV_f_match_3( 1,: ) ) );
        HSV_f_distance(i) = w_1 * HSV_f_distance_1 + w_2 * HSV_f_distance_2 + w_3 * HSV_f_distance_3 ;
        T = i/2+12 ;
        waitbar( T/50 ,  hwait  )
    end
    HSV_f_distance = HSV_f_distance / max( HSV_f_distance ) ; % 对特征距离进行最大值归一化；
    
    %待检索的图像的形状特征提取
    Hu_f_match( 1,: ) = Shape_7_moment ( File_store{jj} ) ; 
    Hu_f_distance = zeros( 1,handles.num ) ;
    for i = 1:handles.num
        Hu_f_distance(i) = sum( abs( handles.Hu_f_store( i,: ) - Hu_f_match( 1,: )));
        T = i/2+36 ;
        waitbar( T/50 , hwait )
    end
    Hu_f_distance = Hu_f_distance / max( Hu_f_distance ) ; %图像不变矩距离进行最大值归一化；
    %待检索的图像的纹理提取
    F_h2 = zeros(1,241 ) ;  %取256点傅氏变换的后241个点，去掉低频分量；
    F_h2(1,:) = Fourier_texture2 ( File_store{jj} ) ; 
    T = i+48 ;
    waitbar( T/50 , hwait )
    
    Fourier_distance = zeros(1,handles.num) ;
    for i = 1:handles.num
        Fourier_distance(i) = sum( abs( handles.F_h( i,: ) - F_h2( 1 ,: )));
    end
   
    Fourier_distance = Fourier_distance / max( Fourier_distance ) ;
%共生矩阵特征提取
    TT= GLCM(To_be_matched);
%     GLCM_f_distance=zeros(handles.num+1);
    for i = 1:handles.num
        GLCM_f_distance_1 = sum( abs( handles.T(i).C - TT.C ));
        GLCM_f_distance_2 = sum( abs( handles.T(i).D - TT.D ));
        GLCM_f_distance_3 = sum( abs( handles.T(i).E - TT.E ));
        GLCM_f_distance_4 = sum( abs( handles.T(i).H - TT.H ));
        GLCM_f_distance_5 = sum( abs( handles.T(i).I - TT.I ));
        GLCM_f_distance_6 = sum( abs( handles.T(i).O - TT.O ));
%         GLCM_f_distance_1 = sum( abs( handles.TT(1,i) - handles.TT(1,:,jj) ));
%         GLCM_f_distance_2 = sum( abs( handles.TT(2,i) - handles.TT(2,:,jj) ));
%         GLCM_f_distance_3 = sum( abs( handles.TT(3,i) - handles.TT(3,:,jj) ));
%         GLCM_f_distance_4 = sum( abs( handles.TT(4,:,i) - handles.TT(4,:,jj) ));
%         GLCM_f_distance_5 = sum( abs( handles.TT(5,:,i) - handles.TT(5,:,jj) ));
%         GLCM_f_distance_6 = sum( abs( handles.TT(6,:,i) - handles.TT(6,:,jj) ));        
        GLCM_f_distance(i) = GLCM_f_distance_1+ GLCM_f_distance_2+ ...
                             GLCM_f_distance_3+ GLCM_f_distance_4+ ...
                             GLCM_f_distance_5+ GLCM_f_distance_6 ;
                   
    end
    GLCM_f_distance = GLCM_f_distance/max(GLCM_f_distance);
    %用户可改变权重
    color_w = handles.color_w + 0.01 ;
    edge_w = handles.edge_w + 0.01 ;
    texture_w = handles.texture_w + 0.01 ;
    GLCM_w = handles.glcm_w + 0.01 ;
    color_w = color_w / ( color_w + edge_w + texture_w + GLCM_w ) ;
    edge_w = edge_w / ( color_w + edge_w + texture_w + GLCM_w) ;
    texture_w = texture_w / ( color_w + edge_w + texture_w + GLCM_w ) ;
    GLCM_w= GLCM_w/ ( color_w + edge_w + texture_w + GLCM_w ) ;
    Distance = color_w * HSV_f_distance + edge_w* Hu_f_distance + texture_w * Fourier_distance + GLCM_w* GLCM_f_distance;

    
    %排序
     [ Temp , Order ] = sort( Distance ) ;

    axes( handles.axes5 )
    imshow( handles.File_store{ Order(1) } ) ;
    axes( handles.axes6 )
    imshow( handles.File_store{ Order(2) } ) ;
    axes( handles.axes7 )
    imshow( handles.File_store{ Order(3) } ) ;
    axes( handles.axes8 )
    imshow( handles.File_store{ Order(4) } ) ;
    axes( handles.axes10 )
    imshow( handles.File_store{ Order(5) } ) ;
    axes( handles.axes11 )
    imshow( handles.File_store{ Order(6) } ) ;
    waitbar( 1 , hwait )
    close(hwait);
    msgbox('找到六个合适的对象↖(^ω^)↗,没有满意的。可以调节类型(⊙o⊙)哦');
end
    
    
% --- Executes when selected object is changed in uipanel2.
function uipanel2_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel2 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

current_Obj = get ( eventdata.NewValue , 'Tag' ) ;
Chose = 1 ;
switch current_Obj
    case 'Show_1'
        Chose = 1 ;
    case 'Show_2'
        Chose = 2 ;
    case 'Show_3'
        Chose = 3 ;
    case 'Show_4'
        Chose = 4 ;
    case 'Show_5'
        Chose = 5 ;
    case 'Show_6'
        Chose = 6 ;
    case 'show_7'
        Chose = 7 ;
end
handles.Chose = Chose ;
guidata( hObject , handles ) ;
    


% --- Executes on button press in Show_c.
function Show_c_Callback(hObject, eventdata, handles)
% hObject    handle to Show_c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%某个特征的显示
To_be_matched = handles.str;
file_path = get( handles.edit_file_path , 'String' ) ;

if To_be_matched == 0
    
    msgbox('您还没选找什么类型的对象(>▽<)哦! 点击 想找的对象 ←~( ﹁ ﹁ )！');
else

    Chose = handles.Chose ;


        file_To_be_matched = imread(To_be_matched);

    temp_1 = rgb2hsv( file_To_be_matched ) ;
    H = temp_1(:,:,1) ;
    S = temp_1(:,:,2) ;
    V = temp_1(:,:,3) ;

    switch Chose
        case 1
            axes( handles.axes9 )
            imhist(H) ;
        case 2
            axes( handles.axes9 )
            imhist(S) ;
        case 3
            axes( handles.axes9 )
            imhist(V) ;
        case 4
            temp_2 = Watershed ( file_To_be_matched ) ;
            axes( handles.axes9 )
            imshow( temp_2 ) ;        
        case 5
            F_h = Fourier_texture2 ( file_To_be_matched ) ;
            axes( handles.axes9 )
            plot( F_h ) ;
          case 7
             GLCM1( file_To_be_matched);
             
    end
end


function edit_file_path_Callback(hObject, eventdata, handles)
% hObject    handle to edit_file_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_file_path as text
%        str2double(get(hObject,'String')) returns contents of edit_file_path as a double
file_path = get( hObject , 'String' ) ;
handles.file_path = file_path ;
guidata( hObject , handles ) ;


% --- Executes during object creation, after setting all properties.
function edit_file_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_file_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set( hObject , 'String' , 'Pic2\' ) ;


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file_path = get( handles.edit_file_path , 'String' ) ;
folder_name =uigetdir(file_path,'dialog_title');
folder_path=[folder_name,'\'];
set( handles.edit_file_path , 'String' , folder_path) ;

% 程序一起动便读取图像，防止检索过慢的现象。
file_path = get( handles.edit_file_path , 'String' ) ;
num = 50 ;%现在只做了50个数据，数据过大的话启动会很慢
handles.num=num;
for i = 1:num
    file_index = [ file_path,num2str(i),'.jpg' ];
    File_store{i} = imread(file_index);
    T(i) = GLCM(file_index);%存入图像(共生矩阵特征提取)
end
handles.File_store=File_store;

% 计算HSV的一、二、三阶颜色矩，共9个量作为颜色特征 ； 
    T = 0 ;
    hwait = waitbar(0,'正在寻找对象=￣ω￣=。。。');
    waitbar( T/100 , hwait  ) 
    HSV_f_store_1 = zeros( num , 3 ) ;
    HSV_f_store_2 = zeros( num , 3 ) ;
    HSV_f_store_3 = zeros( num , 3 ) ;
    for i = 1:num
        % 调用函数hsvfeature 此函数即颜色矩的计算
        [ HSV_f_store_1(i,:) , HSV_f_store_2(i,:) , HSV_f_store_3(i,:) ] = hsvfeature( File_store{i} ) ;
        T = i/2 ;
        waitbar( T/100 , hwait ) 
    end
    handles.HSV_f_store_1=HSV_f_store_1;
    handles.HSV_f_store_2=HSV_f_store_2;
    handles.HSV_f_store_3=HSV_f_store_3;
    
    
    % 计算数据库中每个图像的7个形状不变矩，用作图像的形状特征；
    Hu_f_store = zeros( num,7 ) ;
    for i = 1:num
        Hu_f_store( i,: ) = Shape_7_moment ( File_store{i} ) ;
        T = i/2+25 ;
        waitbar( T/100 ,  hwait  )
    end
    handles.Hu_f_store=Hu_f_store;
        
     %取256点傅氏变换的后241个点，去掉低频分量；
    F_h = zeros( num,241 ) ; %去除低频分量增强图像特征与去噪相反
    for i = 1:num
        F_h(i,:) = Fourier_texture2 ( File_store{i} ) ; 
        T = i+50 ;
        waitbar( T/100 ,  hwait  )
    end
    handles.F_h(i,:)=F_h(i,:);
    waitbar(1, hwait )
    close( hwait ); % 注意必须添加close函数关闭waitbar
