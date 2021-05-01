%% Load a simple image
I = imread('textured_test.png');
I = double(I);

% Snake
radius = 170;
centre = [210 210];
n_points = 200;

% Get image patches
patch_size = 11;
[patches, idx_patches] = get_image_patches(I, patch_size);

% Cluster image patches
n_clusters = 100;
[idx, centroids] = kmeans(patches, n_clusters);
figure, display_dictionary(centroids, [10, 10]); drawnow

% Get the Assignment image
A = zeros(size(I));
A(idx_patches) = idx;
figure, imagesc(A); axis image
drawnow
% imhist(uint8(A))

B = get_biadjency_matrix_patch(patches, idx, A, 0:255, n_clusters);
%%
snake = make_circular_snake(centre, radius, n_points);

imagesc(I), axis image, colormap gray
hold on
plot(snake([1:end,1],2), snake([1:end,1], 1), 'b', 'LineWidth', 2), drawnow;

% Start the method:
% Regularization
alpha = 1;
beta = 1;
step_size = 50;
n_iter = 200;
B_int = regularization_matrix(n_points, alpha, beta);

[X,Y] = meshgrid(1:size(I,2),1:size(I,1));
P_in = zeros(size(I,1), size(I,2), n_iter);
P_out = zeros(size(I,1), size(I,2), n_iter);

for i = 1:n_iter
   % Compute external forces
   [force, P_in(:,:,i), P_out(:,:,i)] = external_forces_patch(snake,B,I,X,Y);
   
   % Get the normals and plot
   N = snake_normals(snake);
   plot_normals(snake, step_size*force.*N), title(i);
%    imagesc(P_in(:,:,i)), axis image; colorbar
   drawnow;
   
   % Apply the deformation
   snake = B_int*(snake+step_size*force.*N);
   snake = distribute_points(remove_intersections(snake));
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