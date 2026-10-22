function country_coord = getCountryBorders(countryName)
    countryName = lower(countryName);

    % if countryName == "europe"
    %     data = load("data\variables\eucoords.mat", "validPoints");
    %     country_coord = data.validPoints;
    %     return
    % end
    filename = "%s_coord.csv";
    filepath = pwd + "\data\" + sprintf(filename, countryName);

    coord = readtable(filepath);
    country_coord = table2array(coord);
end