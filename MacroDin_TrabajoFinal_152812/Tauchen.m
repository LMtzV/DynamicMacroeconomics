function [grid,P] = Tauchen(rho,N,sigma)

% Discretiza un proceso estocástico AR(1), dados sus parámetros

% Notación:

% rho = persistencia del proceso AR(1).
% N = número de puntos en la malla discreta.
% sigma = desviación estándar de las innovaciones.

% grid = malla del AR(1) discreto.
% P = matriz de transición.

        % Construyendo la malla de valores
        sigma_z = sqrt(sigma^2/(1-rho^2)); 
        step =(2*sigma_z*3)/(N-1); % distancia entre puntos
        grid = zeros(N,1); % inicializa la malla
        for i=1:N
            grid(i) = -3*sigma_z+ (i-1)*step; % obtiene cada punto de la malla
        end
        
        % Construyendo la matriz de transición
        
        P = zeros(N,N); % inicializa la matriz P
        if N>1 
           for i=1:N
            P(i,1)=normcdf((grid(1)+step/2-rho*grid(i))/sigma); % usando la distribución normal
            P(i,N)=1-normcdf((grid(N)-step/2-rho*grid(i))/sigma);
                for j=2:N-1
                P(i,j)=normcdf((grid(j)+step/2-rho*grid(i))/sigma) ...
                    -normcdf((grid(j)-step/2-rho*grid(i))/sigma);
                end
           end
        else
            P=1;
        end
        
end