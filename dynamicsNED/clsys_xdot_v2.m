function ...
    [...
        xcldot      , ... % state derivative of the closed loop system
        ycl           ... % output of the closed loop system
    ] = clsys_xdot_v2(...
        t           , ... % time
        xcl         , ... % state of the closed loop system
        ucl         , ... % input of the closed loop system
        vehicle_st  , ... % vehicle parameters
        medium_st     ... % medium parameters
    )
    
    % x     = vehicle state
    x       = xcl(1:13);
    % omega = rotor state
    omega   = xcl(14:end);
            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    nrotors = vehicle_st.geometry.nrotors;    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Controller
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    xcmd = ucl;
    
    [...
        delta       , ... % cmd_throttle 
        yPID          ... % PID additional output
    ] = controller_PID(...
        t           , ... % time
        x           , ... % vehicle state
        xcmd        , ... % commanded vehicle state
        vehicle_st  , ... % vehicle parameters
        medium_st     ... % medium parameters
    );    
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % State vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Position of the bcm (frd origin) wrt ned, expressed in ned coord
    r_ned_bcm_ned = [x(1); x(2); x(3)];         % 3 x 1
    % Quaternion for R_frd_ned rotation ( Euler Angles Phi = [phi; thta; psi] )
    q_frd_ned = [x(4); x(5); x(6); x(7)];       % 4 x 1
    % Linear Velocity of the bcm (frd origin) wrt ned, expressed in ned coord
    v_ned_bcm_ned = [x(8); x(9); x(10)];        % 3 x 1
    % Angular Velocity of the bcm (frd origin) wrt ned, expressed in frd coord
    w_frd_bcm_ned = [x(11); x(12); x(13)];      % 3 x 1       
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Relative wind model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    v_ned_wind_ned = [0; 0; 0]; % TODO we assume no wind
    
    [...
        Vrel_bcm    , ... % relative [Va, aoa, ssa] of the bcm wrt the wind
        Vrel_ricm     ... % relative [Va, aoa, ssa] of the ricm wrt the wind
    ] = math_compute_Vrel(...
        x               , ...   % vehicle state
        v_ned_wind_ned  , ...   % wind velocity in NED
        vehicle_st        ...   % vehicle parameters        
    );
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Rotor thrust and torque
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    [...
        Trotor    , ...   % rotor thrust  
        Qrotor    , ...   % rotor torque (due to drag)
        Protor      ...   % rotor power
    ] = firefly_rotor_TQP(...
        omega       , ... % angVel of rotors
        Vrel_ricm   , ...   % relative [Va, aoa, ssa] of the ricm wrt the wind
        vehicle_st  , ...   % vehicle parameters
        medium_st     ...   % medium parameters
    );           
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Motor torque
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    throttle = delta;
    
    [...
        Qmotor     , ... % Motor torque
        Vmotor     , ... % voltage allowed into the motor
        Imotor       ... % current allowed into the motor
    ] = firefly_rotor_Qmotor(...
        omega       , ... % angVel of rotors
        throttle    , ... % throttle from controller
        vehicle_st  , ... % rotors parameters
        medium_st     ... % medium parameters
    );

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Rotor dynamics
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    Qnet = Qmotor + Qrotor;
    Mbdy = zeros(nrotors, 1);   % TODO we assume no dependence on vehicle's state
    u = [Qnet; Mbdy];
    
    [...
        omegadot    , ... % rotors state derivative
        yrotor        ... % rotors output
    ] = rotors_omegadot(...
        t           , ... % time
        omega       , ... % rotors state
        u           , ... % rotors input
        vehicle_st  , ... % rotors parameters
        medium_st     ... % medium parameters
    );
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Actuator
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
    Mrot_frd_bcm = [0; 0; 0];   % TODO we assume no dependence on rotor's state
    
    [...
        Fnet_frd_bcm    , ...   % Fnet = Faero + Fgravity + Frotor
        Mnet_frd_bcm    , ...   % Mnet = Maero + Mgravity + Mrotor
        yForMom           ...   % ForMom Additional output
    ] = firefly_ForMom_net(...
        x           , ...   % vehicle state
        omega       , ...   % rotor state
        vehicle_st  , ...   % vehicle parameters
        medium_st     ...   % medium parameters
    );    
     
    u = [Fnet_frd_bcm; Mnet_frd_bcm; Mrot_frd_bcm];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Vehicle dynamics
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    [... 
        xdot        , ... % vehicle state derivative
        y             ... % vehicle output
    ] = vehicle_xdot(...
        t           , ... % time
        x           , ... % vehicle state
        u           , ... % vehicle input
        vehicle_st  , ... % vehicle parameters
        medium_st     ... % medium parameters
    );
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % cl dynamics
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    xcldot = [xdot; omegadot];
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Output vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
    ycl.yPID    = yPID;
    ycl.rotor   = yrotor; 
    ycl.yForMom = yForMom;
    ycl.y       = y;
end
