function [rho, a, T, P] = model_atmosphere(alt)

    % Atmosphere model in SI units.  
    % Calculates air density (in kg/m^3) and speed of sound (in m/sec) as a function
    % of geodetic altitude alt (in m).  

    if (alt < 11022.)
        T = 288.2 - 0.00649*alt;
        P = 1.01258e5*(T/288.2)^5.256;
    elseif (alt<25380.)
        T = 216.7;
        P = 2.2639e4*exp(1.73-1.57e-4*alt);
    else
        T = 141.47 + 0.00299*alt;
        P = 2487.*(T/216.7)^(-11.388);
    end
    
    rho = P / (287*T);
    a = sqrt(1.4*287*T);
end

