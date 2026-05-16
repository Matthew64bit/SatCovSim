function displayHeatmap(maxVisibleSats, groundPoints, timeStep, figDisplay)
    x = groundPoints(:, 2);
    y = groundPoints(:, 1);
    z = maxVisibleSats(:, timeStep);

    if max(z) == 0
        disp("No vizible satellites");
    else
        scatter(figDisplay, x, y, 20, z, 'filled'); 
        colormap(figDisplay,"turbo") ; 
        colorbar(figDisplay);
    end
end