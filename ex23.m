%% Load a real image (Starfish)
clear, clc

I = imread('134052.jpg');
I = double(I);

size_im = [size(I,1), size(I,2)];

% Snake
radius = 60;
centre = round([size(I,2),size(I,1)]./2);
n_points = 1200;

% Get image patches
patch_size = 7;

patches = [];
for i = 1:size(I,3)
    [patches_ch, idx_patches] = get_image_patches(I(:,:,i), patch_size);
    patches = cat(2, patches, patches_ch);
end

% Cluster image patches
n_clusters = 200; % To get a correct display, select a perfect square

[idx, centroids] = kmeans(patches, n_clusters);
figure, display_dictionary(centroids, [10, 10], 1); drawnow

% Get the Assignment image
A = zeros(size_im);
A(idx_patches) = idx;
figure, imagesc(A); axis image
drawnow

B = get_biadjency_matrix_patch(patches, idx, A, 0:255, n_clusters);

%% Start the method:
% Regularization
alpha = 2;
beta = 2;
step_size = 20;
n_iter = 500;
B_int = regularization_matrix(n_points, alpha, beta);

[X,Y] = meshgrid(1:size(I,2),1:size(I,1));
P_in = zeros(size(I,1), size(I,2), n_iter);
P_out = zeros(size(I,1), size(I,2), n_iter);

radius = 30;
centre = round([size(I,2)/4,size(I,1)/2+35]);
centre = round([size(I,2),size(I,1)-70]/2);
centre = round([130,180]);
n_points = 1200;
snake = make_circular_snake(centre, radius, n_points);

figure
imagesc(uint8(I)), axis image, colormap gray
hold on
plot(snake([1:end,1],2), snake([1:end,1], 1), 'b', 'LineWidth', 2), drawnow;

for i = 1:n_iter
   % Compute external forces
   [force, P_in(:,:,i), P_out(:,:,i)] = external_forces_patch(snake,B,I,X,Y);
   
   % Get the normals and plot
   N = snake_normals(snake);
   if mod(i,5) == 0
       plot_normals(snake, step_size*force.*N), title(i);
       drawnow;
   end
   
   % Apply the deformation
   snake = B_int*(snake+step_size*force.*N);
   snake = keep_snake_inside(distribute_points(remove_intersections(snake)),size(I));
end

clf
subplot(1,3,1)
imagesc(I), axis image, colormap gray
hold on
plot(snake([1:end,1],2), snake([1:end,1],1), 'b', 'LineWidth', 2), drawnow;
title('Final segmentation')
subplot(1,3,2)
imagesc(P_in(:,:,1)), axis image
title('Probability in image (Start)')
subplot(1,3,3)
imagesc(P_in(:,:,end)), axis image
title('Probability in image (end)')