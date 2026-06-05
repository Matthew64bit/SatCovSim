function [visibleSats, isVisible] = getMaxVizSat(pos, validPoints, f, weather)
    [d, Pr] = computeMaxDist(pos(3, :, :)/1000, f, weather);
    maxViewDistance = d; % kilometers

    c1 = haversine(pos, validPoints); %% TimePoints x Satellites x GroundPoints - kilometers
    c2 = mean(pos(3, :, :)./1000 - 0.4, "all"); % kilometers
    distToCompare = sqrt(c1.^2 + c2.^2);
    clear c1 c2;
    
    isVisible = distToCompare <= maxViewDistance; %% Return here for handover
    visibleSats = uint16(sum(isVisible, 2));
    visibleSats = squeeze(visibleSats);
    
    visibleSats_permuted = permute(visibleSats, [2, 1]);
    visibleSats = visibleSats_permuted;
    visibleSats = uint16(visibleSats);
end