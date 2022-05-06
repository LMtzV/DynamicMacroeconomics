% Dynamic macroeconomics 1  
% ITAM  
% Spring 2022
% Luis Gerardo Martínez Valdés

% Question 2: Solving Equations

f = @(x) ((5 * x - 4) / (x - 1));

x = [0.75 0.87 1.02];

xsol = [];

for i = 1:length(x)
    xsol(i) = fsolve(f, x(i));
end

[x(1) xsol(1); x(2) xsol(2)]
[x(3) xsol(3)]

r=linspace(-1,1,100);
s= zeros(length(r),1);
x0=0.8; % Given Solution in Excercise
figure
fplot(f, [-1 1]);
hold on
plot(r,s,'b');
hold on
p = plot(x0,0,'o-r');
title('Non Linear Equation with MATLAB');



