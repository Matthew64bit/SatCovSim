clc
clear all
close all

borders = getCountryBorders("Romania");
validPoints = computeValidPoints(borders, devideArea([48.4688, 20.1438], [43.2432, 29.4066], 6));

%%
my_sum = 0;
for i = 1:length(validPoints) - 1
    my_sum = my_sum + haversine(validPoints(i, :), validPoints(i+1, :));
end

my_sum = my_sum / (length(validPoints) - 1);