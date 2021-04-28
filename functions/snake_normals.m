function average_normals = snake_normals(snake)
%snake_normals Return the normals of the snake segments
%   Input:
%       snake: Nx2 matrix
%   Output:
%       N: Nx2 matrix, curve normals
%
% https://scicomp.stackexchange.com/questions/16444/determine-unit-outward-normal-vector-for-a-curve

snake = snake'; % Size 2*N
finite_diff = diff([snake(:,end), snake, snake(:,1)], 1, 2);

for i = 1:length(finite_diff)
    normals(i,:) = null(finite_diff(:,i)');
end

% Check the orientation of the normals
outwards_n = check_orientation(normals, finite_diff);

% Average normals
average_normals = movmean(outwards_n, [0 1], 1);
average_normals(end,:) = [];

function outwards_n = check_orientation(normals, finite_diff)
   n = length(normals);
   normals = [normals, zeros(n,1)];
   finite_diff = [finite_diff', zeros(n,1)];

   C = cross(normals, finite_diff, 2); % Use the cross product to check
   signed = sign(C(:,3)); % The ones which have negative third dimension are opposite
   outwards_n = normals(:,1:2).*signed;
end

end
