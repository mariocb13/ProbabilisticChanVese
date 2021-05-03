%% Some plots for the poster
clear, clc
close all

%% Synthetic image examples
% ex11 % Execute ex11 and get a mask
% mask = P_in(:,:,end) > 0.9;
% imwrite(mask, 'mask.png');


I_simple = imread('simple_test.png');
mask = imread('mask.png');
figure
my_histogram(I_simple, mask);

I_simple = imread('textured_test.png');
mask = imread('mask.png');
figure
my_histogram(I_simple, mask);