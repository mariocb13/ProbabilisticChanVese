function plot_normals(snake, N)
%PLOT_NORMALS Function to plot the direction of the normals of the snake
% points

   delete(findobj('type','Line','-or','type','Quiver'))
   hold on
   quiver(snake(1:end,2), snake(1:end,1), N(:,2), N(:,1), 'b', 'LineWidth', 2);
   plot(snake([1:end, 1],2), snake([1:end, 1],1), 'b'), drawnow;
end

