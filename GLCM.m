
 function T = GLCM(path)
Gray = imread(path);

[M,N] = size(Gray);
% ASM=zeros(M,N);
% ENT=zeros(M,N);
% CON=zeros(M,N);
% COR=zeros(M,N);
% HOM=zeros(M,N);
% DIS=zeros(M,N);

%������ɫ����ת��Ϊ�Ҷ�
Gray = rgb2gray(Gray);

%Ϊ�˼��ټ���������ԭʼͼ��Ҷȼ�ѹ������Gray������16��

Gray=histeq(Gray,16);%��ͼ��ĻҶȼ�����Ϊ16
Gray2=round(Gray/16);

%�����ĸ���������P,ȡ����Ϊ1���Ƕȷֱ�Ϊ0,45,90,135

offsets = [0 1;-1 1;-1 0;-1 -1];
GLCMS = graycomatrix(Gray2,'Numlevels',16,'G',[],'Of',offsets); 

% % �Թ��������һ��
        for n = 1:4
            GLCMS(:,:,n) = GLCMS(:,:,n)/sum(sum(GLCMS(:,:,n)));
        end  
        
        
        H = zeros(1,4);
        I = H;  Ux = H; Uy = H;
        deltaX = H;  deltaY = H;  
         C = H; 
         D = H; 
        O = H;

% �Թ�����������������ء����Ծء����4���������

        for n = 1:4
            E(n) = sum(sum(GLCMS(:,:,n).^2)); %%����ASM
            for  p = 1:16
              for  q = 1:16
                  if GLCMS(p,q,n)~=0
                     H(n) = -GLCMS(p,q,n)*log(GLCMS(p,q,n))+H(n); %%��ENT
                  end
                  I(n) = (p-q)^2*GLCMS(p,q,n)+I(n);  %%���Ծ�CON
           
                  Ux(n) = p*GLCMS(p,q,n)+Ux(n); %������Ц�x
                  Uy(n) = q*GLCMS(p,q,n)+Uy(n); %������Ц�y
                     
                  O(n) = GLCMS(p,q,n)/(1+(p-q)^2)+O(n);%����
                  D(n) = (abs(p-q))*GLCMS(p,q,n)+D(n);%�Աȶ�
              end
           end
       end
        
       for n = 1:4
           for p = 1:16
              for q = 1:16
                   deltaX(n) = (p-Ux(n))^2*GLCMS(p,q,n)+deltaX(n); %������Ц�x
                   deltaY(n) = (q-Uy(n))^2*GLCMS(p,q,n)+deltaY(n); %������Ц�y
                   C(n) = p*q*GLCMS(p,q,n)+C(n);            
              end
           end
          C(n) = (C(n)-Ux(n)*Uy(n))/deltaX(n)/deltaY(n); %�����COR  
       end
 T.E = E;
 T.H = H;
 T.I= I; 
 T.C = C;
 T.O = O;
 T.D = D;
 

