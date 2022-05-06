%Luis Martinez Valdes

function [F] = transition_fn_Tx(x)
    global alpha beta delta A k0 T tau
    c = x(1:T);
    k = x((T + 1):(2 * T - 1));

    fe = ones(T - 1, 1);
    ff = ones(T, 1);

    for t = 1:(T - 1)
        fe(t) = beta * (c(t) / c(t + 1)) * ((1 - tau)*(alpha * A * k(t) ^ (alpha - 1)) + (1 - delta) + tau * delta) - 1;
    end

    ff(1) = (1 - tau) * (A * k0 ^ alpha) + ((1 - delta) * k0) + tau * delta * k0 - k(1) - c(1);
    for t = 2:(T - 1)
        ff(t) = (1 - tau) * (A * k(t - 1) ^ alpha) + ((1 - delta) * k(t - 1)) + (tau * delta * k(t-1)) - c(t) - k(t);
    end
    ff(T) = (1 - tau) * ((A * k(T - 1) ^ alpha) - (delta * k(T - 1))) - c(T);

    F = [ff; fe];
end