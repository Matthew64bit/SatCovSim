clc
clearvars
close all
delete(gcp('nocreate'))

opName = 'starlink';

%% Init
disp("Starting Init");

sc = satelliteScenario("AutoSimulate", false);

borders = getCountryBorders("Romania");
validPoints = computeValidPoints(borders, devideArea([48.4688, 20.1438], [43.2432, 29.4066], 5));

disp("Finished Init");
%% Load sats
disp("Starting to load satellites");

filepath = pwd + "\data\" + opName + ".tle";

if isfile(filepath)
    age = getFileAge(filepath);
    if age > "0:00:00"
        getSatData(opName, "csv");
    end
else
    getSatData(opName);
end

disp("Loading satellites done")
%% Create satellites obj
disp("Creating satellite objects");

tic
sats = loadAllSatData("starlink", sc);
toc

pos = zeros(3, 1, length(sats));

disp("Satellite objects created");
%% Create threadpool
disp("Starting thread pool");

time_to_compute = sc.StartTime + (sc.StopTime - sc.StartTime)/2;
par_idx = 1:2000:length(pos);
F(length(par_idx) - 1) = parallel.Future;
pool = parpool("Processes");

if par_idx(end) ~= length(pos)
    par_idx = [par_idx, length(pos)];
end

disp("Thread pool created");
%% Get satellites position

for i = 1:length(par_idx) - 1
    F(i) = parfeval(pool, @states, 1, sats(par_idx(i):par_idx(i+1)), time_to_compute, "CoordinateFrame", "geographic");
    fprintf("Done %d%%\n", (i/length(par_idx))*100);
end

for i = 1:length(F)
    [idx, out] = fetchNext(F);
    pos(:,:,par_idx(idx):par_idx(idx+1)) = out;
end


%% Simulate max vizible sats using threadpool
disp("Starting multithreaded simmulations")

maxVisibleSats = zeros(length(validPoints), 3);
maxVisibleSats(:, 1:2) = validPoints;


for i = 1:length(F)
    F(i) = parfeval(pool, @getMaxVizSat, 1, pos(:,:,par_idx(i):par_idx(i + 1)), validPoints);
    fprintf("Done %d%%\n", (i/length(par_idx))*100);
end

for i = 1:length(F)
    [idx, out] = fetchNext(F);
    maxVisibleSats(:, 3) = out(:, 3) + maxVisibleSats(:, 3);
end

%% Make heatmap
x = maxVisibleSats(:, 2);
y = maxVisibleSats(:, 1);
z = maxVisibleSats(:, 3);

if max(z) == 0
    disp("No vizible satellites");
else
    s = scatter(x,y,20, z, "filled");
    colormap turbo
    colorbar
end
