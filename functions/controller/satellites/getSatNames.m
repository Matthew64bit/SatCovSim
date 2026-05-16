function satNames = getSatNames(opName, numSats)
    sats = dir(pwd + "\data\" + opName);
    
    % Returns !!! CELL ARRAY !!! with satellite names to select
    % because app.ui can only use cell array...
    names = struct2cell(sats);
    satNames = names(1, 3:numSats+3);
end