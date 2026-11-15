clc
clear all
close all

opname = "starlink";
f = 2;
weather = "clear";

%% Format satellite data and get time frame
getSatData(opname);
tleStruct = tleread("data\starlink_trimmed.tle");

%startTime = datetime(2026,10, 14, 18, 0, 0, 'TimeZone', 'UTC');
startTime = datetime(2026, 10, 25, 0, 0, 0, 'TimeZone', 'UTC');
%startTime = datetime("now", "TimeZone", "UTC");

% time_1s = startTime : seconds(1) : startTime + seconds(33);
% time_3s = startTime : seconds(3) : startTime + seconds(33);
time_60s = startTime : minutes(1) : startTime + minutes(29);
timeVector = time_60s;

%% Trajectory computing
[sat_pos, ~] = propagateOrbit(timeVector, tleStruct, "PropModel", "sgp4", "OutputCoordinateFrame","geographic");
sat_pos = single(sat_pos);
clear tleStruct timeVector time_60s startTime opname;

%% Compute area
borders = single(getCountryBorders("Europe"));
A = [max(borders(:, 1)), min(borders(:, 2))];
C = [min(borders(:, 1)), max(borders(:, 2))];

rez = 5;
myArea = single(devideFixedArea(A, C, rez));
validPoints = single(computeValidPoints(borders, myArea));

%lat_rez = (A(1) - C(1)) / 2^6;
%long_rez = (C(2) - A(2)) / 2^6;

lat_rez_km = haversine(A, [C(1), A(2)]) / 2^rez;
long_rez_km = haversine(A, [A(1), C(2)]) / 2^rez;

clear A C borders myArea rez long_rez_km lat_rez_km;

%% Data initialization for collecting results
sat_pos_size = size(sat_pos);
maxVisibleSats = zeros(length(validPoints), sat_pos_size(2), "uint16");
isVisible = zeros(sat_pos_size(3), sat_pos_size(2), length(validPoints), "uint8");

batch_size = ceil(length(sat_pos)/6);
par_idx = uint16(1:batch_size:length(sat_pos));
clear batch_size;

%% Batch again for ground points
if length(validPoints) > 15000
    ground_batches = 1:10000:length(validPoints);
    if ground_batches(end) ~= length(ground_batches)
        ground_batches(end + 1) = length(validPoints);
    end

    for i = 1:length(ground_batches) - 1
        for j = 1:length(par_idx) - 1
            [out1, out2] = getMaxVizSat(sat_pos(:, :, par_idx(j):par_idx(j + 1)), validPoints(ground_batches(i):ground_batches(i + 1), :), f, weather);
            maxVisibleSats(ground_batches(i):ground_batches(i + 1), :) = maxVisibleSats(ground_batches(i):ground_batches(i + 1), :) + out1;
            %isVisible(par_idx(j):par_idx(j + 1), :, ground_batches(i):ground_batches(i + 1)) = permute(uint8(out2), [2, 1, 3]);
        end
    end
else
    for i = 1:length(par_idx) - 1
        [out1, out2] = getMaxVizSat(sat_pos(:, :, par_idx(i) : par_idx(i+1)), validPoints, f, weather);
        maxVisibleSats = maxVisibleSats + out1;
        %isVisible(par_idx(i):par_idx(i+1), :, :) = permute(uint8(out2), [2, 1, 3]);
    end
end

%%
% linkStatus = computeLinkStatus(isVisible)';
% 
% %% Display
% x = validPoints(:, 2);
% y = validPoints(:, 1);
% z = maxVisibleSats(:, 1);
% 
% if max(z) == 0
%     disp("No vizible satellites");
% else
%     s = scatter(x,y,4, z, "filled");
%     colormap parula
%     colorbar
% end
% 
% scatter(x,y,4, z, "filled");
% clear x y z;
