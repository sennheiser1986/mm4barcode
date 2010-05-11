I = imread('22.jpg');
%turn image
[I2,flag] = anglex(I);
%read image
[ans, new_bar, flag]= readimage(I2);
%convert 
ans2= convert_to_dec(ans);
ans2
