function Image_bw_f = Morphology_modify( Image_bw )

     W = Image_bw;
    
     se = strel('disk',2);%设置膨胀腐蚀结构元素
%      0     0     1     0     0
%      0     1     1     1     0
%      1     1     1     1     1
%      0     1     1     1     0
%      0     0     1     0     0
     W = imopen(W , se);%开运算 先腐蚀后膨胀
     W = imclose(W , se);%闭运算

     Image_bw_f = W ;
end 