function myArea = aproximateArea(borders, origin, rezolution)
    borders_cart = deg2cart(borders, origin);
    A = [min(borders_cart(:, 1)), max(borders_cart(:, 2))];
    C = [max(borders_cart(:, 1)), min(borders_cart(:, 2))];
    
    myArea_cart = devideArea(A, C, rezolution);
    myArea_cart = computeValidPoints(borders_cart, myArea_cart);
    
    myArea = cart2deg(myArea_cart, origin);
end