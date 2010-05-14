I = imread('test2.jpg');
%turn image
[I2,flag] = anglex(I);
%read image
[binaryCode, new_bar, flag]= readimage(I2);
%convert 
decimalCode = decodeEan(binaryCode);
display(decimalCode);
