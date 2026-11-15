clc
clear all
close all

fpart1 = "data\simulations\1m_24102026_";
fpart2 = "000UTC_5km_eur_starlink_2GHz.mat";

statData = load("data\simulations\1m_24102026_000000UTC_5km_eur_starlink_2GHz.mat");
statData = statData.maxVisibleSats;

simData = load("data\simulations\1m_24102026_003000UTC_5km_eur_starlink_2GHz.mat");
statData = statData + simData.maxVisibleSats;

for i = 1:1:23
    for j = 0:3:3
        if i < 10
            filePath = fpart1 + "0" + string(i) + string(j) + fpart2;
        else
            filePath = fpart1 + string(i) + string(j) + fpart2;
        end

        simData = load(filePath);
        statData = statData + simData.maxVisibleSats;
    end
end


%%
borders = single(getCountryBorders("Europe"));
A = [max(borders(:, 1)), min(borders(:, 2))];
C = [min(borders(:, 1)), max(borders(:, 2))];

rez = 5;
myArea = single(devideFixedArea(A, C, rez));
validPoints = single(computeValidPoints(borders, myArea));

clear fpart1 fpart2 ans filePath i j myArea rez A C borders;

%%
matData = [validPoints(:, 1), validPoints(:, 2), statData(:, 1)];

%%
statData = sum(statData, 2);

%%
normStatData = statData/10582;

%%
x = double(validPoints(:, 2));
y = double(validPoints(:, 1));
z = normStatData;

figure

s = scatter(x, y, 3, z, "filled");
colormap parula, xlabel("Latitude (°)"), ylabel("Longitude (°)"), colorbar, title("Satellite visibility for 24h");

%%
longitude_mask = ismembertol(y, 52.5516, 1e-5);

longitude_values_sat = normStatData(longitude_mask, 1);
longitude_values_map = validPoints(longitude_mask, 2);

figure
scatter(longitude_values_map, longitude_values_sat, 36, longitude_values_sat, "filled")
title("Satellite distribution on latitude = 52.5516"), ylabel("No. of satellites"), xlabel("Longitude (°)")

%%
latitude_mask = ismembertol(x, 21.6778, 1e-5);

latitude_values_sat = normStatData(latitude_mask, 1);
latitude_values_map = validPoints(latitude_mask, 1);

scatter(latitude_values_map, latitude_values_sat, 36, latitude_values_sat, "filled")
title("Satellite distribution on longitude = 21.6778"), ylabel("No. of satellites"), xlabel("Latitude (°)")