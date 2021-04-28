function snake = make_circular_snake(centre, radius, n_points)
% make_circular_snake 
% You may define a circular snake with points (x0 + r cos α, y0 + r sin α), 
% where (x0, y0) is a circle center, r is a radius and angular parameter α 
% takes n values from [0, 2πi]

theta = (1:n_points)*2*pi/n_points;
snake = [centre(2) + radius*cos(theta); centre(1)+ radius*sin(theta)]';
end

