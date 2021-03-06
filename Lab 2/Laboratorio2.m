% Lab 2.  Macroeconom?a Din?mica I
% Luis Martinez Valdes
% ITAM - Primavera 2022
% -----------------------------------------------------------------------------------------
clc; clear all; close all;

% Par?metros del modelo:

beta = 0.99; % factor de descuento
A = 1; % productividad total de los factores
alpha = 0.35; % participaci?n del capital en la producci?n
delta = 0.06; % tasa de depreciaci?n del capital
theta = [0.8, 1, 1.2]; % valores que puede tomar el choque

% Matriz de transici?n

PI = [0.5, 0.3, 0.2;
    0.1, 0.7, 0.2;
    0.1, 0.4, 0.5];

%% Inciso i): calculando la distribuci?n asint?tica

PI_asymp = PI^100000

% Comprobaci?n

Comprobacion= PI_asymp*PI_asymp

MarkovChain = dtmc(PI);
figure(3);
graphplot(MarkovChain, 'ColorEdges', true)
xFix = asymptotics(MarkovChain)

%% Inciso ii): iteraci?n de la funci?n de valor

% Hallamos el capital de estado estacionario sin incertidumbre

kss = ((1/(alpha))*((1/beta) - (1-delta)))^(1/(alpha-1));

% N?mero de puntos de la malla

p = 500;

kgrid = linspace(0.5*kss,1.5*kss,p);

q = 3; % Auxiliar. N?mero de valores que puede tomar el choque

% Empezamos construir la matriz M 
% M guarda la funcion de retorno para cada combinacion (Ki, Kj, Zk)

% Auxiliar para la utilidad del consumo
aux1 = theta'*(A*(kgrid.^alpha)) + (1-delta)*ones(q,1)*kgrid;
aux1 = aux1(:); % convierte a la matriz aux1 en un vector columna de dimension (pxq)x1
aux1 = aux1*ones(1,p); % (pxq)xp

% Definimos la matriz M de tamano (pxq)xp

M = aux1 - ones(p*q,1)*kgrid;

% Usamos indexaci?n logica para eliminar las combinaciones que no cumplen
% con la condici?n de factibilidad

M(M<0) = 0;
M = log(M);

% Definimos una matriz identidad auxiliar

Iq = eye(q); 

% Generamos la matriz E

E = [];

% Ahora concatenamos las matrices identidad para tener una sola matrix
% auxiliar de dimensi?n (pxq)xq

for i = 1:p
    E = [E;Iq]; 
end

% Definimos dos vectores para la iteraci?n de la funcion de valor

V0 = zeros(p*q,1); 
V1 = zeros(p*q,1);

% Otros parametros importantes

crit = 1e-3; % criterio de tolerancia

% Inicializamos la distancia en un numero arbitrario para el inicio del
% algoritmo

dis = 10;

% Algoritmo de iteraci?n de la funci?n de valor

while dis>crit % condici?n de paro
    [V1,G] = max(M + beta*(E*(PI*reshape(V0,q,p))) ,[],2); % max renglones
    dis = norm(V1-V0); % calcula la distancia 
    V0 = V1;
end

% El algoritmo obtiene una aproximaci?n a la funci?n de valor para cada
% combinaci?n de estados

% Ahora es ?til usar el comando reshape para tener una representacion m?s
% sencilla de las reglas de decisi?n y de la funci?n de valor para cada uno
% de los cinco valores del choque. Pasamos de matrices de 1500x1 a 3x500

G = reshape(G,q,p);
V1 = reshape(V1,q,p);

% Construimos las reglas de decisi?n para las otras variables 3x500

K = ones(q,p); % capital
C = ones(q,p); % consumo

% Obtenemos las reglas de decisi?n ?ptimas

for i = 1:q    
    K(i,:) = kgrid(G(i,:)); 
    C(i,:) = theta(i)*A*(kgrid.^alpha)+(1-delta)*kgrid-kgrid(G(i,:));
end

% Capital

figure(1)
subplot(3,1,1);
plot(kgrid,K(1,:),'b',kgrid,K(2,:),'r',kgrid,K(3,:),'g')
legend('\theta_1','\theta_2','\theta_3');
title('Capital')
xlabel('K')
ylabel('K''')

% Funci?n valor

subplot(3,1,2);
plot(kgrid,V1(1,:),'b',kgrid,V1(2,:),'r',kgrid,V1(3,:),'g')
legend('\theta_1','\theta_2','\theta_3');
title('Value Function')
xlabel('K')
ylabel('V')

% Consumo

subplot(3,1,3);
plot(kgrid,C(1,:),'b',kgrid,C(2,:),'r',kgrid,C(3,:),'g')
legend('\theta_1','\theta_2','\theta_3');
title('Consumption')
xlabel('K')
ylabel('C')

%%--------------------------------------------------------------

%% Inciso iii): simulaci?n de trayectorias ?ptimas

