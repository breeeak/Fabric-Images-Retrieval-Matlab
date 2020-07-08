function F_h = Fourier_texture2 ( File_store )
%通俗的说就是先找最大联通区域 再傅里叶展开，作为特征的描述
    F = zeros( 1 , 256 ) ;%256个0

    BW_store_new = im2bw ( rgb2gray( File_store ) );
    BW_store_new_m = Morphology_modify( BW_store_new ) ;%边缘处理（开闭运算）
    if sum( sum( BW_store_new_m ) ) > sum( sum( ~BW_store_new_m ) )
        BW_store_new_m = ~BW_store_new_m ;%否
    end
    BW_store_new_f = area_max ( BW_store_new_m ) ;
    BW_store_Contour= Contour_Track ( BW_store_new_f ) ;%只要边缘
    
    [ x,y ] = find( BW_store_Contour ) ;%返回矩阵中非零元素的行和列的索引值
    z = x + y*1j ;
    F = abs( fft( z , 256 ) ) ;%快速傅里叶变换

    F_h = F( 15:255 ) ;%去掉前15个点
end
