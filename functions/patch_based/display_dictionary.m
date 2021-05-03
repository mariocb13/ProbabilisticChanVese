function display_dictionary(centroids, output_size, rgb)
%DISPLAY_DICTIONARY Make a figure which display the obtained centroids as
%   patches after k-means clustering
%   Input:
%       centroids: Centroids as a matrix: N_centroids x N_pixels
%       output_size: Row/Column distribution of the patches in the output 
%                    image. The number of centroids should fit in the output size
%       RGB: boolean. If true, centroids are interpreted as an RGB image

output = [];
if rgb
    centroids = reshape(centroids, size(centroids,1), sqrt(size(centroids,2)/3), ...
        sqrt(size(centroids,2)/3), 3);
else
    centroids = reshape(centroids, size(centroids,1), sqrt(size(centroids,2)), ...
        sqrt(size(centroids,2)));
end

counter = 1;
for i=1:output_size(1)
    temp = [];
    for j = 1:output_size(2) % Make a row of the image
        if rgb
            temp = cat(1, temp, squeeze(centroids(counter,:,:,:)));
        else
            temp = cat(1, temp, squeeze(centroids(counter,:,:)));
        end
        counter = counter +1;
    end
    output = cat(2, temp, output); % Concat the new row
end
imagesc(uint8(output)), colormap gray

hold on
for i = 1:size(centroids,2)
    yline(i*size(centroids,2)+0.5,'b');
end

for i = 1:size(centroids,3)
    xline(i*size(centroids,3)+0.5,'b');
end

end