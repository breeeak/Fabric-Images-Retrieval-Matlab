function Image_bw_f = Morphology_modify( Image_bw )

     W = Image_bw;
    
     se = strel('disk',2);%�������͸�ʴ�ṹԪ��
%      0     0     1     0     0
%      0     1     1     1     0
%      1     1     1     1     1
%      0     1     1     1     0
%      0     0     1     0     0
     W = imopen(W , se);%������ �ȸ�ʴ������
     W = imclose(W , se);%������

     Image_bw_f = W ;
end 