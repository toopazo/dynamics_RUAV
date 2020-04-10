function ...
    [...
        xcldot      , ... % state derivative of the closed loop system
        ycl           ... % output of the closed loop system
    ] = clsys_xdot_v1(...
        t           , ... % time
        xcl         , ... % state of the closed loop system
        ucl         , ... % input of the closed loop system
        vehicle_st  , ... % vehicle parameters
        medium_st     ... % medium parameters
    )
        
    % Closed loop dynamics
    %   xdot  = dynamics(x, u)
    %   u     = actuator(x, delta)
    %   delta = controller(x, xcmd)
    % Therefore
    %   xcldot = dyncl(xcl, ucl)
    %   xcldot = xdot and thus xcl = x
    %   ucl    = xcmd
    x       = xcl;
    xcmd    = ucl;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Controller
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
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
    % Actuator
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    
    % TODO Here, we ignore ESC and motors and assume that cmd_throttle 
    % translate into an instantaneous RPM. 
    % This can be better modeled by a proper ESC+motor response, but we would 
    % have to add omega as part of xcl
    % Another alternative is an approximated 2nd order transfer function        
    % But for now, let us just assume a perfect actuator
    % Here, a cmd_throttle of 1.0 is translated into a 1000 RPM
    omega = delta * 1500;    
    delta = omega;
    % TODO See toopazo_dynamics_RUAV.pdf to know what Mrot is
    % For a rotor with no tilt wrt the vehicle 
%    Mrot = [...
%        +Q * Irot_z * sum{ omegai } ; ...
%        -P * Irot_z * sum{ omegai } ; ...
%        Irot_z * sum{ omegaidot }     ...
%    ]
%    and 
%    Irot_z*sum{ omegaidot } = ...
%       sum{Qmotori} + sum{Qi} - N*Rdot - N*(Irot_y - Irot_x )*P*Q
    Mrot_frd_bcm = [0; 0; 0];     
        
    [...
        Fnet_frd_bcm    , ...   % Fnet = Faero + Fgravity + Frotor
        Mnet_frd_bcm    , ...   % Mnet = Maero + Mgravity + Mrotor
        yForMom           ...   % ForMom Additional output
    ] = firefly_ForMom_net(...
        x           , ...   % vehicle state
        delta       , ...   % actuator input
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
        
    xcldot = xdot;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Output vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
    ycl.yPID    = yPID;
    ycl.yForMom = yForMom;
    ycl.y       = y;

    % t
    % w = x(11)
    % wcl = xcl(11)
    % wdot = xdot(11)
    % wdotcl = xcldot(11)
%    u(4:6)
%    Mnet_frd_bcm
%    w = x(11:13)
%    wdot = xdot(11:13)
%    y.wdot
    % xcldot(11:13) = [1; 0; 0];
end
