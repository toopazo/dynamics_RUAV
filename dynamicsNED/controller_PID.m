function...
     [...
        delta       , ... % cmd_throttle 
        yPID          ... % PID additional output
    ] = controller_PID(...
        t           , ... % time
        x           , ... % vehicle state
        xcmd        , ... % commanded vehicle state
        vehicle_st  , ... % vehicle parameters
        medium_st     ... % medium parameters
    )
    
    controller_st = vehicle_st.controller;
    
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
    % Input vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    % Commanded linear velocity expressed in ned coord
    velcmd = [xcmd(1); xcmd(2); xcmd(3)];   % 3 x 1
    % Commanded yaw angle
    yawcmd = [xcmd(4)];                     % 1 x 1
    
    % xcmd = [velcmd; yawcmd];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Controller
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    RPY = math_quat2angles(q_frd_ned);    
    vel = v_ned_bcm_ned;
    PQR = w_frd_bcm_ned;

    % vel loop
    velerr = velcmd - vel;
    acmd_ned  = controller_PID_vel(t, velerr, controller_st);
    
    % ref attitude
    yawcmd = yawcmd; 
    [RPYcmd, acmd_frd] = controller_ref_attitude(...
        t               , ... % time
        acmd_ned        , ... % commanded acceleration in ned
        q_frd_ned       , ... % quaternion for R_frd_ned rotation
        yawcmd          , ... % commanded yaw
        controller_st   , ...
        medium_st         ...
        );        
    
    % sp = RPYcmd;
    % val = RPY;
    % err = math_angles_wrap(sp, val);
    % RPYerr = err;
    RPYerr = RPYcmd - RPY;
    
    % angle loop
    PQRcmd  = controller_PID_ang(t, RPYerr, controller_st);
    
    % angVel loop
    PQRerr = PQRcmd - PQR;
    cmd_angAccel = controller_PID_angVel(t, PQRerr, controller_st);
    
    % Mixer
    cmd_ad_frd = acmd_frd(3);
    cmd_throttle = controller_mixer(...
        cmd_ad_frd      , ...
        cmd_angAccel     , ...
        controller_st     ...
        );      
    delta = cmd_throttle; 
    
    % Additional output info
%    yPID = [...
%        velcmd          ; ...
%        vel             ; ...
%        RPYcmd          ; ...
%        RPY             ; ...
%        PQRcmd          ; ...
%        PQR             ; ...
%        cmd_angAccel    ; ...
%        delta             ...
%    ];
    yPID.velcmd         = velcmd;
    yPID.vel            = vel;
    yPID.RPYcmd         = RPYcmd;
    yPID.RPY            = RPY;
    yPID.PQRcmd         = PQRcmd;
    yPID.PQR            = PQR;
    yPID.cmd_ad_frd     = cmd_ad_frd;
    yPID.cmd_angAccel   = cmd_angAccel;
    yPID.delta          = delta;

end

