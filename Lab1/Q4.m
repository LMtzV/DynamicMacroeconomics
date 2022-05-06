% Dynamic macroeconomics 1  
% ITAM  
% Spring 2022
% Luis Gerardo Martínez Valdés

% Question 4: Recursive Neoclassical Growth Model


global alpha beta delta A k0

k0 = 2 * kss / 3;

initC = repelem(css, T)';
initK = repelem(kss, T - 1)';
init = [initC; initK];

transition_solution = fsolve(@(x) transition_fn(x), init);

c = transition_solution(1:T);
k = [k0; transition_solution((T + 1):(2 * T - 1))];
y = A .* k .^ alpha;
w = (1 - alpha) .* y;
r = (alpha ./ k) .* y;

figure(4)

subplot(3,2,1)
plot(1:T, k);
title('Capital')
xlabel('t')
ylabel('k_t')

subplot(3,2,2)
plot(1:T, c);
title('Consumption')
xlabel('t')
ylabel('c_t')

subplot(3,2,3)
plot(1:T, y);
title('Production')
xlabel('t')
ylabel('y_t')

subplot(3,2,4)
plot(1:T, w);
title('Real wage')
xlabel('t')
ylabel('w_t')

subplot(3,2,5)
plot(1:T, r);
title('Interest rate')
xlabel('t')
ylabel('r_t')

d = 1; % distance
it = 500; % iterations
p = 500; % equidistant points
temp = ones(1, p); % auxiliar
tol = 1e-5; % tolerance
t = 1; % counter

k = linspace(0.5 * kss, 1.2 * kss, p); % grid of capital
c = A .* (k' * temp) .^ (alpha) + (1 - delta) .* (k' * temp) - temp' * k; % grid of consumption
c(c < 0) = 0; % feasibility condition
utility = log(c);

% iterative vectors
todayV = zeros(p, 1); 
tomorrowV = zeros(p, 1);

while d > tol
    todayV = tomorrowV;
    [tomorrowV, argmax] = max(utility + beta * (todayV * temp)', [], 2);
    d = norm(tomorrowV - todayV);

    t = t + 1;
end

figure(5)
plot(k, tomorrowV)
title('Value function')
xlabel('K')
ylabel('V(K)')

figure(6)
plot(k, k(argmax))
title('Optimal decision rule')
xlabel('K')
ylabel('K^\prime')