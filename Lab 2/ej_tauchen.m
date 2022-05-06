% Lab 2.  Macroeconomía Dinámica I
% Marco Alejandro Medina
% ITAM - Primavera 2022
% -----------------------------------------------------------------------------------------

% Parámetros del proceso AR(1)

rho = 0.9; % persistencia
sigmae = 0.0015; % desviación estándar de la innovación
N = 5; % número de valores que tendrá el proceso discreto

% Llamamos a la función que implementa el método de Tauchen

[grid,P] = Tauchen(rho,N,sigmae);

% Obtenemos los valores discretos del choque

Z = grid'

% Obtenemos la matriz de transición

P