function displayHeatmap(maxVisibleSats, groundPoints, timeStep, figDisplay, dispType)
    x = groundPoints(:, 2);
    y = groundPoints(:, 1);
    z = maxVisibleSats(:, timeStep);

    if dispType == "coverage"
        scatter(figDisplay, x, y, 20, z, 'filled'); 
        colormap(figDisplay, "parula");
        colorbar(figDisplay);
        xlabel("Longitude (°)", "Parent", figDisplay);
        ylabel("Latitude (°)", "Parent", figDisplay);
        title("Satellite visibility display", "Parent", figDisplay)
    elseif dispType == "handover"
        scatter(figDisplay, x, y, 20, z, 'filled'); 
        colormap(figDisplay, "parula");
        xlabel("Longitude (°)", "Parent", figDisplay);
        ylabel("Latitude (°)", "Parent", figDisplay);
        title("Link stability display", "Parent", figDisplay)
    end
    
        
    % colorbar(figDisplay);
end