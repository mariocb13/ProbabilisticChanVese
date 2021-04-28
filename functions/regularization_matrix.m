function B = regularization_matrix(N,alpha,beta)
% B is an NxN matrix for imposing elasticity and rigidity to snakes
% alpha is weigth for second derivative (elasticity)
% beta is weigth for (-)fourth derivative (rigidity)

r = zeros(1,N);
r(1:3) = alpha*[-2 1 0] + beta*[-6 4 -1];
r(end-1:end) = alpha*[0 1] + beta*[-1 4];
A = toeplitz(r);
B = (eye(N)-A)^-1;
end

% kernel_elasticity = alpha.*[1 -2 1]';
% kernel_rigidity = beta.*[-1 4 -6 4 -1]';
% 
% A = conv2(eye(n_points), kernel_elasticity, 'same');
% B = conv2(eye(n_points), kernel_rigidity, 'same');
% 
% A(end,1) = 1; A(1,end) = 1;
% B(end-1:end,1) = [4; -1]; B(1:2,end) = [4; -1];
% 
% reg_matrix = inv(eye(n_points) - A - B);
