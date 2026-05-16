function country_coord = getCountryBorders(countryName)
    countryName = lower(countryName);
    filename = "%s_coord.csv";
    filepath = pwd + "\data\" + sprintf(filename, countryName);

    coord = readtable(filepath);
    coord = table2array(coord);
    sz = size(coord);

    deg_coord = zeros(sz(1), 2);

    for i = 1:sz(1)
        deg_coord(i, 1) = deg2dec(coord(i, 1), coord(i, 2), coord(i, 3));
        deg_coord(i, 2) = deg2dec(coord(i, 4), coord(i, 5), coord(i, 6));
    end

    country_coord = deg_coord;
end