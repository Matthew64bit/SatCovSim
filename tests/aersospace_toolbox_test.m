clc
clear all
close all

opname = "starlink";

%% Format satellite data and get time frame
getSatData(opname);
tleStruct = tleread("data\starlink_trimmed.tle");

startTime = datetime(2026,10, 14, 18, 0, 0, 'TimeZone', 'UTC');
time_1s = startTime : seconds(1) : startTime + seconds(33);
% time_3s = startTime : seconds(3) : startTime + seconds(33);
timeVector = time_1s;

%% Trajectory computing
[sat_pos, ~] = propagateOrbit(timeVector, tleStruct, "PropModel", "sgp4", "OutputCoordinateFrame","geographic");
sat_pos = single(sat_pos);
clear tleStruct timeVector time_1s startTime;

%% Compute area
borders = single(getCountryBorders("Romania"));
A = [max(borders(:, 1)), min(borders(:, 2))];
C = [min(borders(:, 1)), max(borders(:, 2))];

rez = 10;
myArea = single(devideFixedArea(A, C, rez));
validPoints = single(computeValidPoints(borders, myArea));

%lat_rez = (A(1) - C(1)) / 2^6;
%long_rez = (C(2) - A(2)) / 2^6;

lat_rez_km = haversine(A, [C(1), A(2)]) / 2^rez;
long_rez_km = haversine(A, [A(1), C(2)]) / 2^rez;

clear A C borders myArea rez;

%% Data initialization for collecting results
sat_pos_size = size(sat_pos);
maxVisibleSats = zeros(length(validPoints), sat_pos_size(2), "uint16");
isVisible = zeros(sat_pos_size(2), sat_pos_size(3), length(validPoints), "uint8");

batch_size = ceil(length(sat_pos)/6);
par_idx = uint16(1:batch_size:length(sat_pos));
clear batch_size;

%% Compute max visible satellites
for i = 1:length(par_idx) - 1
    [out1, out2] = getMaxVizSat(sat_pos(:, :, par_idx(i) : par_idx(i+1)), validPoints, 0.138, "clear", false);
    maxVisibleSats = max(maxVisibleSats, uint16(out1));
    isVisible(:, par_idx(i):par_idx(i+1), :) = uint8(out2);
end

isVisible = permute(isVisible, [2 1 3]);

%%
linkStatus = computeLinkStatus(isVisible)';

%% Display
x = validPoints(:, 2);
y = validPoints(:, 1);
z = maxVisibleSats(:, 1);

if max(z) == 0
    disp("No vizible satellites");
else
    s = scatter(x,y,4, z, "filled");
    colormap parula
    colorbar
end

scatter(x,y,4, z, "filled");
clear x y z;

%%
cProb = squeeze(permute(sum(linkStatus == 1, 1)/length(validPoints)*100, [2, 1]));
hProb = sum(linkStatus == 2, 1)/length(validPoints)*100;
dProb = sum(linkStatus == 3, 1)/length(validPoints)*100;

%% Plot
x = 1:1:32;
stem(x, cProb, "Color", "g");
hold on
stem(x, hProb, "Color", "y");
hold on
stem(x, dProb, "Color", "r");