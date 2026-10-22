function myArea = devideFixedArea(A, C, rez)
    R = 6378.14;
    A_rad = deg2rad(A);
    
    % Get latitude and longitude diff from resolution
    long_dif = 2 * asin(sqrt((sin(rez/(2*R))^2)/(cos(A_rad(1))^2)));
    lat_dif = rez/R;

    % Transform back to degrees
    long_dif_deg = rad2deg(long_dif);
    lat_dif_deg = rad2deg(lat_dif);

    % Get the X and Y vectors
    long_vector = C(1):lat_dif_deg:A(1);
    lat_vector = A(2):long_dif_deg:C(2);

    % Combine each X with each Y
    [X, Y] = meshgrid(long_vector, lat_vector);
    myArea = [X(:), Y(:)];
end