function updateData(valueUI, latitudeUI, longitudeUI, value, latitude, longitude)
    valueUI.Value = string(value);

    if longitude >= 0
        longitudeUI.Value = string(longitude) + "°" + " E";
    else
        longitudeUI.Value = string(abs(longitude)) + "°" + " W";
    end

    if latitude >= 0
        latitudeUI.Value = string(latitude) + "°" + " N";
    else
        latitudeUI.Value = string(abs(latitude)) + "°" + " S";
    end
   
end