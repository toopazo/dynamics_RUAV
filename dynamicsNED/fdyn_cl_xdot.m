function ...
    [...
        xdotcl      , ... % state derivative of the closed loop system
        ycl           ... % output of the closed loop system
    ] = fdyn_cl_xdot(...
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
    %   xdotcl = dyncl(xcl, ucl)
    %   xdotcl = xdot and thus xcl = x
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
    omega = delta * 1000;    
    delta = omega;
    
    % The vehicle state derivative xdot is not used by 'firefly_ForMom_net'
    % So any argument will do
    xdot = 0;   
        
    [...
        Fnet_frd_bcm    , ...   % Fnet = Faero + Fgravity + Frotor
        Mnet_frd_bcm    , ...   % Mnet = Maero + Mgravity + Mrotor
        yForMom           ...   % ForMom Additional output
    ] = firefly_ForMom_net(...
        x           , ...   % vehicle state
        xdot        , ...   % vehicle state derivative
        delta       , ...   % actuator input
        vehicle_st  , ...   % vehicle parameters
        medium_st     ...   % medium parameters
    );    
    
    % Here we are assuming no gyroscopic effects
    Mrot_frd_bcm = [0; 0; 0];
    
    u = [Fnet_frd_bcm; Mnet_frd_bcm; Mrot_frd_bcm];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % State dynamics
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    [... 
        xdot        , ... % vehicle state derivative
        y             ... % vehicle output
    ] = fdyn_xdot(...
        t           , ... % time
        x           , ... % vehicle state
        u           , ... % vehicle input
        vehicle_st  , ... % vehicle parameters
        medium_st     ... % medium parameters
    );
        
    xdotcl = xdot;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Output vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
    ycl.yPID    = yPID;
    ycl.yForMom = yForMom;
    ycl.y       = y;

end

