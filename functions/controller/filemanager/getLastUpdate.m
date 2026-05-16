function latUpdate = getLastUpdate(filepath)
    file = dir(filepath);
    latUpdate = file(3);
end