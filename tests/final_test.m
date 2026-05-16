clc
clearvars
close all
delete(gcp("nocreate"))

opName = "starlink";

%% Start scenario

sc = satelliteScenario("AutoSimulate", false);

disp("Satellite scenario created successfully!");

%% Load points inside borders

borders = single(getCountryBorders("Romania"));
A = [max(borders(:, 1)), min(borders(:, 2))];
C = [min(borders(:, 1)), max(borders(:, 2))];

myArea = devideArea(A, C, 6);
validPoints = single(computeValidPoints(borders, myArea));

clear A C borders myArea; 
%% Load satellites

sats = loadAllSatData(opName, sc);

disp("Satellites loaded successfully!");

%% Create thread pool for async compute

batch_size = ceil(length(sats)/6);
par_idx = 1:batch_size:length(sats);
if par_idx(end) ~= length(sats)
    par_idx = [par_idx, length(sats)];
end

F(length(par_idx) - 1) = parallel.Future;
pool = parpool("Processes");


%% Pos vector creation interlude
sc.AutoSimulate = true;

dummy_pos_size = size(states(sats(1), "CoordinateFrame", "geographic"));

% Minute pos for a 1 minute time resolution
minute_pos = zeros(dummy_pos_size(1), dummy_pos_size(2), length(sats));
clear dummy_pos_size;

%% Compute satellite position for each point in time

% Distribute data to workers
for i = 1:length(F)
    F(i) = parfeval(pool, @states, 1, sats(par_idx(i):par_idx(i+1)), "CoordinateFrame", "geographic");
end

% Collect data from workers
for i = 1:length(F)
    [idx, out] = fetchNext(F);
    minute_pos(:, :, par_idx(idx) : par_idx(idx+1)) = out;
    fprintf("Done %d%%\n", (i/length(F))*100);
end

clear sats;

%% Interpolate data

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

%% Create variables for computation

seconds_pos_size = size(seconds_pos);
maxVisibleSats = zeros(length(validPoints), seconds_pos_size(2));
isVisible = zeros(seconds_pos_size(2), seconds_pos_size(3), length(validPoints));

%% Create variables for paralel compute
clear F;

% Seconds pos iter
batch_size = ceil(length(seconds_pos)/100);
par_idx = 1:batch_size:length(seconds_pos);
if par_idx(end) ~= length(seconds_pos)
    par_idx = [par_idx, length(seconds_pos)];
end

F(length(par_idx) - 1) = parallel.Future;

%% Get satellite visible at a moment in time
k = 1;
for i = 1:length(par_idx) - 1
    F(i) = parfeval(pool, @getMaxVizSat, 1, seconds_pos(:, :, par_idx(i) : par_idx(i+1)), validPoints);
end

for i = 1:length(F)
    [idx, out] = fetchNext(F);
    fprintf("Done %d%%\n", (i/length(F))*100);
    maxVisibleSats = maxVisibleSats + out;
end



%% Make heatmap

for i = 1:seconds_pos_size(2)
    x = validPoints(:, 2);
    y = validPoints(:, 1);
    z = maxVisibleSats(:, i);

    if max(z) == 0
        disp("No vizible satellites");
    else
        s = scatter(x,y,20, z, "filled");
        colormap turbo
        colorbar
    end
    pause(2);
end

%% Mem test
tic
getMaxVizSat(seconds_pos(:, :, 1:2), validPoints, 21);
toc