function st = medium_titan()

    g_magn      = 1.35;                 % [m / s^2]
    density     = 5.428;                % [kg / m^3]
    viscosity   = 1.23 * 10^(-6);       % [m^2 / s]
    sound_speed = 195;                  % [m / s]
    g_ned       = [0; 0; g_magn];       % gravity vector in ned coord   
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    % struct
    
    st.density     = density;
    st.viscosity   = viscosity;
    st.g_magn      = g_magn;
    st.g_ned       = g_ned;
    st.sound_speed = sound_speed;
    
    atmospehre

end

