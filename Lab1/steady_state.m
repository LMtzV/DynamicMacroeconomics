% Steady state of the Neoclassical growth model

global alpha beta delta A T 

alpha = 0.35;
beta = 0.99;
delta = 0.06;
A = 10;

% equations
ss = @(css, kss) [(1 / beta) - (alpha * A * kss ^ (alpha - 1)) - (1 - delta);
                  (A * kss ^ alpha) - css - (delta * kss)];

temp = @(x) ss(x(1), x(2));
guess = [100; 100];

ss_solution = fsolve(temp, guess);

% steady state
css = ss_solution(1);
kss = ss_solution(2);
yss = A * kss ^ alpha;
wss = (1 - alpha) * yss;
rss = (alpha / kss) * yss;

% time
T = 100;