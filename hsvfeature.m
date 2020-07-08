function [ HSV_Mean , HSV_Sig , HSV_3 ] = hsvfeature( X )

RGB = X ;
HSV = rgb2hsv(RGB);%rgb��hsv��ת��
H = HSV(:,:,1);%�õ�h s v��ֵ
S = HSV(:,:,2);
V = HSV(:,:,3);
%HSV�ռ�ͽ׾�����(��ֵ/��������׾�)��ȡ

%��H,S,V�ľ�ֵ,�������HSV_Mean��.

[m,n] = size(H) ;%�����С
h_mean = mean2( H ) ;%mean2�������ֵ
s_mean = mean2( S ) ;
v_mean = mean2( V ) ;
HSV_Mean = [ h_mean , s_mean , v_mean ] ;


%std2�������׼��ֵ
h_sig = std2( H )^2 ;
s_sig = std2( S )^2 ;
v_sig = std2( V )^2 ;
HSV_Sig = [ h_sig , s_sig , v_sig ] ;

%�󷽲�����׾�

h_3_temp = 0 ;
s_3_temp = 0 ;
v_3_temp = 0 ;
for i=1:m
    for j=1:n
        h_3_temp = h_3_temp + (H(i,j)-h_mean)^3 ;
        s_3_temp = s_3_temp + (S(i,j)-s_mean)^3 ;
        v_3_temp = v_3_temp + (V(i,j)-v_mean)^3 ;
    end 
end
h_3 = h_3_temp/(m*n) ;
s_3 = s_3_temp/(m*n) ;
v_3 = v_3_temp/(m*n) ;
HSV_3 = [ h_3 , s_3 , v_3 ] ;

end


