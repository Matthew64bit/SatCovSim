function [visibleSats, isVisible] = getMaxVizSat(pos, validPoints, f, weather)
    [d, Pr] = computeMaxDist(pos(3, :, :)/1000, f, weather);
    maxViewDistance = d;
    distToCompare = haversine(pos, validPoints); %% TimePoints x Satellites x GroundPoints
    
    isVisible = distToCompare < maxViewDistance; %% Return here for handover
    visibleSats = uint8(sum(isVisible, 2));
    visibleSats = squeeze(visibleSats);
    
    visibleSats_permuted = permute(visibleSats, [2, 1]);
    visibleSats = visibleSats_permuted;
end