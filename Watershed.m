function Edge = Watershed ( X )
%��ˮ��߽缴ÿһ�����صĻҶ�ֵ��ʾ�õ�ĺ��θ߶ȣ�ÿһ���ֲ���Сֵ����Ӱ�������Ϊ��ˮ�裬
%����ˮ��ı߽����γɷ�ˮ��
%�������ܱ߽����Ӧ��Ӧ�ȶԱ߽���д���
%ͬʱΪ����ͼ��ֽ����ԣ�������÷�ˮ�����
rgb = X;%��ȡԭͼ��
I = rgb2gray(rgb);%ת��Ϊ�Ҷ�ͼ��

hy = fspecial('sobel');%sobel����
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');%�˲���y�����Ե
Ix = imfilter(double(I), hx, 'replicate');%�˲���x�����Ե
gradmag = sqrt(Ix.^2 + Iy.^2);%��ģ

L = watershed(gradmag);%ֱ��Ӧ�÷�ˮ���㷨
Lrgb = label2rgb(L);%ת��Ϊ��ɫͼ��

se = strel('disk', 20);%Բ�νṹԪ��
Io = imopen(I, se);%��̬ѧ������

Ie = imerode(I, se);%��ͼ����и�ʴ
Iobr = imreconstruct(Ie, I);%��̬ѧ�ؽ�ֱ�����ͼ��������ʺ�һ����ģ(mask)ͼ��
Ioc = imclose(Io, se);%��̬ѧ������

Iobrd = imdilate(Iobr, se);%��ͼ���������
Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));%��̬ѧ�ؽ�
Iobrcbr = imcomplement(Iobrcbr);%ͼ����

fgm = imregionalmax(Iobrcbr);%�ֲ�����ֵ

I2 = I;
I2(fgm) = 255;%�ֲ�����ֵ������ֵ��Ϊ255

se2 = strel(ones(5,5));%�ṹԪ�� 5x5 1�ĵ�λ����
fgm2 = imclose(fgm, se2);%������
fgm3 = imerode(fgm2, se2);%��ʴ
fgm4 = bwareaopen(fgm3, 20);%������
I3 = I;
I3(fgm4) = 255;%ǰ��������Ϊ255

bw = im2bw(Iobrcbr, graythresh(Iobrcbr));%ת��Ϊ��ֵͼ��

D = bwdist(bw);%�������  �����ֵͼ�е�ǰ���ص�������ķ�0���ص�ľ���,��������ԭ��ֵͼͬ��С�Ľ������,�������ֵָ��Ϊ2��,�ڶ�����ֵ���뵱ǰλ������ķ�0���ص�һά����(�����ȴ洢).
DL = watershed(D);%��ˮ��任
bgm = DL == 0;%��ȡ�ָ�߽�

gradmag2 = imimposemin(gradmag, bgm | fgm4);%����Сֵ
L = watershed(gradmag2);%��ˮ��任
Edge = ~L ;
Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');%ת��Ϊα��ɫͼ��
end


