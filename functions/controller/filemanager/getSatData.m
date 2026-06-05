function getSatData(name)
    name = lower(name);
    try

        filepath = pwd + "\data\" + name + ".tle";

        if isfile(filepath)
            age = getFileAge(filepath);
            if age < "24:00:00"
                pyrunfile(pwd + "\py_file_handler\main.py" + " " + "'" + name + "'");
                return
            end
        end

        FILENAME = "%s.tle";
        BSADRR = "https://celestrak.org/NORAD/elements/gp.php?GROUP=%s&FORMAT=tle";

        filename = sprintf(FILENAME, name);
        url = sprintf(BSADRR, name);

        data = webread(url);

        filepath = pwd + "\data\" + filename;
        
        fileID = fopen(filepath, 'w');
        fprintf(fileID, '%s', data);
        fclose(fileID);

        pyrunfile(pwd + "\py_file_handler\main.py" + " " + "'" + name + "'");
    catch ME
        logger(ME.message, mfilename);
    end
end