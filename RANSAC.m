function [ homography ] = RANSAC( matches, fa, fb, sigma, round_num )
    max_count = 0;
    for r = 1 : round_num
        samples = matches(:, randperm(size(matches, 2), 4));
        src = fa(1 : 2, samples(1, :));
        dest = fb(1 : 2, samples(2, :));
        h = getHomography(src, dest, 4);

        % Convert to homogeneous coordinates
        src = ones(3, size(matches, 2));
        dest = ones(3, size(matches, 2));
        dest(1 : 2, :) = fa(1 : 2, matches(1, :));
        src(1 : 2, :) = fb(1 : 2, matches(2, :));

        tr = h * src;
        tr(1, :) = tr(1, :) ./ tr(3, :);
        tr(2, :) = tr(2, :) ./ tr(3, :);
        ssd = (tr(1, :) - dest(1, :)) .^ 2 + (tr(2, :) - dest(2, :)) .^ 2;
        count = nnz(ssd < sigma);
        if (count > max_count)
            max_count = count;
            homography = h;
        end
    end
end

