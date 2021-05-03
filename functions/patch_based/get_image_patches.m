function [linear_patches, idx] = get_image_patches(I, patch)
%GET_IMAGE_PATCHES Returns the image in patchs. Remove the edge
%features to avoid boundary effects.
% Input:
%       I = 2D image. Size r x c
%       patch = Patch size. Scalar (patch x patch). Only odd values.
% Output:
%       linear_patches = Features matrix. Row pixel, column features.
%       idx = linear index in the original image

assert(mod(patch,2)~=0, "Patch size should be an odd value");

[r, c] = size(I);
linear_patches = im2col(I, [patch patch])';

% Linear positions
% Get the number of boundary pixels we cannot use
rmv = floor(patch/2); 

% Get the linear idx of the image, mark the boundary pixels as NaN and
% remove them.
pos = 1:numel(I);

pos = reshape(pos, r, c);
pos(1:rmv,:) = ones(rmv, c)*NaN;
pos(end-rmv+1:end,:) = ones(rmv,c)*NaN;
pos(:,1:rmv) = ones(r,rmv)*NaN;
pos(:,end-rmv+1:end) = ones(r,rmv)*NaN;

remove_idx = isnan(pos);
pos(remove_idx) = [];
idx = pos(:);

end

