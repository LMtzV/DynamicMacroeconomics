%Luis Martinez Valdes

function [F] = transition_fn(x)
    global alpha beta delta A k0 T
    c = x(1:T);
    k = x((T + 1):(2 * T - 1));

    fe = ones(T - 1, 1);
    ff = ones(T, 1);

    for t = 1:(T - 1)
        fe(t) = beta * (c(t) / c(t + 1)) * ((alpha * A * k(t) ^ (alpha - 1)) + (1 - delta)) - 1;
    end

    ff(1) = (A * k0 ^ alpha) + ((1 - delta) * k0) - k(1) - c(1);
    for t = 2:(T - 1)
        ff(t) = (A * k(t - 1) ^ alpha) + ((1 - delta) * k(t - 1)) - c(t) - k(t);
    end
    ff(T) = (A * k(T - 1) ^ alpha) - (delta * k(T - 1)) - c(T);

    F = [ff; fe];
end