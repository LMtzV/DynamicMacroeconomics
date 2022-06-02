% Trabajo Final.  Macroeconomía Dinámica I
% Luis Gerardo Martinez Valdes
% ITAM - Primavera 2022
% -----------------------------------------------------------------------------------------
clc; clear all; close all; 

% Parámetros del modelo

alpha = 0.33; % participación del capital en la producción
beta = 0.96; % factor de descuento
delta = 0.08; % tasa de depreciación del capital
sigma = 1.5; % coeficiente de aversión al riesgo
p = 200; % número de puntos de la malla
rho = 0.95; % persistencia del choque estocástico
sigma_e = 0.004; % desviación estándar de las innovaciones

%% Inciso i): Método de Tauchen

% Definimos el número de puntos de la malla del choque
q = 5; 

% Llamamos al método de Tauchen
[zeta,P] = Tauchen(rho, q, sigma_e)


P_Asym= P^10000
Proof = P_Asym * P_Asym

MarkovChain = dtmc(P);
figure(4);
graphplot(MarkovChain, 'ColorEdges', true)
title('Invariant distribution of AR(1) process')
xFix = asymptotics(MarkovChain)


%% Inciso ii): Iteración de la función de valor y Reglas de decision 
%%             Optimas

% Valores iniciales para capital y precios
K = 5;
w = 2.25;
r = 0.04;
A = 0;

% Construimos una malla de puntos para el capital (con 50 periodos)
kmalla = linspace(0,50,p)';

% Definimos una matriz para la utilidad de todos los posibles estados
% del agente joven
U1  = zeros(p,q,p);

for i=1:p          % activos de hoy
    for j=1:q      % choque de hoy (realizacion de proceso estocastico)
        for l=1:p  % activos de mañana
            c1 = max(exp(zeta(j))*w + (1+r)*kmalla(i) - kmalla(l),1e-200); % valor del consumo
            U1(i,j,l) = (c1.^(1-sigma))./(1-sigma);  % valor de la utilidad
        end
    end
end

% Definimos una matriz para la utilidad de todos los posibles estados
% del agente retirado
U2  = zeros(p,q,p);

for i=1:p          % activos de hoy
    for j=1:q      % choque de hoy (realizacion de proceso estocastico)
        for l=1:p  % activos de mañana
            c2 = max((1+r)*kmalla(i),1e-200); % valor del consumo
            U2(i,j,l) = (c2.^(1-sigma))./(1-sigma);  % valor de la utilidad
        end
    end
end

% Auxiliares para la iteración de la función de valor
V0 = zeros(p,q);
V1 = zeros(p,q);

cond_fin = 0; % condición de término
iter = 1; % inicializa el número de iteraciones
maxit = 1000; % número máximo de iteraciones
tol = 1e-5; % criterio de tolerancia

% Auxiliar para las reglas de decisión óptimas
pol  = zeros(p,q);

% Algoritmo
while (cond_fin==0 && iter<maxit)
  for i=1:p                               % activos de hoy
      for j=1:q                           % choque de hoy
          aux = zeros(p,1); % auxiliar para encontrar la utilidad máxima
          
          for l=1:p                       % activos de mañana
              aux(l) = U1(i,j,l);
              
              for m=1:q                   % choque de mañana
                  aux(l) = aux(l)+ beta*P(j,m)*U2(l,m); %Toma utilidad del
                                                        % agente retirado
              end
              
          end
          
          [V1(i,j),pol(i,j)] = max(aux); % indexación lógica para obtener el máximo
      end
  end
  
  % Criterio de convergencia
  if norm(V0-V1) < tol
      cond_fin = 1;
  end
  
  % Actualización de valores
  V0  = V1; 
  iter  = iter+1; 
end

% Calcumalos las reglas de decisión óptimas para agente joven
K_jov = zeros(p,q); % acumulación de activos de 
C_jov = zeros(p,q); % consumo

for i=1:p                                  % activos de hoy
    for j=1:q                              % choque de hoy
        K_jov(i,j) = kmalla(pol(i,j));
        C_jov(i,j) = exp(zeta(j))*w+(1+r)*kmalla(i)-K_jov(i,j);
    end
end 

figure(1)
subplot(3,1,1);
plot(kmalla,V1(:,1),'b',kmalla,V1(:,2),'r',kmalla,V1(:,3),'g',kmalla,V1(:,4),'y',kmalla,V1(:,5),'m')
legend('\zeta_1 = -0.03','\zeta_2 = -0.01','\zeta_3 = 0','\zeta_4 = 0.01','\zeta_5 = 0.03');
title('Young Agent Value Function')
xlabel('a')
ylabel('V')

