function [d, Pr] = computeMaxDist(h, f, weather)
    alfa = single(linspace(pi/2 - deg2rad(20), pi/2, 100));

    d =h./sin(alfa)';
    L = computeLoss(d, f);
    switch weather
        case "clear"
            Pr = 70-L;
        case "rain"
            Pr = 70-L-6;
        case "storm"
            Pr = 70-L-15;
    end
    usable = Pr > -110;              
    d_masked  = d;
    d_masked(~usable) = -Inf;
    Pr_masked = Pr;
    Pr_masked(~usable) = Inf; 
    
    d  = max(d_masked, [], 1);   % 1x1xN
    Pr = min(Pr_masked, [], 1);   % 1x1xN

    % Flatten to 1x100
    d  = squeeze(d);
    Pr = squeeze(Pr);
end