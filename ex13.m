%% Load a simple image
I = imread('textured_test.png');
I = double(I);

% Initialize a snake 
radius = 170;
centre = [250 250];
n_points = 240;
snake = make_circular_snake(centre, radius, n_points);

% Method parameters
alpha = 3;
beta = 1;
step_size = 50;
n_iter = 150;

% Plot the snake: The last 1 in the snake indexing it's to show the circle complete
imagesc(I), axis image, colormap gray
hold on
h = plot(snake([1:end,1],2), snake([1:end,1], 1), 'b', 'LineWidth', 2);
drawnow;

% Start the method:
[X,Y] = meshgrid(1:size(I,2),1:size(I,1));
B_int = regularization_matrix(n_points, alpha, beta);
B = get_biadjency_matrix_int(I);

P_in = zeros(size(I,1), size(I,2), n_iter);
P_out = zeros(size(I,1), size(I,2), n_iter);
for i = 1:n_iter
   % Compute external forces
   [force, P_in(:,:,i), P_out(:,:,i)] = external_forces_int(snake,B,I,X,Y);
   
   % Get the normals and plot
   N = snake_normals(snake);
   plot_normals(snake, step_size*force.*N), title(i), drawnow;
   
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
title('P_in image (Start)')
subplot(1,3,3)
imagesc(P_in(:,:,end)), axis image