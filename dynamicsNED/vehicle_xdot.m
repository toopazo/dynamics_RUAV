function ...
    [... 
        xdot        , ... % vehicle state derivative
        y             ... % vehicle output
    ] = vehicle_xdot(...
        t           , ... % time
        x           , ... % vehicle state
        u           , ... % vehicle input
        vehicle_st  , ... % vehicle parameters
        medium_st     ... % medium parameters
    )

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    mass         = vehicle_st.inertia.mass;         % mass body
    J_frd_bcm    = vehicle_st.inertia.J_frd_bcm;    % MOI body
    Jinv_frd_bcm = vehicle_st.inertia.Jinv_frd_bcm; % MOI body
        
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

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Input vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
    % Force of rotor cm (local abc) wrt frd, expressed in frd coord   
    Fnet_frd_bcm      = [ u(1:3) ];                   % 3 x 1
    Mnet_frd_bcm      = [ u(4:6) ];                   % 3 x 1
    Mrot_frd_bcm      = [ u(7:9) ];                   % 3 x 1
    
    % u = [Fnet_frd_bcm; Mnet_frd_bcm; Mrot_frd_bcm];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Aux calculations
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % Quaternion from ned to frd via a 3-2-1 rotation (yaw, ptich and roll)
    % q_frd_ned = math_quatnormalize(q_frd_ned);
    q_ned_frd = math_quatinv(q_frd_ned);
    % q_ned_frd = math_quatnormalize(q_ned_frd);
    
    % DCM( Phi=[roll, pitch, yaw] )
    % R_frd_ned = math_quat2dcm(q_frd_ned);
    % R_ned_frd = transpose(R_frd_ned); % equal to R_frd_ned^-1
    
    % Rotate from ned to frd
    % v_frd_bcm_ned = math_quatrotate(q_frd_ned, v_ned_bcm_ned);    
    % v_frd_bcm_ned = R_frd_ned * v_ned_bcm_ned;    
       
    % Total specific force in frd wrt bcm
    fnet_frd_bcm = (Fnet_frd_bcm) / mass;
    % Total moment in frd wrt bcm
    Mnet_frd_bcm = Mnet_frd_bcm;

    % An accelerometer measures accOut = fcnt_frd_bcm
    %   => accOut = a_frd_bcm_ned - g_frd
    % Total acceleration in the inertial frame = contact forces + gravity
    % a_frd_bcm_ned = fnet_frd_bcm = fcnt_frd_bcm + g_frd
    a_frd_bcm_ned = fnet_frd_bcm;
    
    % Rotate from frd to ned
    % a_ned_bcm_ned = R_ned_frd * a_frd_bcm_ned;
    a_ned_bcm_ned = math_quatrotate(q_ned_frd, a_frd_bcm_ned);
    
    % CPM_u = Cross Prod Matrix of u => CPM_u*v <==> cross(u,v)
    CPM_w_frd_bcm_ned = math_CPMw(w_frd_bcm_ned);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % System Dynamics (derivatives of the state vector)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 1) Position Eq (Navigation)
    % ned_rdot_ned_bcm_ned = C_ned_frd*v_frd_bcm_ned;
    ned_rdot_ned_bcm_ned = v_ned_bcm_ned;
    
    % 2) Euler Kinematical Eq
    % Phi_dot = H_Phi*w_frd_bcm_ned;
    quatKinMatrix = math_quatKinMatrix(w_frd_bcm_ned);
    qdot_frd_ned = 0.5 * quatKinMatrix * q_frd_ned;    
    
    % 3) Force Eq for bcm
    % frd_vdot_frd_bcm_ned = a_frd_bcm_ned - CPM_w_frd_bcm_ned * v_frd_bcm_ned;
    ned_vdot_ned_bcm_ned = a_ned_bcm_ned; 
             
    % 4) Momentum Eq for bcm (Euler Eq of motion) including omega and omegadot
    % Variables expressed in frd coordinates
    % Jb        = J_frd_bcm
    % Mnet      = Mnet_frd_bcm    
    % w         = w_frdi_bcm_ned
    % wdot      = frd_wdot_frd_bcm_ned 

    % Variables expressed in frdi coordinates
    % J         = Jroti_frdi_ricm        
    % omega     = w_frdi_ricm_frd
    % omegadot  = frdi_wdot_frdi_ricm_frd

    % Rotational dynamics
    % Mnet = ( Jb*wdot + w x Jb*w ) + ( Jr*omegadot + w x Jr*omega ) 
    % wdot  = (Jb^-1)*( Mnet - Jr*omegadot - w x (Jb*w + Jr*omega) )
    % wdot  = (Jb^-1)*( Mnet - w x Jb*w - ( Jr*omegadot + w x Jr*omega ) )
    % wdot  = (Jb^-1)*( Mnet - w x Jb*w - Mrot )
    % Mrot  = Jr*omegadot + w x Jr*omega        
    H_frd_bcm_ned = J_frd_bcm * w_frd_bcm_ned;
    frd_wdot_frd_bcm_ned = Jinv_frd_bcm * ( Mnet_frd_bcm ...
        - CPM_w_frd_bcm_ned * H_frd_bcm_ned - Mrot_frd_bcm );

    xdot = [...
        ned_rdot_ned_bcm_ned    ; ... % 3 x 1     => 1 : 3 
        qdot_frd_ned            ; ... % 4 x 1     => 4 : 7 
        ned_vdot_ned_bcm_ned    ; ... % 3 x 1     => 8 : 10 
        frd_wdot_frd_bcm_ned    ; ... % 3 x 1     => 11 : 13
        ];

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
    % Output vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%    y = [...
%        Vrel_bcm                ; ...
%        frd_wdot_frd_bcm_ned    ; ...
%        ];
    y.Vrel  = Vrel_bcm;
    y.wdot  = frd_wdot_frd_bcm_ned;
    
    % y = [Vrel_bcm; frd_wdot_frd_bcm_ned]

end

