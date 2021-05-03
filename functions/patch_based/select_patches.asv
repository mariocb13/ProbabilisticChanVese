function [patches_out, idx_out] = select_patches(patches,idx,I_size, p_size,...
    strategy, n_out)
%SELECT_PATCHES Select a subset of patches (equivalent to a im2col(A,[m n])
% Input:
%   patches: Output patches from get_image_patches. N_patch-by-Intensities.
%   idx: Linear position of the patches in the image
%   I_size: Dimensions of the image
%   p_size: Dimensions of the patch (Scalar)
%   strategy: 'distinct' or 'random'
%   n_out: In case of random, the number of patches to select
% Output:
%   patches_out: Selected patches
%   idx_out: Linear position of the patches in the image

switch strategy
    case 'distinct'
        I = zeros(I_size);
        I(idx) = 1;         % Binary image with 1 where we extracted a patch

        skips = p_size; % We sample one patch every "skips" patches
        [X,Y] = meshgrid(1:I_size(2),1:I_size(1));
        X = (mod(X+1,skips) == 0);
        Y = (mod(Y+1,skips) == 0);

        selected = logical(X.*Y.*I); % Sampled patches

        pos = 1:numel(I);
        [idx_out,ia, ~] = intersect(idx, pos(selected(:)));
        patches_out = patches(ia,:);
    case 'random'
        n_patches = size(patches,1);
        p = randperm(n_patches, n_out);
        
        idx_out = idx(p);
        patches_out = patches(p,:);
end

end

