function filterSats(opname)
    visAngle = 10;
    minLat = 43.9372 - visAngle;

    filepathIn = pwd + "\data\" + opname + ".tle";
    filepathOut = pwd + "\data\" + opname + "_trimmed.tle";
    if isfile(filepathIn)
        fin = fopen(filepathIn, 'r');
        fout = fopen(filepathOut, 'w');

        title = "";
        line1 = "";
        line2 = "";

        while ~feof(fin)
            title = fgetl(fin);
            line1 = fgetl(fin);
            line2 = fgetl(fin);

            inclination = line2(9:16);
            inclination = str2double(inclination);

            if inclination >= minLat
                fprintf(fout, '%s\n%s\n%s\n', title, line1, line2);
            end
        end
        fclose(fin);
        fclose(fout);
    end
end