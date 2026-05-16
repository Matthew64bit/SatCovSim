function logger(errText, currFunction)
    filepath = pwd + "\log\logs\";   
    filename = currFunction + ".txt";

    filepath = filepath + filename;
    fileID = fopen(filepath, 'a');

    try
        log_date = datetime("now");
        log_date = string(log_date);
        fprintf(fileID, log_date + " " + errText);
    catch ME
        disp("Error trying to log error, how did we get here??")
    end

    fclose(fileID);
end