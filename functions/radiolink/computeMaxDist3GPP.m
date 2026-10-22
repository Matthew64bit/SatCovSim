function [slant_range, RSRQ_dB] = computeMaxDist3GPP(h, f)
    alfa = single(linspace(pi/2 - deg2rad(20), pi/2, 100));
    
    slant_range = h./sin(alfa)';
    [~, ~, RSRQ_dB] = computePowerMetrics(f, slant_range);

    usable = RSRQ_dB > -110;              
    slant_range_masked  = slant_range;
    slant_range_masked(~usable) = -Inf;
    RSRQ_dB_masked = RSRQ_dB;
    RSRQ_dB_masked(~usable) = Inf; 

    slant_range  = max(slant_range_masked, [], 1);   % 1x1xN
    RSRQ_dB = min(RSRQ_dB_masked, [], 1);   % 1x1xN

    % Flatten to 1xTime_Stamps
    slant_range  = squeeze(slant_range);
    RSRQ_dB = squeeze(RSRQ_dB);
    
end