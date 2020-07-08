function Image_bw_f_2= area_max ( Image_bw_f )
%找出联通最大的区域
W =  Image_bw_f;   
[L,m] = bwlabel(W,8);
%返回一个和W大小相同的L矩阵，包含了标记了W中
%每个连通区域的类别标签，这些标签的值为1、2、num（连通区域的个数）。
%n的值为4或8，表示是按4连通寻找区域，还是8连通寻找，默认为8。
%8连通，是说一个像素，如果和其他像素在上、下、左、右、左上角、左下角、右上角或右下角连接着，则认为他们是联通的
%这里m返回的就是BW中连通区域的个数
stats=regionprops(L,'area');
%area 图像中联通区域像素的总个数
area=[stats.Area];
max_area = max(area);
W = bwareaopen(W,max_area);%删除小面积对象
Image_bw_f_2 = W;

end 