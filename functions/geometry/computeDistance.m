function distance = computeDistance(validPoints, pos)
    [x1, y1, z1] = geodetic2ecef(wgs84Ellipsoid('kilometer'), validPoints(:, 1), validPoints(:, 2), 0.4);
    [x2, y2, z2] = geodetic2ecef(wgs84Ellipsoid('kilometer'), pos(1, :, :), pos(2, :, :), pos(3, :, :)/1000);

    distance = single(sqrt((x2 - x1).^2 + (y2 - y1).^2 + (z2 - z1).^2));
end