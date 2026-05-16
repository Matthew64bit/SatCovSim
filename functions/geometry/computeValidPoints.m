function validPoints = computeValidPoints(borders, points)
    validPoints = zeros(floor(length(points)*0.7), 2);
    j = 1;
    for i = 1:length(points)
        val = inpolygon(points(i, 2), points(i, 1), borders(:, 2), borders(:, 1));
        if val
            if j == length(validPoints)
                validPoints(end+1, 1:2) = points(i, 1:2);
            else
                validPoints(j, :) = points(i, :);
            end
            j = j + 1;
        end
    end
    validPoints = validPoints(all(validPoints ~= 0, 2), :);
end