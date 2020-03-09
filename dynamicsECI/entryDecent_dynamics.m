function [xdot, y] = fdyn_entry_decent(t, x, u)    

    pos_x   = x(1);    
    pos_z   = x(2);
    vel_x   = x(3);
    vel_z   = x(4);
    T       = x(5);    
    
    L = u(1);
    m = u(2);
    
    % Constants and aux variables
    km              = 1000;    
    radius_earth    = 6371*km; % meters    
    u_inf   = sqrt(vel_x^2 + vel_z^2);
    beta    = atan(-vel_z/vel_x);
    % beta    = -atan2(vel_z, vel_x);
    alt  = pos_z - radius_earth;
       
    % Gravity model
    r_sep = pos_z;
    G = 6.67384*10^-11; % (m^3)/(kg s^2)
    M = 5.972*10^24;
    Fgrav = - m * (G*M)/(r_sep^2);
    
%    % International Standard Atmosphere model
%    % Ambient temperature, speed of sound, pressure, density
%    [T_inf, a_inf, P_inf, rho_inf] = atmosisa(alt); 
    
    % Horn's model
    [rho_inf, a_inf, T_inf, P_inf] = model_atmosphere(alt);    
    
    % position dynamics
    posdot_x = vel_x; 
    posdot_z = vel_z;

    % velocity dynamics
    % Fdrag       = 0.5*rho_inf*a_inf*u_inf * pi * L^2;
    % Fdrag_x     = - 0.5 * rho_inf * a_inf * vel_x * pi * L^2;
    Fdrag_x     = - 0.5 * rho_inf * abs(vel_x)*vel_x * 0.05 * pi * L^2;
    % Fdrag_z     = - 0.5 * rho_inf * a_inf * vel_z * pi * L^2;  
    Fdrag_z     = - 0.5 * rho_inf * abs(vel_z)*vel_z * 0.05 * pi * L^2;
    veldot_x    = ( Fdrag_x ) / (m); 
    veldot_z    = ( Fdrag_z + Fgrav ) / (m);  
%    veldot_x   = ( -Fdrag*sin(beta) ) / (m); 
%    veldot_z   = ( +Fdrag*cos(beta) + Fgrav ) / (m);      
    
    % theraml dynamics
    k1      = 1/10;
    c       = 1;
    Tdot = (k1*rho_inf*u_inf^3)/(c*L);
    
    xdot = [...
        posdot_x    ; ...
        posdot_z    ; ...
        veldot_x    ; ...
        veldot_z    ; ...
        Tdot          ...        
    ];    
    
    y = [...
        u_inf   ; ...    
        beta    ; ...    
        T_inf   ; ...
        a_inf   ; ...
        P_inf   ; ...
        rho_inf ; ...
        Fgrav   ; ...
        Fdrag_x ; ...
        Fdrag_z ; ...
        alt       ...
    ];    
end






