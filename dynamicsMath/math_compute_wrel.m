function ...
    [...
        Vrel_bcm    , ... % Relative [Va, aoa, ssa] of the bcm wrt the wind
        Vrel_ricm     ... % Relative [Va, aoa, ssa] of the ricm wrt the wind
    ] = math_compute_Vrel(...
        x               , ...   % vehicle state
        v_ned_wind_ned  , ...   % wind velocity in NED
        vehicle_st        ...   % vehicle parameters        
    )
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
    nrotors         = vehicle_st.geometry.nrotors;       % num of rotors
    R_frd_frdi      = vehicle_st.geometry.R_frd_frdi;    % Rotation matrix of rotors    
    r_frd_roti_cg   = vehicle_st.geometry.r_frd_roti_cg; % Position vector array
    
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
    % Model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
    % Rotate to frd coordinates
    v_frd_bcm_ned = math_quatrotate(q_frd_ned, v_ned_bcm_ned);
    v_frd_wind_ned = math_quatrotate(q_frd_ned, v_ned_wind_ned);
    
    % Relative velocity of the bcm wrt Wind
    v_frd_bcm_wind = v_frd_bcm_ned - v_frd_wind_ned;
    
    v_frd = v_frd_bcm_wind;
    [...
        Va      , ... % airpseed
        aoa     , ... % angle of attack
        ssa       ... % side slip angle
    ] = math_vel2angles(...
        v_frd     ... % Relative velocity of the bcm wrt the wind
    );
    Vrel_bcm = [Va, aoa, ssa];
    
    % Relative velocity of the cm (rotors) wrt Wind
    Vrel_ricm = zeros(3, nrotors);
    for roti = 1:nrotors
        % Get rotation matrix from roti to frd
        DCM_frd_frdi = R_frd_frdi(1:3, 1:3, roti);
        % Get rotation matrix from frd to frdi
        DCM_frdi_frd = DCM_frd_frdi^(-1) ;
        % Get position of rotor_roti wrt bcm, expressed in frd coord frame
        pos_frd_roti_cg = r_frd_roti_cg(1:3, roti);
    
        % Relative velocity of the rotor wrt the wind
        v_frd_ricm_wind = v_frd_bcm_wind + cross(w_frd_bcm_ned, pos_frd_roti_cg);
        
        % Relative velocity of the rotor wrt the wind
        v_frdi_ricm_wind = DCM_frdi_frd * v_frd_ricm_wind;
        
        v_frdi = v_frdi_ricm_wind;
        [...
            Va      , ... % airpseed
            aoa     , ... % angle of attack
            ssa       ... % side slip angle
        ] = math_vel2angles(...
            v_frdi    ... % Relative velocity of the bcm wrt the wind
        );        
        Vrel_ricm(:, roti) = [Va; aoa; ssa];
    end    
end
