function st = medium_earth()  

    st.g_magn           = 9.81;                 % [m / s^2]
    st.g_ned            = [0; 0; st.g_magn];    % gravity vector in ned coord   
    
    % [temperature, Vsound, pressure, density, viscosity] = ...
    %     medium_earth_atmospehre(altitude);
    st.atmospehre       = @medium_earth_atmospehre;    
end

