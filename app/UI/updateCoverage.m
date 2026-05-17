function updateCoverage(app)
    % Display max
    m_idx = app.MaxNumOfSats(1, app.CurrIdx);
    updateData(app.MaxSatellitesTextArea, app.LatitudeMaxTextArea, app.LongitudeMaxTextArea, app.MaxNumOfSats(2, app.CurrIdx), app.GroundPoints(m_idx, 1), app.GroundPoints(m_idx, 2));

    % Display min
    m_idx = app.MinNumOfSats(1, app.CurrIdx);
    updateData(app.MinSatellitesTextArea, app.LatitudeMinTextArea, app.LongitudeMinTextArea, app.MinNumOfSats(2, app.CurrIdx), app.GroundPoints(m_idx, 1), app.GroundPoints(m_idx, 2));

    % Display mean
    app.MeanSatellitesTextArea.Value = string(app.MeanNumOfSats(app.CurrIdx));
    
    displayHeatmap(app.MaxVisibleSats, app.GroundPoints, app.CurrIdx, app.UIAxes, "turbo");
    app.DateandTimeTextArea.Value = string(app.CurrTime);
end