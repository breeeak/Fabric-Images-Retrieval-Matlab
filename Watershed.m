function Edge = Watershed ( X )
%分水岭边界即每一点像素的灰度值表示该点的海拔高度，每一个局部极小值及其影响区域称为集水盆，
%而集水盆的边界则形成分水岭
%由于易受边界的响应故应先对边界进行处理
%同时为了是图像分界明显，多次利用分水岭计算
rgb = X;%读取原图像
I = rgb2gray(rgb);%转化为灰度图像

hy = fspecial('sobel');%sobel算子
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');%滤波求y方向边缘
Ix = imfilter(double(I), hx, 'replicate');%滤波求x方向边缘
gradmag = sqrt(Ix.^2 + Iy.^2);%求模

L = watershed(gradmag);%直接应用分水岭算法
Lrgb = label2rgb(L);%转化为彩色图像

se = strel('disk', 20);%圆形结构元素
Io = imopen(I, se);%形态学开运算

Ie = imerode(I, se);%对图像进行腐蚀
Iobr = imreconstruct(Ie, I);%形态学重建直到标记图像的轮廓适合一个掩模(mask)图像
Ioc = imclose(Io, se);%形态学闭运算

Iobrd = imdilate(Iobr, se);%对图像进行膨胀
Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));%形态学重建
Iobrcbr = imcomplement(Iobrcbr);%图像求反

fgm = imregionalmax(Iobrcbr);%局部极大值

I2 = I;
I2(fgm) = 255;%局部极大值处像素值设为255

se2 = strel(ones(5,5));%结构元素 5x5 1的单位像素
fgm2 = imclose(fgm, se2);%闭运算
fgm3 = imerode(fgm2, se2);%腐蚀
fgm4 = bwareaopen(fgm3, 20);%开操作
I3 = I;
I3(fgm4) = 255;%前景处设置为255

bw = im2bw(Iobrcbr, graythresh(Iobrcbr));%转化为二值图像

D = bwdist(bw);%计算距离  计算二值图中当前像素点与最近的非0像素点的距离,并返回与原二值图同大小的结果矩阵,如果返回值指定为2个,第二返回值是与当前位置最近的非0像素的一维坐标(列优先存储).
DL = watershed(D);%分水岭变换
bgm = DL == 0;%求取分割边界

gradmag2 = imimposemin(gradmag, bgm | fgm4);%置最小值
L = watershed(gradmag2);%分水岭变换
Edge = ~L ;
Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');%转化为伪彩色图像
end


