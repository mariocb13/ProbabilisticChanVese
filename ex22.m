%% Load a real image (Starfish)
clear, clc

I = imread('12003.jpg');
I_selected = I(:,:,1)-0.2*I(:,:,2);
I_selected = double(I_selected);

% Snake
radius = 75;
centre = round([size(I,2),size(I,1)]./2);
n_points = 350;

% Get image patches
patch_size = 21;
[patches, idx_patches] = get_image_patches(I_selected, patch_size);

% Cluster image patches
n_clusters = 169;
[idx, centroids] = kmeans(patches, n_clusters);
figure, display_dictionary(centroids, [13, 13], 0); drawnow

% Get the Assignment image
A = zeros(size(I_selected));
A(idx_patches) = idx;
figure, imagesc(A); axis image
drawnow

B = get_biadjency_matrix_patch(patches, idx, A, 0:255, n_clusters);


%% Start the method:

% Regularization
alpha = 1.75;
beta = 1;
step_size = 5;
n_iter = 200;
B_int = regularization_matrix(n_points, alpha, beta);

[X,Y] = meshgrid(1:size(I,2),1:size(I,1));
P_in = zeros(size(I,1), size(I,2), n_iter);
P_out = zeros(size(I,1), size(I,2), n_iter);

snake = make_circular_snake(centre, radius, n_points);

figure
imagesc(I_selected), axis image, colormap gray
hold on
plot(snake([1:end,1],2), snake([1:end,1], 1), 'b', 'LineWidth', 2), drawnow;
for i = 1:n_iter
   % Compute external forces
   [force, P_in(:,:,i), P_out(:,:,i)] = external_forces_patch(snake,B,I_selected,X,Y);
   
   % Get the normals and plot
   N = snake_normals(snake);
%    if mod(i,10) == 0
       plot_normals(snake, step_size*force.*N), title(i);
       drawnow;
%    end
   
   % Apply the deformation
   snake = B_int*(snake+step_size*force.*N);
   snake = keep_snake_inside(distribute_points(remove_intersections(snake)),size(I_selected));
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