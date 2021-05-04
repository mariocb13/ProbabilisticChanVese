addpath('Figures');

initial_snake = load('initialization.mat').snake;
hist_based_snake = load('ex13.mat').snake;
patches_snake = load('textured_patches.mat').snake;
I = load('initialization.mat').I;

clf
subplot(1,3,1)
imagesc(I), axis image, colormap gray
hold on
plot(initial_snake([1:end,1],2), initial_snake([1:end,1],1), 'b', 'LineWidth', 2), drawnow;
title('Snake initialization')
subplot(1,3,2)
imagesc(I), axis image, colormap gray
hold on
plot(hist_based_snake([1:end,1],2), hist_based_snake([1:end,1],1), 'b', 'LineWidth', 2), drawnow;
title('Histogram-based approach')
subplot(1,3,3)
imagesc(I), axis image, colormap gray
hold on
plot(patches_snake([1:end,1],2), patches_snake([1:end,1],1), 'b', 'LineWidth', 2), drawnow;
title('Patches-based approach')