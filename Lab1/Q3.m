% Dynamic macroeconomics 1  
% ITAM  
% Spring 2022
% Luis Gerardo Martínez Valdés

% Question 3: Sequential Neoclassical Growth Model

global alpha A k0 T  

k0 = kss / 2;

initC = repelem(css, T)';
initK = repelem(kss, T - 1)';
init = [initC; initK];

transition_solution = fsolve(@(x) transition_fn_Tx(x), init);

c = transition_solution(1:T);
k = [k0; transition_solution((T + 1):(2 * T - 1))];
y = A .* k .^ alpha;
w = (1 - alpha) .* y;
r = (alpha ./ k) .* y;

figure(3)

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
title('Real wage (Marginal Productivity of Labor)')
xlabel('t')
ylabel('w_t')

subplot(3,2,5)
plot(1:T, r);
title('Interest rate (Marginal Productivity of Capital)')
xlabel('t')
ylabel('r_t')
