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
figure(1), imshow(I);

%Deze functie detecteert de randen van de streepjescode
BW = edge(I,'canny');
figure(2), imshow(BW);

%compute Radon transform of edge image
%determines projection angle of image

% De radon tranformatie trekt verschillende lijnen in de afbeelding en meet
% de intensiteit van de lijn (hoeveel keer kom ik een rand tegen). De
% transformatie trekt op elke y-waarde 180 (theta) lijnen. Dit wordt in een
% matrix gezet.
theta = 0:179;
[R,xp] = radon(BW,theta);
figure(3),imagesc(theta, xp, R); colormap(hot)


%zoekt de hoogste waarden in de radon transformatie (het x-coördinaat 
%daarvan komt overeen met de hoek die nodig is om de code recht te 
%draaien) en geeft de coördinaten daarvan terug
[r,c] = find(R == max(R(:)));
thetap = theta(c(1)) ;           
xpp = xp(r(1));
flag=0;
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

figure(4), imshow(I2);
