function [u] = dynamicsECI_input(t, x, body_st, planet_st)    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % State vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    [...
        r_eci_bcm_eci   , ...
        q_frd_eci       , ...
        v_frd_bcm_ecef  , ...
        w_frd_frd_eci     ...
    ] = dynamicsECI_unpack_state(x);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Aerodynamic model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
    % ECI to ECEF rotation matrix
    R_ecef_eci = math_R_ecef_eci(t);
    R_eci_ecef = transpose(R_ecef_eci);
    
    % ECI to ECEF position
    r_ecef_bcm_eci = R_ecef_eci*r_eci_bcm_eci;
    
    % Convert Earth-centered Earth-fixed (ECEF) coordinates to geodetic coordinates
    % ECEF coordinates, p, to geodetic coordinates (latitude, longitude and altitude), lla.
    % lla is in [degrees degrees meters]. 
    % p is in meters
    latlonalt = ecef2lla(transpose(r_ecef_bcm_eci));
    latlonalt = transpose(latlonalt);
    
    % geodetic height
    alt       = latlonalt(3);
    
    % Horn's model
    [rho_inf, a_inf, T_inf, P_inf] = model_atmosphere(alt);   

    % Mass
    mass = body_st.bdy.mass;
    % Airspeed
    v_norm = norm(v_frd_bcm_ecef);
    % Mach number
    M = v_norm/a_inf;
    % Coeff of drag
    Cd = model_body_Cd(M);
    % Reference surface
    S = body_st.bdy.S;
    Fdrag = (-0.5*rho_inf*S*Cd*v_norm) * v_frd_bcm_ecef;
    
    Fthrust = [0; 0; 0];
    
    Fnet_frd_bcm = Fdrag + Fthrust;
    Mnet_frd_bcm = [0; 0; 0];
   
    u = [Fnet_frd_bcm; Mnet_frd_bcm];   
end






