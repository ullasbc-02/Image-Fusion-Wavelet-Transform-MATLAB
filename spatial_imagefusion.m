%% Prepare workspace
clear;
clc;
close all
%% input
im1 = imread('C:\Users\Admin\Documents\MATLAB\Image Fusion\RK sir\Remote sensing dataset\input001_1.tif');
im2 = imread('C:\Users\Admin\Documents\MATLAB\Image Fusion\RK sir\Remote sensing dataset\input001_2.tif');

M=256;
N=256;

im1=imresize(im1,[M,N]);
im2=imresize(im2,[M,N]);

if size(im1,3)==3
    im1 = rgb2gray(im1);
end
if size(im2,3)==3
    im2 = rgb2gray(im2);
end

subplot(221);imshow(im1);title('input 1');
subplot(222);imshow(im2);title('input 2');
%% Pixel level averaging

fusion1= ((double(im1)+double(im2))/(2));

%% Averaging select maximum/minimum method
I1 = max(im1,im2);
I2 = min(im1,im2);
fusion2= ((double(I1)+double(I2))/(2));
%%
subplot(223);imshow(uint8(fusion1));title('fusion 1 : level avg');
subplot(224);imshow(uint8(fusion2));title('fusion 2 : max/min');

%% Structural  Similarity  based  Metric
im1=double(im1);
im2=double(im2);
fusion1=double(fusion1);
fusion2=double(fusion2);

s=ssim(im1,im2);
lambda=0.8;

if s>=0.75
    Qs1=lambda*ssim(im1,fusion1)+(1-lambda)*ssim(im2,fusion1);
    Qs2=lambda*ssim(im1,fusion2)+(1-lambda)*ssim(im2,fusion2);
    
else
   Qs1=max(ssim(im1,fusion1),ssim(im2,fusion1));
   Qs2=max(ssim(im1,fusion2),ssim(im2,fusion2)); 
end

fprintf('Structural  Similarity  based  Metric for averaging :%f\n',Qs1);

fprintf('Structural  Similarity  based  Metric for maximum/minimum :%f\n',Qs2);