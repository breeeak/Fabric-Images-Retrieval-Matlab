function [ HSV_Mean , HSV_Sig , HSV_3 ] = hsvfeature( X )

RGB = X ;
HSV = rgb2hsv(RGB);%rgb到hsv的转化
H = HSV(:,:,1);%得到h s v的值
S = HSV(:,:,2);
V = HSV(:,:,3);
%HSV空间低阶矩特征(均值/方差和三阶矩)提取

%求H,S,V的均值,并存放在HSV_Mean中.

[m,n] = size(H) ;%数组大小
h_mean = mean2( H ) ;%mean2函数求均值
s_mean = mean2( S ) ;
v_mean = mean2( V ) ;
HSV_Mean = [ h_mean , s_mean , v_mean ] ;


%std2函数求标准差值
h_sig = std2( H )^2 ;
s_sig = std2( S )^2 ;
v_sig = std2( V )^2 ;
HSV_Sig = [ h_sig , s_sig , v_sig ] ;

%求方差和三阶矩

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


