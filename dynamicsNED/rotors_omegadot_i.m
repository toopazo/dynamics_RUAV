function ...
    [...
        omegaidot      ... % rotors state derivative
    ] = rotors_omegaidot(...
        Qmotori         , ...
        Qaeroi          , ...
        Qmotornet       , ...
        w_frd_bcm_ned   , ... % AngVel of vehicle bcm wrt ned, in frd coord
        vehicle_st      , ... % rotors parameters
        medium_st         ... % medium parameters
    )    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    nrotors         = vehicle_st.geometry.nrotors;
    R_frd_frdi      = vehicle_st.geometry.R_frd_frdi;
    Jroti_frdi_ricm = vehicle_st.geometry.Jroti_frdi_ricm;
    J_frd_bcm       = vehicle_st.inertia.J_frd_bcm;    % MOI body
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % State vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Third componenet of the AngVel of rotor ricm wrt frd, in frdi coord
    omega   = x;                                % nrotors x 1
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Input vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    Qnet    = [ u(1:nrotors) ];                 % nrotors x 1
    Mbdyi   = [ u((1+nrotors):(2*nrotors)) ];   % nrotors x 1    
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % State dynamics
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    
    % From toopazo_dynamics_RUAV.pdf 
    %   assumning no rotor tilt wrt vehicle
    %   diagonal MOIs
    
    P = w_frd_bcm_ned(1);
    Q = w_frd_bcm_ned(2);
    R = w_frd_bcm_ned(3);
    
    N = nrotors;
    roti = 1;
    Jrot1 = Jroti_frdi_ricm(1:3, 1:3, roti);
    Jrot_z = Jrot1(3, 3);
    
    Jbdy_x = J_frd_bcm(1, 1);
    Jbdy_y = J_frd_bcm(2, 2);
    Jbdy_z = J_frd_bcm(3, 3);
    
    k1 = (Jrot_z)/(Jbdy_z-N*Jrot_z);
    k2 = (Jbdy_y-Jbdy_x)*k1 - N*(Jbdy_y-Jbdy_x)*k1 - (Jbdy_y-Jbdy_x);
    
    omegaidot = (1/Jrot_z)*(...
        Qmotori + Qaeroi - k1*Qmotornet + k2*P*Q;
    );

end

