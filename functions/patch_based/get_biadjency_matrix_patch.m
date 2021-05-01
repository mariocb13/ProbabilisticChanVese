function B = get_biadjency_matrix_patch(patches, patches_clusters, A, I_range, n_clusters)
%GET_BIADJENCY_MATRIX Get the encoding matrix pixel(row)-value(column)
%   Input:
%       patches: Obtained patches
%       patches_clusters: Idx of the cluster assigned to each patch
%       A: Assignment matrix
%       I_range: Range of intensity values of the image. eg 0:255
%       n_clusters: Number of centroids/Dictionary entro
%   Output:
%       B: Biadjency matrix

A_col= A(:);
B_pix_cluster = double(A_col == (1:n_clusters));    % Matrix: N_pixels-by-N_clusters

B_cluster_int = zeros(n_clusters,length(I_range));  % Matrix: N_clusters-by-N_intensities
for i = 1:length(patches_clusters)                  % Represents the ocurrence of the intensities in the cluster
    p = patches(i,:)';
    B_cluster_int(patches_clusters(i),:) = B_cluster_int(patches_clusters(i),:) + sum(p == I_range);
end

B = B_pix_cluster * B_cluster_int;
rows = sum(B,2);
rows(rows == 0) = 1;
B = B./rows;
end

