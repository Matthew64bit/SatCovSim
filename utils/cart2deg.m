function result = cart2deg(points, origin)
    R = 6.378; % Earth radius in km

    x = points(:, 1);
    y = points(:, 2);

    lat = deg2rad(y/R);
    long = x / (R * cos(deg2rad(origin(1))));

    lat = rad2deg(lat) + origin(1);
    long = rad2deg(long) + origin(2);

    result = [lat, long];

end