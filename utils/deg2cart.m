function points_cart = deg2cart(points, origin)
    arguments
        points;
        origin = [0, 0];
    end
    R = 6.378; % Earth radius in km
    points = points - origin;
    
    x = R * deg2rad(points(:, 2)) .* cos(deg2rad(origin(1)));
    y = R * deg2rad(points(:, 1));

    points_cart = [x, y];
end