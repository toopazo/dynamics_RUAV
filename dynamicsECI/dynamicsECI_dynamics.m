function [xdot, y] = dynamicsECI_dynamics(t, x, u, body_st, planet_st, timestamp)    

    % Coordinate systems
    
    % ECI = inertial
    % ECEF = non inertial => w_eci_ecef_eci = [0; 0; we] = angular velicity of ECEF wrt ECI
    % NED = non inertial => w_ecef_ned_ecef = angular velicity of the local NED coordinates wrt ECEF
    % FRD = non inertial => w_frd_frd_ned = angular velicity of the body wrt NED

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    mass            = body_st.bdy.mass;             % mass body
    Jbdy_frd_bcm    = body_st.bdy.Jbdy_frd_bcm;     % MOI body
    Jbdyinv_frd_bcm = body_st.bdy.Jbdyinv_frd_bcm;  % MOI body
    wE              = planet_st.wE;                 % planet's rotation around ECI (and) ECEF z-axis
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % State vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    [...
        r_eci_bcm_eci   , ...
        q_frd_eci       , ...
        v_frd_bcm_ecef  , ...
        w_frd_frd_eci   , ...
        temp              ...
    ] = dynamicsECI_unpack_state(x);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Input vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    [...
        Fnet_frd_bcm    , ...
        Mnet_frd_bcm      ...
    ] = dynamicsECI_unpack_input(u);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Aux calculations
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % Quaternion from ned to frd via a 3-2-1 rotation (yaw, ptich and roll)
    % DCM( Phi=[roll, pitch, yaw] )
    R_frd_eci = math_quat2dcm(q_frd_eci);
    R_eci_frd = transpose(R_frd_eci);  
    
    % Rotate from frd to eci
    v_eci_bcm_ecef = R_eci_frd * v_frd_bcm_ecef;          
    
    % CPM_u = Cross Prod Matrix of u => CPM_u*v <==> cross(u,v)
    CPM_w_frd_frd_eci = math_CPMw(w_frd_frd_eci);
    
    % Planet's angular velocity
    w_eci_ecef_eci = [0; 0; wE];
    CPM_w_eci_ecef_eci = math_CPMw(w_eci_ecef_eci);
    w_frd_ecef_eci = R_frd_eci*w_eci_ecef_eci;
    CPM_w_frd_ecef_eci = math_CPMw(w_frd_ecef_eci);
    
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
    
    % Planet's gravity   
    G_ecef = model_Gravitation(r_ecef_bcm_eci);
    G_eci = R_eci_ecef*G_ecef;
    
%    % This is posible only because 'G_ecef = model_Gravitation(r_ecef_bcm_eci)' is 
%    % independent of longitude. So that ECEF and ECI coordinates are 
%    % indistinguishable for 'model_Gravitation'
%    % G_ecef = model_Gravitation(r_ecef_bcm_eci);
%    G_eci = model_Gravitation(r_eci_bcm_eci);
    
    g_eci = G_eci - CPM_w_eci_ecef_eci*CPM_w_eci_ecef_eci*r_eci_bcm_eci;
    g_frd = R_frd_eci*g_eci;
    
    % Total specific force in frd wrt bcm
    fnet_frd_bcm = (Fnet_frd_bcm) / mass;
    % Total moment in frd wrt bcm
    Mnet_frd_bcm = Mnet_frd_bcm;   
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % System Dynamics (derivatives of the state vector)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 1) Position Eq (Navigation)
    % eci_rdot_eci_bcm_eci = C_ned_frd*v_eci_bcm_ecef;
    eci_rdot_eci_bcm_eci = v_eci_bcm_ecef + CPM_w_eci_ecef_eci*r_eci_bcm_eci;
    
    % 2) Euler Kinematical Eq
    % Phi_dot = H_Phi*w_frd_frd_eci;
    quatKinMatrix = math_quatKinMatrix(w_frd_frd_eci);
    qdot_frd_eci = 0.5 * quatKinMatrix * q_frd_eci;    
    
    % 3) Force Eq for bcm
    % frd_vdot_frd_bcm_ned = a_frd_bcm_ned - CPM_w_frd_frd_eci * v_eci_bcm_ecef;
    frd_vdot_frd_bcm_ecef = fnet_frd_bcm ...
        - ( CPM_w_frd_frd_eci + CPM_w_frd_ecef_eci ) * v_frd_bcm_ecef   ...
        + R_frd_eci * g_eci                                             ...
        ; 
             
    % 4) Momentum Eq for bcm (Euler Eq of motion)
    H_frd_bcm_eci = Jbdy_frd_bcm * w_frd_frd_eci;
    frd_wdot_frd_bcm_eci = Jbdyinv_frd_bcm * ( Mnet_frd_bcm ...
        - CPM_w_frd_frd_eci * H_frd_bcm_eci );
        
    % 4) Momentum Eq for bcm (Euler Eq of motion) including omega and omegadot
    % Variables expressed in frd coordinates
    % Jb        = Jbdy_frd_bcm
    % Mnet      = Mnet_frd_bcm    
    % w         = w_frdi_bcm_ned
    % wdot      = frd_wdot_frd_bcm_eci 

    % Variables expressed in frdi coordinates
    % J         = Jroti_frdi_ricm        
    % omega     = w_frdi_ricm_frd
    % omegadot  = frdi_wdot_frdi_ricm_frd

    % Rotational dynamics
    % Mnet = ( Jb*wdot + w x Jb*w ) + ( Jr*omegadot + w x Jr*omega ) 
    % wdot  = (Jb^-1)*( Mnet - Jr*omegadot - w x (Jb*w + Jr*omega) )

    % 5) Thermal equation
    k1 = 1/10;
    kB = 1.380649*10^-23;   % J / K, Boltzmann constant
    cp = 0.91;              % Specific Heat for aluminum
    % Reference surface
    S = body_st.bdy.S;
    % Airspeed
    v_norm = norm(v_frd_bcm_ecef);
    % geodetic height
    alt       = latlonalt(3);    
    % Horn's model
    [rho_inf, a_inf, T_inf, P_inf] = model_atmosphere(alt);       
    % heat transfer    
    tempdot = k1 * rho_inf * v_norm^3 / (cp*S); 

    xdot = [...
        eci_rdot_eci_bcm_eci    ; ... % 3 x 1     => 1 : 3 
        qdot_frd_eci            ; ... % 4 x 1     => 4 : 7 
        frd_vdot_frd_bcm_ecef   ; ... % 3 x 1     => 8 : 10 
        frd_wdot_frd_bcm_eci    ; ... % 3 x 1     => 11 : 13
        tempdot                   ... % 1 x 1     => 14 : 14
        ];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Output vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    y = [...
        latlonalt   ; ...
        g_frd         ...
    ];

end






