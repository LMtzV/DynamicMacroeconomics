% Lab 2.  Macroeconom�a Din�mica I
% Marco Alejandro Medina
% ITAM - Primavera 2022
% -----------------------------------------------------------------------------------------

% Par�metros del proceso AR(1)

rho = 0.9; % persistencia
sigmae = 0.0015; % desviaci�n est�ndar de la innovaci�n
N = 5; % n�mero de valores que tendr� el proceso discreto

% Llamamos a la funci�n que implementa el m�todo de Tauchen

[grid,P] = Tauchen(rho,N,sigmae);

% Obtenemos los valores discretos del choque

Z = grid'

% Obtenemos la matriz de transici�n

P