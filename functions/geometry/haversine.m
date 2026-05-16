function distance = haversine(pnt1, pnt2)
    R = 6371;
    if length(size(pnt1)) == 2
        lat1 = deg2rad(pnt1(1));
        long1 = deg2rad(pnt1(2));

        lat2 = deg2rad(pnt2(1));
        long2 = deg2rad(pnt2(2));
    else
        lat1 = deg2rad(pnt1(1, :, :));
        long1 = deg2rad(pnt1(2, :, :));
    
        lat2 = deg2rad(pnt2(:, 1));
        long2 = deg2rad(pnt2(:, 2));
    end
    
    dPhi = lat2 - lat1;       % Dif in latitude
    dLambda = long2 - long1;  % Dif in longitude

    a = sin(dPhi ./ 2).^2 + cos(lat1) .* cos(lat2) .* sin(dLambda ./ 2).^2;
    a(a > 1.0) = 1.0;

    c = 2 .* atan2(sqrt(a), sqrt(1 - a));
    distance = R .* c;
    distance_permuted = permute(distance, [2 3 1]);
    distance = distance_permuted;
    
end