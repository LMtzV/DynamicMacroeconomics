delta = 0.06;  % depreciation rate
beta  = 0.99;  % discount factor
alpha = 0.35;  % capital elasticity of output

nbk = 20;      % # of points in K grid
nbk = 1000;    % # of points in C grid
crit =1;       
epsi = 1e-6;

ks = ((1-beta*(1-delta))/(alpha*beta))^(1/(alpha-1));

dev = 0.9;
kmin = (1-dev)*ks;
kmax = (1+dev)*ks;
kgrid = linspace(kmin,kmax,nbk); 
cmin = 0.01;
cmax = kmax^alpha;
c = linspace(cmin,cmax,nbc);
v = zeros(nbk,1);
dr = zeros(nbk,1);
util = log(c);

end
crit = max(abs(tv-v)); % Compute convergence criterion
v = tv;                % Update the value function
end

%
% Final solution
%
kp = kgrid(dr);
c = kgrid.^alpha+(1-delta)*kgrid-kp; 
y = A .* kp .^ alpha;
w = (1 - alpha) .* y;
r = (alpha ./ kp) .* y;
util= log(c);
v = util/(1-beta);