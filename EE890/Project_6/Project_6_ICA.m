clear all;
clc;
x1=imread('Recording-1.png');
x2=imread('Recording-2.png');
x1=double(reshape(x1,1,453600));
x2=double(reshape(x2,1,453600));
N = 453600;

x=[x1;x2];
avg = mean(x,2);
x(1,:) = x(1,:) - avg(1);
x(2,:) = x(2,:) - avg(2);


ce = cov(x'); 
[E D E_T]=svd(ce);
white = E * D^(-1/2) * E';

x_white = white * x;
cm = cov(x_white');

W = fastica(x_white);
s1 = W(:,1)'*x_white;
s2 = W(:,2)'*x_white;

pic1=reshape(s1,567,800);
pic2=reshape(s2,567,800);
subplot(1,2,1);
imshow(pic1);
subplot(1,2,2);
imshow(pic2);