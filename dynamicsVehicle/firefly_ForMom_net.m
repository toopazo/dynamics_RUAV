function ...
    [...
        Fnet_frd_bcm    , ...   % Fnet = Faero + Fgravity + Frotor
        Mnet_frd_bcm    , ...   % Mnet = Maero + Mgravity + Mrotor
        yForMom           ...   % Additional output
    ] = firefly_ForMom_net(...
        x           , ...   % vehicle state
        xdot        , ...   % vehicle state derivative
        delta       , ...   % actuator input
        vehicle_st  , ...   % vehicle parameters
        medium_st     ...   % medium parameters
    )
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    nrotors = vehicle_st.geometry.nrotors;
    
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
    
    % x = [r_ned_bcm_ned; q_frd_ned; v_ned_bcm_ned; w_frd_bcm_ned];
    
    altitude = 0;%- r_ned_bcm_ned(3);
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Relative wind model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    v_ned_wind_ned = [0; 0; 0];
    [...
        Vrel_bcm    , ... % Relative [Va, aoa, ssa] of the bcm wrt the wind
        Vrel_ricm     ... % Relative [Va, aoa, ssa] of the ricm wrt the wind
    ] = math_compute_Vrel(...
        x               , ...   % vehicle state
        v_ned_wind_ned  , ...   % wind velocity in NED
        vehicle_st        ...   % vehicle parameters        
    );
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Rotor model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
    Trotor = zeros(nrotors, 1);
    Qrotor = zeros(nrotors, 1);
    Protor = zeros(nrotors, 1);    
    for roti = 1:nrotors
        omega = delta(roti);  
        Vrel = Vrel_ricm(:, roti);
        signi = firefly_rotors_spin_direction(roti);
        
        [...
            T  , ... % rotor thrust  
            Q  , ... % rotor torque (due to drag)
            P    ... % rotor power
        ] = firefly_rotor_TQP(...
            omega   , ... % AngVel of frdi wrt frd, expressed in frdi coord
            Vrel      ... % Relative [Va, aoa, ssa] of the rotor wrt the wind
        );
        
        Trotor(roti) = T;
        Qrotor(roti) = -1 * signi * Q; % Qrotor = Qaero oposses the spin direction
        Protor(roti) = P;
    end 
    
    % ForMom produced by rotor thrust and rotor torque (due to drag)
    [...
        Frotor_frd_bcm  , ... % Force produced by rotors about the bcm
        Mrotor_frd_bcm    ... % Torque produced by rotors about the bcm
    ] = math_ForMom_rotors(...
        Trotor      , ...   % rotor thrust
        Qrotor      , ...   % rotot torque (due to drag)
        vehicle_st    ...   % vehicle parameters
    );

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Gravity model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    [...
        Fgrav_frd_bcm    , ... % Gravity Force
        Mgrav_frd_bcm      ... % Gravity Moment
    ] = math_ForMom_gravity(...
        q_frd_ned   , ...   % Quaternion for R_frd_ned rotation
        vehicle_st  , ...   % vehicle parameters
        medium_st     ...   % medium parameters
    );
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Body aerodynamic model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
    [...
        Faero_frd_bcm    , ... % Aerodynamic Force
        Maero_frd_bcm      ... % Aerodynamic Moment
    ] = math_ForMom_aero(...
        Vrel_bcm    , ...   % Relative [Va, aoa, ssa] of the bcm wrt the wind
        altitude    , ...   % Absolute vertical position of the bcm
        vehicle_st  , ...   % vehicle parameters
        medium_st     ...   % medium parameters        
    );  
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Sumation of ForMom applied at bcm 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    Fnet_frd_bcm = Frotor_frd_bcm + Fgrav_frd_bcm + Faero_frd_bcm;    
    Mnet_frd_bcm = Mrotor_frd_bcm + Mgrav_frd_bcm + Maero_frd_bcm;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Additional output
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
%    yForMom = [...
%        Frotor_frd_bcm  ; ...
%        Mrotor_frd_bcm  ; ...
%        Fgrav_frd_bcm   ; ...
%        Mgrav_frd_bcm   ; ...        
%        Faero_frd_bcm   ; ...
%        Maero_frd_bcm     ...
%    ];
    yForMom.Frotor_frd_bcm  = Frotor_frd_bcm;
    yForMom.Mrotor_frd_bcm  = Mrotor_frd_bcm;
    yForMom.Fgrav_frd_bcm   = Fgrav_frd_bcm;
    yForMom.Mgrav_frd_bcm   = Mgrav_frd_bcm;
    yForMom.Faero_frd_bcm   = Faero_frd_bcm;
    yForMom.Maero_frd_bcm   = Maero_frd_bcm;
    yForMom.Fnet_frd_bcm    = Fnet_frd_bcm;
    yForMom.Mnet_frd_bcm    = Mnet_frd_bcm;

    % Frotor_frd_bcm
    % Fgrav_frd_bcm
    % Faero_frd_bcm
    % Fnet_frd_bcm

end

