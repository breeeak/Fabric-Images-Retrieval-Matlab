function F_h = Fourier_texture2 ( File_store )
%ͨ�׵�˵�������������ͨ���� �ٸ���Ҷչ������Ϊ����������
    F = zeros( 1 , 256 ) ;%256��0

    BW_store_new = im2bw ( rgb2gray( File_store ) );
    BW_store_new_m = Morphology_modify( BW_store_new ) ;%��Ե�����������㣩
    if sum( sum( BW_store_new_m ) ) > sum( sum( ~BW_store_new_m ) )
        BW_store_new_m = ~BW_store_new_m ;%��
    end
    BW_store_new_f = area_max ( BW_store_new_m ) ;
    BW_store_Contour= Contour_Track ( BW_store_new_f ) ;%ֻҪ��Ե
    
    [ x,y ] = find( BW_store_Contour ) ;%���ؾ����з���Ԫ�ص��к��е�����ֵ
    z = x + y*1j ;
    F = abs( fft( z , 256 ) ) ;%���ٸ���Ҷ�任

    F_h = F( 15:255 ) ;%ȥ��ǰ15����
end
