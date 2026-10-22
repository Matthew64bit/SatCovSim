function [maxVisibleSats, isVisible, meanEpoch] = computeCoverage(groundPoints, f, opname, timeVector, loadBar, weather)
    %% Load sat data
    tleStruct = loadAllSatData(opname);
    meanEpoch = mean([tleStruct.Epoch]);

    %% Computing
    [sat_pos, ~] = propagateOrbit(timeVector, tleStruct, "PropModel", "sgp4", "OutputCoordinateFrame","geographic");
    clear tleStruct;

    %% Data initialization for collecting results
    minute_pos_size = size(sat_pos);
    maxVisibleSats = zeros(length(groundPoints), minute_pos_size(2), "uint16");
    %isVisible = zeros(minute_pos_size(2), minute_pos_size(3), length(groundPoints), "uint8");
    isVisible = zeros(minute_pos_size(3), minute_pos_size(2), length(groundPoints), "uint8");

    batch_size = ceil(length(sat_pos)/6);
    par_idx = uint16(1:batch_size:length(sat_pos));
    clear batch_size;

    %% Batch again for ground points
    if length(groundPoints) > 15000
        ground_batches = 1:10000:length(groundPoints);
        if ground_batches(end) ~= length(ground_batches)
            ground_batches(end + 1) = length(groundPoints);
        end

        for i = 1:length(ground_batches) - 1
            for j = 1:length(par_idx) - 1
                [out1, out2] = getMaxVizSat(sat_pos(:, :, par_idx(j):par_idx(j + 1)), groundPoints(ground_batches(i):ground_batches(i + 1), :), f, weather);
                maxVisibleSats(ground_batches(i):ground_batches(i + 1), :) = maxVisibleSats(ground_batches(i):ground_batches(i + 1), :) + out1;
                %isVisible(:, par_idx(j):par_idx(j + 1), ground_batches(i):ground_batches(i + 1)) = uint8(out2);
                isVisible(par_idx(j):par_idx(j + 1), :, ground_batches(i):ground_batches(i + 1)) = permute(uint8(out2), [2, 1, 3]);
            end
        end
    else
        %% Serial calculations
        for i = 1:length(par_idx) - 1
            [out1, out2] = getMaxVizSat(sat_pos(:, :, par_idx(i) : par_idx(i+1)), groundPoints, f, weather);
            maxVisibleSats = maxVisibleSats + out1;
            %isVisible(:, par_idx(i):par_idx(i+1), :) = uint8(out2);
            isVisible(par_idx(i):par_idx(i+1), :, :) = permute(uint8(out2), [2, 1, 3]);
        end
    end
    clear out1 out2 sat_pos;

    %isVisible = permute(isVisible, [2 1 3]);
    loadBar.Value = "100%";
end