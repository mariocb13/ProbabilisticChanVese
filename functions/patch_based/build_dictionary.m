function [dict, centroids] = build_dictionary(features, n_clusters)
%BUILD_DICTIONARY Returns the image dictionary
% Input:
%       features = Features matrix. Row pixel, column features.
%       n_clusters = Number of clusters
% Output:
%       dict = 
%       centroids = 

    % K-means clustering
    [idx, centroids] = kmeans(features, n_clusters);
    dict = cell(n_clusters, 1); % Each position represents the 
    
    for i = 1:n_clusters
        cluster_pix = features(idx == i);
        cluster_classes = classes(idx == i,:);
        for j = 1:n_classes
            dict(j, i) = length(cluster_pix(cluster_classes == j)) / length(cluster_pix);
        end
    end
end

