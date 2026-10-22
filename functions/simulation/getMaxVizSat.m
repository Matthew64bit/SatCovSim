function [visibleSats, isVisible] = getMaxVizSat(pos, validPoints, f, weather, getPower)
arguments 
    pos;
    validPoints;
    f;
    weather;
    getPower = false; 
end

    [maxViewDistance, ~] = computeMaxDist3GPP(pos(3, :, :)/1000, f); % kilometers
    
    distToCompare = permute(computeDistance(validPoints, pos),[2 3 1]);

    isVisible = distToCompare <= maxViewDistance; %% Return here for handover
    if getPower
        distToCompare(~isVisible) = inf;
        visibleSats = permute(int16(squeeze(max(computeLoss(70, distToCompare, f, weather), [], 2))), [2, 1]);
    else
        visibleSats = uint16(sum(isVisible, 2));
        visibleSats = squeeze(visibleSats);

        visibleSats_permuted = permute(visibleSats, [2, 1]);
        visibleSats = visibleSats_permuted;
        visibleSats = uint16(visibleSats);
    end
end