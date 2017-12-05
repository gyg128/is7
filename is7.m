% 007
% A novel image encryption scheme based on
% DNA sequence operations and chaotic systems

close all;clc;

img=imread('baboon.bmp');
%disp(size(img));
imshow(img);
title('The plain image');
figure;
imhist(img);
title('The plain image');

initParam=zeros(1,7);
initParam(1)=0.5673;  %u0
initParam(2)=0.3791;  %x0
initParam(3)=0.7438;  %y0
initParam(4)=3.4586;  %r1
initParam(5)=6.1289;  %r2
initParam(6)=0.1357;  %z01
initParam(7)=-0.4895; %z02

[img2, key]=encrypt(img,initParam);
disp(key);

figure;
imshow(img2);
title('The cipher image');
figure;
imhist(img2);
title('The cipher image');

[img3, key3]=decrypt(img2,key,initParam);
disp(key3);

figure;
imshow(img3);
title('The decrypted image');
figure;
imhist(img3);
title('The decrypted image');
