% Steady state of the Neoclassical growth model
% With Income Tx

global alpha beta delta A T tau

alpha = 0.35;
beta = 0.99;
delta = 0.06;
A = 10;
tau= 0.25; % switch to tau= 0.25;

% equations
ss = @(css, kss) [(1 / beta) - (1-tau)*(alpha * A * kss ^ (alpha - 1)) - (1 - delta) - (tau*delta);
                  (1 - tau)*((A * kss ^ alpha) - (delta * kss)) - css ];

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