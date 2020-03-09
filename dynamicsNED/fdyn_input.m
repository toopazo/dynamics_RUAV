function [u] = fdyn_input(t, vehicle_st, medium_st)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Input vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    rpm2rads = (2*pi) / 60;
    rads2rpm = 60 / (2*pi);        
    
    % Position of the cm wrt ned expressed in ned coord
    r_ned_CM_ned = [0; 0; 0];           % 3 x 1
    % Quaternion for R_frd_ned rotation ( Euler Angles Phi = [phi; thta; psi] )
    yaw0    = deg2rad(0);  
    pitch0  = deg2rad(0); 
    roll0   = deg2rad(0);
    q0      = angle2quat(yaw0, pitch0, roll0);
    q_frd_ned = transpose(q0);          % 4 x 1
    % Linear Velocity of the CM (frd origin) wrt ned, expressed in ned coord
    v_ned_CM_ned = [0; 0; 0];           % 3 x 1
    % Angular Velocity of frd wrt ned expressed in frd coord
    w_frd_frd_ned = [0; 0; 0];          % 3 x 1
    % Initial condition
    x = [r_ned_CM_ned; q_frd_ned; v_ned_CM_ned; w_frd_frd_ned];      

    % state derivative
    xdot = x*0;      % Here we are assuming no ForMom dependance on xdot
    
    % omega = 2500 * rpm2rads * ones(vehicle_st.geometry.nrotors, 1);
    omega = 437.9183 * ones(vehicle_st.geometry.nrotors, 1);    % hover omega
    delta = omega;
    
    [...
        Fnet_frd_bcm    , ...   % Fnet = Faero + Fgravity + Frotor
        Mnet_frd_bcm    , ...   % Mnet = Maero + Mgravity + Mrotor
        yForMom           ...   % additional output
    ] = firefly_ForMom_net(...
        x           , ...   % vehicle state
        xdot        , ...   % vehicle state derivative
        delta       , ...   % actuator input
        vehicle_st  , ...   % vehicle parameters
        medium_st     ...   % medium parameters
    );
    
    Mrot_frd_bcm = [0; 0; 0];
    
    u = [Fnet_frd_bcm; Mnet_frd_bcm; Mrot_frd_bcm];
end
