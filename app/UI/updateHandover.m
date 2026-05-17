function updateHandover(app)
    updateData(app.MaxSatellitesTextArea, app.LatitudeMaxTextArea, app.LongitudeMaxTextArea, 0, 0, 0);
    updateData(app.MinSatellitesTextArea, app.LatitudeMinTextArea, app.LongitudeMinTextArea, 0, 0, 0);
    app.MeanSatellitesTextArea.Value = "";
    
    displayHeatmap(app.Handovers, app.GroundPoints, app.CurrIdx, app.UIAxes, "parula");
    app.DateandTimeTextArea.Value = string(app.CurrTime);
end