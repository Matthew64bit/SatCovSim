function sats = loadAllSatData(opName, scenario)
    opName = lower(opName);
    opName = opName + "_trimmed";
    FILENAME = "%s.tle";
    filepath = pwd + "\data\" + sprintf(FILENAME, opName);
    sats = satellite(scenario, filepath, "OrbitPropagator","sgp4");
end