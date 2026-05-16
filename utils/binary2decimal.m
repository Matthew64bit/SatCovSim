function number = binary2decimal(bin_arr)
    mult_arr = uint8([8,4,2,1]);
    number = uint8(sum(bin_arr .* mult_arr, 2));
end