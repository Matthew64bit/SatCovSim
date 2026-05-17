function [maxVisibleSats, isValid] = computeCoverage(groundPoints, f, sats, sc, loadBar, weather, interpolated)
    %% Initial phase
    % Create thread pool for async compute
    batch_size = ceil(length(sats)/6);
    par_idx = uint16(1:batch_size:length(sats));

    if par_idx(end) ~= length(sats)
        par_idx = [par_idx, uint16(length(sats))];
    end
    
    F(length(par_idx) - 1) = parallel.Future;
    if isempty(gcp("nocreate"))
        pool = parpool("Processes");
    else
        pool = gcp();
    end
        
    
    clear batch_size;
    %% Data initialization
    % Enable autosimulate for vectorization
    sc.AutoSimulate = true;
    
    % Create position vector for 60s time step
    dummy_pos_size = size(states(sats(1), "CoordinateFrame", "geographic"));
    
    % Minute pos for a 1 minute time resolution
    minute_pos = zeros(dummy_pos_size(1), dummy_pos_size(2), length(sats), "single");
    clear dummy_pos_size;
    %% Computing
    % Distribute data to workers
    for i = 1:length(F)
        F(i) = parfeval(pool, @states, 1, sats(par_idx(i):par_idx(i+1)), "CoordinateFrame", "geographic");
    end
    
    % Collect data from workers
    for i = 1:length(F)
        [idx, out] = fetchNext(F);
        minute_pos(:, :, par_idx(idx) : par_idx(idx+1)) = single(out);
        fprintf("Done %d%%\n", (i/length(F))*100);
    end
    
    clear sats;

    %% OPTIONAL imterpolation block
     if interpolated
        org_timeframe = sc.StartTime:seconds(sc.SampleTime):sc.StopTime;
        interp_timeframe = sc.StartTime:seconds(4):sc.StopTime;
        
        minute_pos_size = size(minute_pos);
        seconds_pos = zeros(minute_pos_size(1), length(interp_timeframe), minute_pos_size(3));
        
        clear minute_pos_size
        
        for i = 1:length(minute_pos)
            seconds_pos(1, :, i) = interp1(org_timeframe, minute_pos(1, :, i), interp_timeframe, "makima");
            seconds_pos(2, :, i) = interp1(org_timeframe, minute_pos(2, :, i), interp_timeframe, "makima");
            seconds_pos(3, :, i) = interp1(org_timeframe, minute_pos(3, :, i), interp_timeframe, "makima");
        end
        minute_pos = seconds_pos;
        clear seconds_pos org_timeframe interp_timeframe;
     end
    %% Data initialization for collecting results
    minute_pos_size = size(minute_pos);
    maxVisibleSats = zeros(length(groundPoints), minute_pos_size(2), "uint8");
    isValid = zeros(minute_pos_size(2), minute_pos_size(3), length(groundPoints), "uint8");
    %% Get satellite visible at a moment in time
    for i = 1:length(par_idx) - 1
        F(i) = parfeval(pool, @getMaxVizSat, 2, minute_pos(:, :, par_idx(i) : par_idx(i+1)), groundPoints, f, weather);
    end
    
    for i = 1:length(F)
        [idx, out1, out2] = fetchNext(F);
        fprintf("Done %d%%\n", (i/length(F))*100);
        maxVisibleSats = maxVisibleSats + out1;
        isValid(:, par_idx(idx):par_idx(idx+1), :) = uint8(out2);
    end
    
    isValid = permute(isValid, [2 1 3]);
    loadBar.Value = "100%";
end