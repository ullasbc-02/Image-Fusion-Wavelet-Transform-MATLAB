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

subplot(131);imshow(im1);title('input 1');
subplot(132);imshow(im2);title('input 2');
%% Pixel level averaging
fusion1= ((double(im1)+double(im2))/(2));
%% dwt
[LL1,LH1,HL1,HH1]=dwt2(im1,'haar');
[LL2,LH2,HL2,HH2]=dwt2(im1,'haar');
% fusion of low frequency components by average method
LL = (LL1+LL2)/2;
% fusion of low frequency components by max rule
LH = max(LH1,LH2);
HL = max(HL1,HL2);
HH = max(HH1,HH2);
% inverse dwt transform
fusion2 = idwt2(LL,LH,HL,HH,'haar');
%% combine
alpha =0.5;
beta = 0.5;

fusion = alpha*fusion1+ beta*fusion2;
subplot(133);imshow(uint8(fusion));title('fusion  : hybrid');
%% Structural  Similarity  based  Metric
im1=double(im1);
im2=double(im2);
fusion=double(fusion);


s=ssim(im1,im2);
lambda=0.5;

if s>=0.75
    Qs=lambda*ssim(im1,fusion)+(1-lambda)*ssim(im2,fusion);
    
else
   Qs=max(ssim(im1,fusion),ssim(im2,fusion));
end

fprintf('Structural  Similarity  based  Metric for hybrid fusion :%f\n',Qs);