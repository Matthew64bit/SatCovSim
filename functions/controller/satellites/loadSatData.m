function sat = loadSatData(opName, satname, scenario)
    filepath = pwd + "\data\" + opName + "\" + satname;
    sat = satellite(scenario, filepath);
end