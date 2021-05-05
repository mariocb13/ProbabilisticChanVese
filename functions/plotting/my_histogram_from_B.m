function my_histogram_from_B(snake,B,I)
%MY_HISTOGRAM_FROM_B Summary of this function goes here
%   Detailed explanation goes here

   % Get the inner region of the mask
   in = poly2mask(snake(:,2), snake(:,1), size(I,1), size(I,2));
   c_in = in(:); 
   A_in = sum(c_in);
   f_in = B'*c_in / A_in;
   
   % Outer region
   c_out = ~c_in; 
   A_out = sum(c_out);
   f_out = B'*c_out / A_out;
   
      % Element-wise normalized probabilities
   p_in = f_in ./ (f_in+f_out);
   
   % Handle probabilities f_in+f_out = 0
   p_in(isnan(p_in)) = 0.5;
   
   P_in = B*p_in;
   
   % Get the probability images
   P_in = reshape(P_in,[size(I,1), size(I,2)]);
   
   
   %% PLOTS
   
   bins = 0:767;
   
   subplot(1,3,1)
   imagesc(uint8(I)), axis image, colormap gray
   hold on
   plot(snake([1:end,1],2), snake([1:end,1],1), 'b', 'LineWidth', 2);
   
   subplot(1,3,2);
   stem(bins, f_in, 'Color',[153, 0, 0]/255, 'LineWidth',1, 'Marker', 'none');
   hold on
   stem(bins, f_out, 'Color',[47, 62, 234]/255, 'LineWidth',1, 'Marker', 'none');
   axis([-inf inf 0 max(f_out)]);
   xlabel('Intensities');
   ylabel('Normalized frequency');
   legend('Foreground','Background','Location','northoutside','Orientation','horizontal');
   
   subplot(1,3,3);
   imagesc(P_in), axis image, colormap default
   
end

