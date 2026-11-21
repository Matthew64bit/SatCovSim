function [RSRP_dBm, SINR_dB, RSRQ_dB] = computePowerMetrics(f, slant_range)
    % 3GPP TR 38.811 & TR 
    SCS_Hz = 15 * 10^3;     % Subcarrier spacing
    N_RB = 20;             % No. of resource block for 30 MHz bandwidth
    %N_RE = N_RB * 12;       % Total active Resource Blocks
    UE_Noise_Figure = 7;    % 5G UE Noise Figure in dB
    Atm_Loss_dB = 2.1;      % Atmospheric loss
    EIRP_dens = 34;         % EIRP density per MHz

    EIRP_RE_dBm = EIRP_dens - 60 + 10 * log10(SCS_Hz);
    FSPL_dB = 92.4 + 20*log10(slant_range) + 20 * log10(f);

    %% Thermal Noise
    N_th_dB = -174 + 10 * log10(SCS_Hz) + UE_Noise_Figure;
    N_th_lin = 10^(N_th_dB/10);

    %% Compute SS-RSRP
    RSRP_dBm = EIRP_RE_dBm - FSPL_dB - Atm_Loss_dB;
    RSRP_lin = 10.^(RSRP_dBm ./ 10);

    %% Compute SS-SINR == SNR
    SINR_lin = RSRP_lin ./ N_th_lin;
    SINR_dB = 10 * log10(SINR_lin);

    %% Compute SS-RSRQ
    RSSI_lin = N_RB * 12 * (RSRP_lin + N_th_lin);
    RSRQ_dB = 10 * log10((N_RB .* RSRP_lin) ./ RSSI_lin);
end