function Pr = computeLoss(P, d, f, weather)
    % d in km and f in GHz
    L = 92.4 + 20*log10(d) + 20*log10(f);
    switch weather
        case "clear"
            Pr = P-L;
        case "rain"
            Pr = P-L-6;
        case "storm"
            Pr = P-L-15;
    end
end