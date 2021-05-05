%% Load a real image
clear, clc

I = imread('124084.jpg');
% I = rgb2gray(I);
I = double(I);

size_im = [size(I,1), size(I,2)];

% Get image patches
patch_size = 7;
patches = []; % Patches for all the pixels
for i = 1:size(I,3)
    [patches_ch, idx_patches] = get_image_patches(I(:,:,i), patch_size);
    patches = cat(2, patches, patches_ch);
end

patches_s = select_patches(patches, idx_patches, size_im, patch_size, 'random', 30000); % Patches from selected pixels

% Dictionary development
n_clusters = 300;
% [~, centroids] = kmeans(patches_s./vecnorm(patches_s,1,2), n_clusters);
[~, centroids] = kmeans(patches_s, n_clusters);
% figure, display_dictionary(centroids, [10, 10], 1); drawnow

% Assign to every pixel a cluster
% [~, idx] = pdist2(centroids, patches./vecnorm(patches,1,2), 'euclidean', 'Smallest', 1);
[~, idx] = pdist2(centroids, patches, 'euclidean', 'Smallest', 1);

% Get the Assignment image
A = zeros(size_im);
A(idx_patches) = idx;
figure, imagesc(A); axis image
drawnow

% Make a difference between the colour channels
for i = 1:size(I,3)
    patches(:,(i-1)*patch_size^2+1:i*patch_size^2) = 256*(i-1)+patches(:,(i-1)*patch_size^2+1:i*patch_size^2);
end
B = get_biadjency_matrix_patch(patches, idx, A, 0:767, n_clusters);

% B = get_biadjency_matrix_patch(patches, idx, A, 0:255, n_clusters);

%% Start the method:
% Regularization
alpha = 2;
beta = 0.005;
step_size = 5;
n_iter = 250;

[X,Y] = meshgrid(1:size(I,2),1:size(I,1));
P_in = zeros(size(I,1), size(I,2), n_iter);
P_out = zeros(size(I,1), size(I,2), n_iter);

figure
imagesc(uint8(I)), axis image

[centrex, centrey] = ginput(1);
radius = 60;
centre = ([centrex,centrey]);
n_points = 600;
% centre = [210,210];
snake = make_circular_snake(centre, radius, n_points);

hold on
plot(snake([1:end,1],2), snake([1:end,1], 1), 'b', 'LineWidth', 2), drawnow;

B_int = regularization_matrix(n_points, alpha, beta);

for i = 1:n_iter
    
%     if ismember(n_iter,[50 100 150 200])
%         step_size = step_size*0.5;
%     end
    
   % Compute external forces
   [force, P_in(:,:,i), P_out(:,:,i)] = external_forces_patch(snake,B,I,X,Y);
   
   % Get the normals and plot
   N = snake_normals(snake);
%    if mod(i,10) == 0
       plot_normals(snake, 0*step_size*force.*N), title(i);
       drawnow;
%    end
   
   % Apply the deformation
   snake = B_int*(snake+step_size*force.*N);
   snake = keep_snake_inside(distribute_points(remove_intersections(snake)),size(I));
end

clf
subplot(1,3,1)
imagesc(uint8(I)), axis image, colormap gray
hold on
plot(snake([1:end,1],2), snake([1:end,1],1), 'b', 'LineWidth', 2), drawnow;
title('Final segmentation')
subplot(1,3,2)
imagesc(P_in(:,:,1)), axis image, colormap default
title('Probability in image (Start)')
subplot(1,3,3)
imagesc(P_in(:,:,end)), axis image, colormap default
title('Probability in image (end)')