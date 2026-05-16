function centers = devideArea(A, C, i)
    centers = [];
    function recurse(A_curr, C_curr, lvl)
        G = (C_curr - A_curr) / 2 + A_curr;

        if lvl == 0
            centers = [centers; G]; 
            return;
        else
            M = [G(1), A_curr(2)];
            N = [C_curr(1), G(2)];
            P = [G(1), C_curr(2)];
            Q = [A_curr(1), G(2)];

            recurse(A_curr, G, lvl - 1);
            recurse(M, N, lvl - 1);
            recurse(G, C_curr, lvl - 1);
            recurse(Q, P, lvl - 1);
        end
    end

    recurse(A, C, i);
end