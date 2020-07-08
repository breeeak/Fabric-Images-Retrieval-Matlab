
function T = GLCM1(Gray)
[M,N,O] = size(Gray);
ASM=zeros(M,N);
ENT=zeros(M,N);
CON=zeros(M,N);
COR=zeros(M,N);
HOM=zeros(M,N);
DIS=zeros(M,N);

%������ɫ����ת��Ϊ�Ҷ�

Gray2 = rgb2gray(Gray);

%Ϊ�˼��ټ���������ԭʼͼ��Ҷȼ�ѹ������Gray������16��

for i = 1:M
    for j = 1:N
        for n = 1:16
            if (n-1)*16<=Gray2(i,j)&Gray2(i,j)<=(n-1)*16+15
                Gray2(i,j) = n-1;
            end
        end
    end
end

%�ڶ�̬�����¼����ĸ���������P,ȡ����Ϊ1���Ƕȷֱ�Ϊ0,45,90,135

%������ͼ���Ե��ǰ�ͺ����ӵľ��δ�С��Ϊ[width,width]
%���������ƶ�����window�Ŀ��Ϊ2*width+1
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

% �Թ��������һ��

       for n = 1:4
          P(:,:,n) = P(:,:,n)/sum(sum(P(:,:,n)));
       end  
        H = zeros(1,4);
        I = H;  Ux = H; Uy = H;
        deltaX = H;  deltaY = H;  C = H; D = H; O = H;
        
%�Թ�����������������ء����Ծء����4���������

       for n = 1:4
           E(n) = sum(sum(P(:,:,n).^2)); %%����ASM
          for  p = 1:16
             for  q = 1:16
                 if P(p,q,n)~=0
                    H(n) = -P(p,q,n)*log(P(p,q,n))+H(n); %%��ENT
                 end
                    I(n) = (p-q)^2*P(p,q,n)+I(n);  %%���Ծ�CON
          
                    Ux(n) = p*P(p,q,n)+Ux(n); %������Ц�x
                    Uy(n) = q*P(p,q,n)+Uy(n); %������Ц�y
                    
                    O(n) = P(p,q,n)/(1+(p-q)^2)+O(n);%HOM
                    D(n) = (abs(p-q))*P(p,q,n)+D(n);%DIS
             end
          end
       end
       
       for n = 1:4
           for p = 1:16
              for q = 1:16
                   deltaX(n) = (p-Ux(n))^2*P(p,q,n)+deltaX(n); %������Ц�x
                   deltaY(n) = (q-Uy(n))^2*P(p,q,n)+deltaY(n); %������Ц�y
                   C(n) = p*q*P(p,q,n)+C(n);            
              end
           end
          C(n) = (C(n)-Ux(n)*Uy(n))/deltaX(n)/deltaY(n); %�����COR  
       end
      


%������ASM����ENT�����Ծ�CON��ͬ����HOM��������DIS�������COR�ľ�ֵ��Ϊά��������

      
      
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
%��������[a,b]��Χ�ڵ�ֵ�����鵽[0,255]֮������ʾ                                                                                                   
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


