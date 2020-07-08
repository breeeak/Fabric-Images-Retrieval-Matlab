
 function T = GLCM(path)
Gray = imread(path);

[M,N] = size(Gray);
% ASM=zeros(M,N);
% ENT=zeros(M,N);
% CON=zeros(M,N);
% COR=zeros(M,N);
% HOM=zeros(M,N);
% DIS=zeros(M,N);

%将各颜色分量转化为灰度
Gray = rgb2gray(Gray);

%为了减少计算量，对原始图像灰度级压缩，将Gray量化成16级

Gray=histeq(Gray,16);%将图像的灰度级数改为16
Gray2=round(Gray/16);

%计算四个共生矩阵P,取距离为1，角度分别为0,45,90,135

offsets = [0 1;-1 1;-1 0;-1 -1];
GLCMS = graycomatrix(Gray2,'Numlevels',16,'G',[],'Of',offsets); 

% % 对共生矩阵归一化
        for n = 1:4
            GLCMS(:,:,n) = GLCMS(:,:,n)/sum(sum(GLCMS(:,:,n)));
        end  
        
        
        H = zeros(1,4);
        I = H;  Ux = H; Uy = H;
        deltaX = H;  deltaY = H;  
         C = H; 
         D = H; 
        O = H;

% 对共生矩阵计算能量、熵、惯性矩、相关4个纹理参数

        for n = 1:4
            E(n) = sum(sum(GLCMS(:,:,n).^2)); %%能量ASM
            for  p = 1:16
              for  q = 1:16
                  if GLCMS(p,q,n)~=0
                     H(n) = -GLCMS(p,q,n)*log(GLCMS(p,q,n))+H(n); %%熵ENT
                  end
                  I(n) = (p-q)^2*GLCMS(p,q,n)+I(n);  %%惯性矩CON
           
                  Ux(n) = p*GLCMS(p,q,n)+Ux(n); %相关性中μx
                  Uy(n) = q*GLCMS(p,q,n)+Uy(n); %相关性中μy
                     
                  O(n) = GLCMS(p,q,n)/(1+(p-q)^2)+O(n);%逆差矩
                  D(n) = (abs(p-q))*GLCMS(p,q,n)+D(n);%对比度
              end
           end
       end
        
       for n = 1:4
           for p = 1:16
              for q = 1:16
                   deltaX(n) = (p-Ux(n))^2*GLCMS(p,q,n)+deltaX(n); %相关性中σx
                   deltaY(n) = (q-Uy(n))^2*GLCMS(p,q,n)+deltaY(n); %相关性中σy
                   C(n) = p*q*GLCMS(p,q,n)+C(n);            
              end
           end
          C(n) = (C(n)-Ux(n)*Uy(n))/deltaX(n)/deltaY(n); %相关性COR  
       end
 T.E = E;
 T.H = H;
 T.I= I; 
 T.C = C;
 T.O = O;
 T.D = D;
 

