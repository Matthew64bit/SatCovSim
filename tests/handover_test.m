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
par_idx = uint16(1:batch_size:length(sats));
if par_idx(end) ~= length(sats)
    par_idx = [par_idx, length(sats)];
end

F(length(par_idx) - 1) = parallel.Future;
pool = parpool("Processes");

clear batch_size;
%% Pos vector creation interlude
sc.AutoSimulate = true;

dummy_pos_size = size(states(sats(1), "CoordinateFrame", "geographic"));

% Minute pos for a 1 minute time resolution
minute_pos = zeros(dummy_pos_size(1), dummy_pos_size(2), length(sats), "single");
clear dummy_pos_size;

%% Compute satellite position for each point in time

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

%% Create variables for computation
seconds_pos = minute_pos;


seconds_pos_size = size(seconds_pos);
maxVisibleSats = zeros(length(validPoints), seconds_pos_size(2), "uint8");
isValid = zeros(seconds_pos_size(2), seconds_pos_size(3), length(validPoints), "uint8");

clear minute_pos;


%% Compute max visible satellites
for i = 1:length(par_idx) - 1
    F(i) = parfeval(pool, @getMaxVizSat, 2, seconds_pos(:, :, par_idx(i) : par_idx(i+1)), validPoints, 21);
end

for i = 1:length(F)
    [idx, out1, out2] = fetchNext(F);
    fprintf("Done %d%%\n", (i/length(F))*100);
    maxVisibleSats = maxVisibleSats + out1;
    isValid(:, par_idx(idx):par_idx(idx+1), :) = uint8(out2);
end

isValid = permute(isValid, [2 1 3]);
%%
handovers = computeHandoverProbability(isValid);

% 1 - handover happens
% 2 - staying connect (aka no handover)
% 3 - connection is dropped

%% Make heatmap


x = validPoints(:, 2);
y = validPoints(:, 1);
z = handovers(3, :);

if max(z) == 0
    disp("No vizible satellites");
else
    s = scatter(x,y,20, z, "filled");
    colormap turbo
    colorbar
end