function L = computeLoss(d, f)
    % d in km and f in GHz
    L = 92.4 + 20*log10(d) + 20*log10(f);
end