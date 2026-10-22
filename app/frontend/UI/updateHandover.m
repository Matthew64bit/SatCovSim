function updateHandover(app)
    updateData(app.MaxSatellitesTextArea, app.LatitudeMaxTextArea, app.LongitudeMaxTextArea, 0, 0, 0);
    updateData(app.MinSatellitesTextArea, app.LatitudeMinTextArea, app.LongitudeMinTextArea, 0, 0, 0);
    app.MeanSatellitesTextArea.Value = "";

    app.DisconnectedProbabilityTextArea.Value = string(app.DProbability) + "%";
    app.ConnectedProbabilityTextArea.Value = string(app.CProbability) + "%";
    app.HandoverProbabilityTextArea.Value = string(app.HProbability) + "%";

    displayHeatmap(app.Handovers, app.GroundPoints, app.CurrIdx, app.UIAxes, "handover");
    app.DateandTimeTextArea.Value = string(app.CurrTime);
end