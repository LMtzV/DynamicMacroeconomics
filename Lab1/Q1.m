% Dynamic macroeconomics 1  
% ITAM  
% Spring 2022
% Luis Gerardo Martínez Valdés

% Question 1: Plotting

x = linspace(-3, 3, 1000);

figure(1);
plot(x, ceil(x), '--r', x, floor(x), '-.b', x, round(x), '-g')
title('MATLAB Figures and Graphs')
xlabel('x')
ylabel('f(x)')
legend('ceil(x)', 'floor(x)', 'round(x)')
grid on

x = linspace(0, 2 * pi, 1000);

figure(2);
subplot(2, 1, 1)
plot(x, sin(x), '--r')
title('sin(x)')
axis([0, 2 * pi, -1.2, 1.2])
subplot(2, 1, 2)
plot(x, cos(x), '--b')
title('cos(x)')
axis([0, 2 * pi, -1.2, 1.2])