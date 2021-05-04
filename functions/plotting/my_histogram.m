function my_histogram(I,mask)
%MY_HISTOGRAM 

[counts_in, bins] = imhist(I(mask));
[counts_out, ~] = imhist(I(~mask));

subplot(1,2,1);
stem(bins, counts_in, 'Color',[153, 0, 0]/255, 'LineWidth',1, 'Marker', 'none');
hold on
stem(bins, counts_out, 'Color',[47, 62, 234]/255, 'LineWidth',1, 'Marker', 'none');
axis([-inf inf 0 max(counts_out)+500]);
xlabel('Intensities');
ylabel('Absolute frequency');
legend('Foreground','Background','Location','northoutside','Orientation','horizontal');

subplot(1,2,2);
imagesc(I), axis image, colormap gray
hold on
contour(mask,[1 1],'color',[47, 62, 234]/255, 'LineWidth',1.5,'LineStyle','-');

end

