function st = params_planet()

    g_magn      = 9.81;                 % m / s^2
    density     = 1.225;                % kg / m^3
    viscosity   = 1.46 * 10^(-5);       % m^2 / s
    sound_speed = 340;                  % m / s
    g_ned       = [0; 0; g_magn];       % gravity vector in ned coord
    GM          = 3986004.418 * 10^8;   % m^3 / s^2
    wE          = 7.2921150 * 10^-5;    % rad/s
    excen       =  0.08181919;          % 1
    a           = 6378137.0;            % m
    b           = 6356752.0;            % m
    
    % viscosity   = 18.27 * 10^(-6);      % [Pa s] = [kg / m s^2]
    % g_magn      = 9.80665;              % [kg m / s^2]
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    % struct
    
    st.density      = density;
    st.viscosity    = viscosity;
    st.g_magn       = g_magn;
    st.g_ned        = g_ned;
    st.sound_speed  = sound_speed;
    st.GM           = GM;
    st.wE           = wE;
    st.excen        = excen;
    st.a            = a;
    st.b            = b;
end

