clc
clear all
close all

borders = getCountryBorders("Romania");
origin = [min(borders(:, 1)), min(borders(:, 2))];

%%
borders_cart = deg2cart(borders, origin);
origin_cart = deg2cart(origin);
A = [min(borders_cart(:, 1)), max(borders_cart(:, 2))];
C = [max(borders_cart(:, 1)), min(borders_cart(:, 2))];

myArea_cart = devideArea(A, C, 6);
myArea_cart = computeValidPoints(borders_cart, myArea_cart);

%%
myArea = cart2deg(myArea_cart, origin);

%%
scatter(myArea(:, 2), myArea(:, 1))
