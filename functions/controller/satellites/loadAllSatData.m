function sats = loadAllSatData(opName)
    opName = lower(opName);
    opName = opName + "_trimmed";
    FILENAME = "%s.tle";
    filepath = pwd + "\data\" + sprintf(FILENAME, opName);
    sats = tleread(filepath);
end