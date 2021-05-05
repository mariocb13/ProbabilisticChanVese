function [force, P_in, P_out] = external_forces_patch(snake,B,I,X,Y)
%EXTERNAL_FORCES_PATCH Computes the external forces to evolve the curve
% Input:
%   snake: Closed snake
%   B: Biadjency matrix
%   I: Image
%   X: X grid coordinates  
%   Y: Y grid coordinates
%
% Output:
%   force: External forces

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
%    p_out = f_out ./ (f_in+f_out);
   
   % Handle probabilities f_in+f_out = 0
   p_in(isnan(p_in)) = 0.5;
%    p_out(isnan(p_out)) = 0.5;
   
   P_in = B*p_in;
%    P_out = 1- P_in; % B*p_out./sum(B,2);
   
   % Get the probability images
   P_in = reshape(P_in,[size(I,1), size(I,2)]);
%    P_in = imgaussfilt(P_in, 0.5);
%    P_out = reshape(P_out,[size(I,1), size(I,2)]);
   P_out = 1 - P_in;
   
%    P_out = P_out + 1e-5;
%    f = log(P_in./P_out);
   
   force = interp2(X,Y,P_in,snake(:,2),snake(:,1))-interp2(X,Y,P_out,snake(:,2),snake(:,1));
%    force = interp2(X,Y,f,snake(:,2),snake(:,1));
end

