function [ result ] = getHomography( src, dest, num)
% Calculate parameters of transformation according to pairs of points.
% result : matrix for projective transformation
    
    x1 = src(1, :)';
    y1 = src(2, :)';
    x2 = dest(1, :)';
    y2 = dest(2, :)';
    
    A = zeros(num * 2, 8);
    A(1 : 2 : end, 1 : 3) = [x2, y2, ones(num, 1)];
    A(2 : 2 : end, 4 : 6) = [x2, y2, ones(num, 1)];
    A(1 : 2 : end, 7 : 8) = [-x2 .* x1, -y2 .* x1];
    A(2 : 2 : end, 7 : 8) = [-x2 .* y1, -y2.* y1];
    B = [x1, y1];
    B = reshape(B', num * 2, 1);
    h = pinv(A) * B;

    result = [h(1), h(2), h(3); h(4), h(5), h(6); h(7), h(8), 1];
end

