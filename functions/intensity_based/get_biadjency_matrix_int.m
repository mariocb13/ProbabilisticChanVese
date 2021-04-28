function B = get_biadjency_matrix_int(I, range)
%GET_BIADJENCY_MATRIX Get the encoding matrix pixel(row)-value(column)
%   Input:
%       I: Input image
%       range: Range of values of the image. eg: 0:255
%   Output:
%       B: Biadjency matrix

if nargin == 1
    range = 0:255;
end

I_column = I(:);
B = double(I_column == range);
end

