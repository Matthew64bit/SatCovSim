function handoverTotal = computeLinkStatus(isValid)
    isValid_size = size(isValid);
    handoverTotal = zeros(isValid_size(2) - 3, isValid_size(3), "uint8");

    % Page is the ground point aka de the 3rd dimension
    for i = 2:isValid_size(2) - 2
        currentWindow = squeeze(binary2decimal(isValid(:, i-1:i+2, :)));
        mask_7 = currentWindow == 7;
        mask_14 = currentWindow == 14;
        mask_15 = currentWindow == 15;
        
        % Remove values not equal to 7, 14 or 15
        currentWindow(~(mask_7 | mask_14 | mask_15)) = 0;
        clear mask_7 mask_14 mask_15;
        
        num7 = uint8(sum(currentWindow == 7));
        num14 = uint8(sum(currentWindow == 14));
        num15 = uint8(sum(currentWindow == 15));

        h_succ = (num7>0) & (num14>0); % Successful handover
        n_hand = num15>0;              % No handover, still connected
        
        clear num7 num14 num15;
        %isConnected = (~h_succ & n_hand) | (h_succ & n_hand); 1
        %isHandover = h_succ & ~n_hand; 2
        %isFailure  = ~(h_succ | n_hand); 3
        
        handoverTotal(i, :) = uint8(2*(h_succ & ~n_hand) + ...
        ((~h_succ & n_hand) | (h_succ & n_hand)) + ...
        3*(~(h_succ | n_hand)));

        % 1 - staying connect (aka no handover)
        % 2 - handover happens
        % 3 - connection is dropped
    end
end