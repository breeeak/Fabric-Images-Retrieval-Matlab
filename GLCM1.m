
function T = GLCM1(Gray)
[M,N,O] = size(Gray);
ASM=zeros(M,N);
ENT=zeros(M,N);
CON=zeros(M,N);
COR=zeros(M,N);
HOM=zeros(M,N);
DIS=zeros(M,N);

%将各颜色分量转化为灰度

Gray2 = rgb2gray(Gray);

%为了减少计算量，对原始图像灰度级压缩，将Gray量化成16级

for i = 1:M
    for j = 1:N
        for n = 1:16
            if (n-1)*16<=Gray2(i,j)&Gray2(i,j)<=(n-1)*16+15
                Gray2(i,j) = n-1;
            end
        end
    end
end

%在动态窗口下计算四个共生矩阵P,取距离为1，角度分别为0,45,90,135

%定义在图像边缘（前和后）所加的矩形大小都为[width,width]
%所以整个移动窗口window的宽度为2*width+1
width = 3;
f=padarray(Gray2,[width width],'replicate');
for i=1+width:M+width
    for j=1+width:N+width
        W=f(i-width:i+width,j-width:j+width);

        P = zeros(16,16,4);

                for p = 1:2*width+1
                    for q = 1:2*width+1
                         t1=W(p,q);
                         if q<2*width+1
                              t2=W(p,q+1);
                              P(t1+1,t2+1,1) = P(t1+1,t2+1,1)+1;
                              P(t2+1,t1+1,1) = P(t1+1,t2+1,1);
                         end
                         if p>1&q<2*width+1
                              t3=W(p-1,q+1);
                              P(t1+1,t3+1,2) = P(t1+1,t3+1,2)+1;
                              P(t3+1,t1+1,2) = P(t1+1,t3+1,2);
                         end
                          if p<2*width+1
                              t4=W(p+1,q);
                              P(t1+1,t4+1,3)=P(t1+1,t4+1,3)+1;
                              P(t4+1,t1+1,3)=P(t1+1,t4+1,3);
                          end
                          if p<2*width+1&q<2*width+1
                              t5=W(p+1,q+1);
                              P(t1+1,t5+1,4)=P(t1+1,t5+1,4)+1;
                              P(t5+1,t1+1,4)=P(t1+1,t5+1,4);
                          end
                    end
                end
            for m = 1:16
                for n = 1:16
                    if m==n
                         P(m,n,:) = P(m,n,:)*2;
                    end
           
                end
            end

% 对共生矩阵归一化

       for n = 1:4
          P(:,:,n) = P(:,:,n)/sum(sum(P(:,:,n)));
       end  
        H = zeros(1,4);
        I = H;  Ux = H; Uy = H;
        deltaX = H;  deltaY = H;  C = H; D = H; O = H;
        
%对共生矩阵计算能量、熵、惯性矩、相关4个纹理参数

       for n = 1:4
           E(n) = sum(sum(P(:,:,n).^2)); %%能量ASM
          for  p = 1:16
             for  q = 1:16
                 if P(p,q,n)~=0
                    H(n) = -P(p,q,n)*log(P(p,q,n))+H(n); %%熵ENT
                 end
                    I(n) = (p-q)^2*P(p,q,n)+I(n);  %%惯性矩CON
          
                    Ux(n) = p*P(p,q,n)+Ux(n); %相关性中μx
                    Uy(n) = q*P(p,q,n)+Uy(n); %相关性中μy
                    
                    O(n) = P(p,q,n)/(1+(p-q)^2)+O(n);%HOM
                    D(n) = (abs(p-q))*P(p,q,n)+D(n);%DIS
             end
          end
       end
       
       for n = 1:4
           for p = 1:16
              for q = 1:16
                   deltaX(n) = (p-Ux(n))^2*P(p,q,n)+deltaX(n); %相关性中σx
                   deltaY(n) = (q-Uy(n))^2*P(p,q,n)+deltaY(n); %相关性中σy
                   C(n) = p*q*P(p,q,n)+C(n);            
              end
           end
          C(n) = (C(n)-Ux(n)*Uy(n))/deltaX(n)/deltaY(n); %相关性COR  
       end
      


%求能量ASM、熵ENT、惯性矩CON、同质性HOM、异质性DIS、相关性COR的均值作为维纹理特征

      
      
              ASM(i-width,j-width) = mean(E);  
             % b1 = sqrt(cov(E));

              ENT(i-width,j-width) = mean(H);
             % b2 = sqrt(cov(H));

              CON(i-width,j-width) = mean(I); 
             % b3 = sqrt(cov(I));

              COR(i-width,j-width) = mean(C);
             % b4 = sqrt(cov(C));
        
              HOM(i-width,j-width)=mean(O);
              DIS(i-width,j-width)=mean(D);
   end
end  
%将所有在[a,b]范围内的值都划归到[0,255]之间再显示                                                                                                   
    a1 = min(min(ASM));b1 = max(max(ASM));
    ASM2 = uint8((ASM(:,:)-a1)/(b1-a1)*255);
    a2 = min(min(ENT));b2 = max(max(ENT));
    ENT2 = uint8((ENT(:,:)-a2)/(b2-a2)*255);
    a3 = min(min(CON));b3 = max(max(CON));
    CON2 = uint8((CON(:,:)-a3)/(b3-a3)*255);
    a4 = min(min(HOM));b4 = max(max(HOM));
    HOM2 = uint8((HOM(:,:)-a4)/(b4-a4)*255);
    a5 = min(min(COR));b5 = max(max(COR));
    COR2 = uint8((COR(:,:)-a1)/(b1-a1)*255);
    A6 = min(min(DIS));b1 = max(max(DIS));
    DIS2 = uint8((DIS(:,:)-a1)/(b1-a1)*255);
figure;
subplot(2,3,1);
imshow(ASM2);
title('ASM');
subplot(2,3,2);
imshow(ENT2);
title('ENT')
subplot(2,3,3);
imshow(HOM2);
title('HOM')
subplot(2,3,4);
imshow(CON2);
title('CON')
subplot(2,3,5);
imshow(COR2);
title('COR')
subplot(2,3,6);
imshow(DIS2);
title('DIS')


