
% readimage.m
%Recognises barcode from image
%

function [ans, new_bar, flag]= readimage(bar)

%bar = imread ('test2.jpg');
% imshow (bar);

%Convert to 1 dimension array
size_bc = size(bar);
for i=1:size_bc(2)
   bar1(i)=bar(round(size_bc(1)/2), i);
end

%find start and end of barcode
%convert [0,1] to [1,0]
%zet alle waarden die 0 zijn naar 1 en de anderen naar 0
bcn=not(bar1);
%zoek eerste en laatste en geeft de locatie door
indices_1 = find(bcn, 1, 'first');
indices_2 = find(bcn, 1, 'last');
%ccropt de streepjescode
bc=bcn(indices_1:indices_2);        

%crop image from bar code
%new image store in new_bar
bar0n=not(bar);
center=round((find(bar0n(:,indices_1), 1, 'first')+find(bar0n(:,indices_1), 1, 'last'))/2);
width=round(((find(bar0n(:,indices_1), 1, 'last')-find(bar0n(:,indices_1), 1, 'first'))/10)/2);
new_bar=imcrop(bar,[indices_1 center-width indices_2-indices_1 40]);

%Convert array to 95bit length
x=1;
l = length(bc);
%yy = 1:400;
%for y = 1:300,
%   if (mod(y,length(bc)/95)==0)
%       bc2(x)=bc(y);
%       x=x+1;
%   end
%end
bc2 = imresize(new_bar, [1 95], 'nearest');
%Output
ans=round(bc2);
if bc2==1
   flag=1;
else
   flag=0;
end

