function handoverTotal = computeHandoverProbability(isValid)
    isValid_size = size(isValid);
    handoverTotal = zeros(isValid_size(2) - 3, isValid_size(3), "uint8");

    % Page is the ground point aka de the 3rd dimension
    for i = 1:isValid_size(2) - 3
        currentWindow = squeeze(binary2decimal(isValid(:, i:i+3, :)));
        mask_7 = currentWindow == 7;
        mask_14 = currentWindow == 14;
        mask_15 = currentWindow == 15;
        
        % Remove values not equal to 7, 14 or 15
        currentWindow(~(mask_7 | mask_14 | mask_15)) = 0;
        
        num7 = uint8(sum(currentWindow == 7));
        num14 = uint8(sum(currentWindow == 14));
        num15 = uint8(sum(currentWindow == 15));

        h_succ = (num7>0) & (num14>0); % Succesfull handover
        n_hand = num15>0;              % No handover, still conected

        isHandover = h_succ & ~n_hand;
        isConected = (~h_succ & n_hand) | (h_succ & n_hand);
        isFailure  = ~(h_succ | n_hand);

        handoverTotal(i, :) = uint8(isHandover + 2*isConected + 3*isFailure);
    end
end