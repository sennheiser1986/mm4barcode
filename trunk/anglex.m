% This function rotates the image if the bar code is 
% theta degres angle, 
% returns the rotates image(array) and and flag to be use to 
% to inform user weather the original image rotates
% Use [rotateI,flag]= anglex(I)

function [I2,flag] = anglex(I)

% clear all;close all;
I = imread('test.jpg');

% input image and convert to type double for rotation
%De afbeelding naar zwartwit waarden omzetten

I = double(im2bw(I));
%figure(1), imshow(I);

%Deze functie detecteert de randen van de streepjescode
BW = edge(I,'canny');
%figure(2), imshow(BW);

%compute Radon transform of edge image
%determines projection angle of image

% De radon tranformatie trekt verschillende lijnen in de afbeelding en meet
% de intensiteit van de lijn (hoeveel keer kom ik een rand tegen). De
% transformatie trekt op elke y-waarde 180 (theta) lijnen. Dit wordt in een
% matrix gezet.
theta = 0:179;
[R,xp] = radon(BW,theta);
%figure(3),imagesc(theta, xp, R); colormap(hot)


%zoekt de hoogste waarden in de radon transformatie (het x-coördinaat 
%daarvan komt overeen met de hoek die nodig is om de code recht te 
%draaien) en geeft de coördinaten daarvan terug
[r,c] = find(R == max(R(:)));
thetap = theta(c(1)) ;           
xpp = xp(r(1));
flag=0;
%maak de afbeelding negatief, anders zitten we bij rotate met zwarte randen
I=1-I;
if (thetap ~= 0)
   flag=1;
   %rotate image at angle found from Radon transform
   %Aan de hand van de waarden van xpp en thetap wordt de streepjescode
   %correct gedraait.
   if (thetap==90 && xpp ~=-90)
       I2=I;
   elseif(xpp==0 && thetap>60)
       I2=I;
   elseif (xpp>=0 && thetap >=45)
       I2 = imrotate(I,-thetap,'bilinear', 'crop');
   elseif (thetap>90 && xpp< 0)
       I2=imrotate(I,thetap-90,'bilinear');
   elseif (xpp < 0 && thetap >= 45)
       I2=imrotate(I,90-thetap,'bilinear', 'crop');
   elseif ((xpp <= -1 && xpp >= -50) && thetap >45)
       I2 = imrotate(I,thetap-90,'bilinear');
   elseif (xpp >= 0 && thetap < 45)
       I2 = imrotate(I, -thetap, 'bilinear');
   elseif (xpp < 0 && thetap < 45) 
       I2 = imrotate(I,-thetap,'bilinear');
   end

elseif (thetap==0 && xpp <=-45 && xpp>=-60)
   flag=1;
   I2 = imrotate(I, 90, 'bilinear');
else
   flag=0;
   I2=I;
end
%maak de afbeelding terug negatief (dus terug naar het origineel)
I2=1-I2;

figure(4), imshow(I2);
%imwrite(I2,'test2.jpg','jpg');
readimage(I2);


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
bc2;
%Output
ans=bc2;
if bc2==1
   flag=1;
else
   flag=0;
end

figure();imshow (new_bar); imshow(bc2);