subplot(3,1,2);
plot(kmalla,C_jov(:,1),'b',kmalla,C_jov(:,2),'r',kmalla,C_jov(:,3),'g',kmalla,C_jov(:,4),'y',kmalla,C_jov(:,5),'m')
legend('\zeta_1 = -0.03','\zeta_2 = -0.01','\zeta_3 = 0','\zeta_4 = 0.01','\zeta_5 = 0.03');
title('Young Agent Consumption')
xlabel('a')
ylabel('C')

subplot(3,1,3);
plot(kmalla,K_jov(:,1),'b',kmalla,K_jov(:,2),'r',kmalla,K_jov(:,3),'g',kmalla,K_jov(:,4),'y',kmalla,K_jov(:,5),'m')
title('young Agent Assets')
legend('\zeta_1 = -0.03','\zeta_2 = -0.01','\zeta_3 = 0','\zeta_4 = 0.01','\zeta_5 = 0.03');
xlabel('a')
ylabel('a''')

% Calcumalos las reglas de decisión óptimas para agente retirado
C_ret = zeros(p,q); % consumo
V_ret = zeros(p,q); %funcion valor empty

for i=1:p                                  % activos de hoy
    for j=1:q                              % choque de hoy
        K_ret(i,j) = kmalla(pol(i,j));
        C_ret(i,j) = (1+r)*kmalla(pol(i,j));
        V_ret(i,j) = (C_ret(i,j).^(1-sigma))./(1-sigma); %funcion valor
    end
end 

figure(3)
subplot(3,1,1);
plot(kmalla,V_ret(:,1),'b',kmalla,V_ret(:,2),'r',kmalla,V_ret(:,3),'g',kmalla,V_ret(:,4),'y',kmalla,V_ret(:,5),'m')
legend('\zeta_1 = -0.03','\zeta_2 = -0.01','\zeta_3 = 0','\zeta_4 = 0.01','\zeta_5 = 0.03');
title('Retired Agent Value Function')
xlabel('a')
ylabel('V')

subplot(3,1,2);
plot(kmalla,C_ret(:,1),'b',kmalla,C_ret(:,2),'r',kmalla,C_ret(:,3),'g',kmalla,C_ret(:,4),'y',kmalla,C_ret(:,5),'m')
legend('\zeta_1 = -0.03','\zeta_2 = -0.01','\zeta_3 = 0','\zeta_4 = 0.01','\zeta_5 = 0.03');
title('Retired Agent Consumption')
xlabel('a')
ylabel('C')

%% Incisos iii): Simulación de la economía
% Número de períodos a simular
T = 10000; 

% Inicialozamos los vectores
zt  = zeros(T,1);   % indicadora de los choques    
at  = zeros(T+1,1); % valores de los choques
ai = zeros(T+1,1); % indicadora de los activos
ct  = zeros(T,1);
shock = zeros(T+1,1); % valores de los choques

% Le damos valores iniciales a las variables de estado
at(1) = 0;
ai(1) = 1;
zt(1) = 3;

% Vamos a simular los choques
pi_acum = cumsum(P',1)';
for t=1:T-1
    zt(t+1)=min(find(random('unif',0,1) <= pi_acum(zt(t),:)));
end

% Calculamos los valores de las variables del modelo
for t = 1:T
        ai(t+1) = pol(ai(t),zt(t));
        at(t+1) = kmalla(ai(t+1));
        ct(t)   = C_jov(ai(t),zt(t));
        shock(t)= zeta(zt(t));
end
    
% Obtenemos la distribución invariante

% Inicializamos la matriz que almacena la distribución
F = zeros(p,q);

% Auxiliar que indica el estado de la economía
state = zeros(p,q); 

for i=1:p % número de puntos en la malla de activos
    for j=1:q % número de puntos en la malla del choque
        for t=1001:10000 % no considera las primeras 1000 observaciones
            if ai(t)==i && zt(t)==j
                state(i,j) = state(i,j)+1; % aumenta la frecuencia de esa entrada
            end
        end
        F(i,j) = state(i,j)/9000; % divide los estados entre número de observaciones para obtener la distribución
    end
end

% Graficamos la distribución acumulativa para cada valor del choque
F = cumsum(F) ./ sum(F);

figure(2)
subplot(3,2,1);
plot(kmalla,F(:,1))
xlim([-1 10])
ylim([0 2])
title('\zeta_1 = -0.03')
xlabel('a');

subplot(3,2,2);
plot(kmalla,F(:,2))
xlim([-1 10])
ylim([0 2])
title('\zeta_2 = -0.01')
xlabel('a');

subplot(3,2,3);
plot(kmalla,F(:,3))
xlim([-1 10])
ylim([0 2])
title('\zeta_3 = 0')
xlabel('a');

subplot(3,2,4);
plot(kmalla,F(:,4))
xlim([-1 10])
ylim([0 2])
title('\zeta_4 = 0.01')
xlabel('a');

subplot(3,2,5);
plot(kmalla,F(:,5))
xlim([-1 10])
ylim([0 2])
title('\zeta_5 = 0.03')
xlabel('a');