T = 50; % n?mero de periodos a simular

% Generamos los shocks utilizando la funcion markov.m

shocks = markov(theta,PI,[0,1,0],T+1); % hasta T+1 para obtener iT

k0 = 100*kss; % la econom?a inicia en su estado estacionario

% Como la malla puede no contener el valor exacto de kss, buscamos el valor 
% m?s cercano

k0 = max(kgrid(kgrid<=k0));

% Definimos los vectores para las variables

kt = zeros(T+1,1); % capital
ct = zeros(T,1); % consumo

kt(1) = k0; % el primer elemento de kt es k0

% Obtenemos las reglas de decisi?n ?ptimas para las variables durante todos
% los periodos, dados los valores del choque

for t=1:T
    kt(t+1) = K(shocks(t) == theta, kgrid == kt(t));
    ct(t) = C(shocks(t) == theta, kgrid == kt(t)); 
end

% Una vez obtenidas las reglas de decisi?n anteriores, construimos las
% trayectorias de las otras variables

zt = shocks(1:T)'; % productividad
it = zeros(T,1); % inversi?n
yt = zeros(T,1); % producto
wt = zeros(T,1); % salario
rt = zeros(T,1); % tasa de inter?s

for t=1:T
    yt(t) = shocks(t)*A*(kt(t)^alpha);
    it(t) = kt(t+1)-(1-delta)*kt(t);
    wt(t) = (1-alpha)*shocks(t)*A*(kt(t)^alpha);
    rt(t) = alpha*A*shocks(t)*kt(t)^(alpha-1);
end

% Graficamos

figure(2)
subplot(4,2,1)
plot(1:T,zt(1:T))
title('(a) Tech Shock')

subplot(4,2,2)
plot(1:T,kt(1:T))
title('(b) Capital')

subplot(4,2,3)
plot(1:T,yt)
title('(c) Production')

subplot(4,2,4)
plot(1:T,ct)
title('(d) Consumption')

subplot(4,2,5)
plot(1:T,it)
title('(e) Investment')

subplot(4,2,6)
plot(1:T,wt)
title('(f) Wages')

subplot(4,2,7)
plot(1:T,rt)
title('(g) Interest rate')

%% Inciso iv): estad?sticas de ciclos econ?micos

T = 500; % n?mero de periodos

% Repetimos el mismo procedimiento del inciso anterior

shocks = markov(theta,PI,[0,1,0],T+1); 
k0 = kss;
k0 = max(kgrid(kgrid<=k0));
kt = zeros(T+1,1); 
kt(1) = k0; 
ct = zeros(T,1); 

for t=1:T
    kt(t+1) = K(shocks(t) == theta, kgrid == kt(t));
    ct(t) = C(shocks(t) == theta, kgrid == kt(t)); 
end

it = zeros(T,1); % inversi?n
yt = zeros(T,1); % producto
wt = zeros(T,1); % salario
rt = zeros(T,1); % tasa de inter?s

for t=1:T
    yt(t) = shocks(t)*A*(kt(t)^alpha);
    it(t) = kt(t+1)-(1-delta)*kt(t);
    wt(t) = (1-alpha)*shocks(t)*A*(kt(t)^alpha);
    rt(t) = alpha*A*shocks(t)*kt(t)^(alpha-1);
end

% Obtenemos los logaritmos de cada una de las variables

logyt = log(yt);
logct = log(ct);
logit = log(it);
logwt = log(wt);
logrt = log(rt);

% Eliminamos las primeras 100 observaciones

T1 = 101;

% Obtengo las desviaciones estandar de las variables

yt_std = std(logyt(T1:T));
ct_std = std(logct(T1:T));
it_std = std(logit(T1:T));
wt_std = std(logwt(T1:T));
rt_std = std(logrt(T1:T));

% Calculamos las correlaciones entre variables

ct_yt_corr = corr(logyt(T1:T),logct(T1:T));
it_yt_corr = corr(logyt(T1:T),logit(T1:T));
wt_yt_corr = corr(logyt(T1:T),logwt(T1:T));
rt_yt_corr = corr(logyt(T1:T),logrt(T1:T));

% Tabla con estadisticas de ciclos economicos

disp(' ')
disp('Volatilities:' )
disp(' ')

disp(['- Production     = ',num2str(yt_std)])
disp(['- Consumption      = ',num2str(ct_std)])
disp(['- Inverstment    = ',num2str(it_std)])
disp(['- Wages      = ',num2str(wt_std)])
disp(['- Interest Rates = ',num2str(rt_std)])

disp(' ')
disp('Correlation of production with respect to: ')
disp(' ')
disp(['- Consumption       = ',num2str(ct_yt_corr)])
disp(['- Inverstment     = ',num2str(it_yt_corr)])
disp(['- Wages       = ',num2str(wt_yt_corr)])
disp(['- Interest rates = ',num2str(rt_yt_corr)])
disp(' ')
