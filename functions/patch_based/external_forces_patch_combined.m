function [force, P_in, P_out] = external_forces_patch_combined(snake,B1,B2,I,X,Y)
%EXTERNAL_FORCES_PATCH Computes the external forces to evolve the curve.
%   Averaging two probability images
% Input:
%   snake: Closed snake
%   B: Biadjency matrix
%   I: Image
%   X: X grid coordinates  
%   Y: Y grid coordinates
% Output:
%   force: External forces

   P1_in = get_probability_image(snake,B1,I);
   P2_in = get_probability_image(snake,B2,I);
   P_in = (P1_in + P2_in)./2;
   
   P_in = imgaussfilt(P_in, 0.5);
   P_out = 1 - P_in;
   
   force = interp2(X,Y,P_in,snake(:,2),snake(:,1))-interp2(X,Y,P_out,snake(:,2),snake(:,1));


    function P = get_probability_image(snake,B,I)
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

       % Handle probabilities f_in+f_out = 0
       p_in(isnan(p_in)) = 0.5;

       P = B*p_in;

       % Get the probability images
       P = reshape(P,[size(I,1), size(I,2)]);
    end

end

