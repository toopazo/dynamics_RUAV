function ...
    [...
        Frotor_frd_bcm  , ... % Force produced by rotors about the bcm
        Mrotor_frd_bcm    ... % Torque produced by rotors about the bcm
    ] = math_ForMom_rotors(...
        Trotor      , ...   % rotor thrust
        Qrotor      , ...   % rotor torque (due to drag)
        vehicle_st    ...   % vehicle parameters
    )
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    nrotors         = vehicle_st.geometry.nrotors;
    R_frd_frdi      = vehicle_st.geometry.R_frd_frdi;       % Rotation matrix of rotors
    r_frd_roti_cg   = vehicle_st.geometry.r_frd_roti_cg;    % Position vector array

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

    Frotor_frd_bcm = [0; 0; 0];
    Mrotor_frd_bcm = [0; 0; 0];
    
    for roti = 1:nrotors   
        % Get rotation matrix from roti to frd
        DCM_frd_frdi = R_frd_frdi(1:3, 1:3, roti);
        % Get position of roti wrt bcm, expressed in frd coord frame
        pos_frd_roti_cg = r_frd_roti_cg(1:3, roti);
               
        % Force wrt ricm produced by rotor thrust
        F_frdi_ricm = [0; 0; -Trotor(roti)];
        
        % Torque wrt ricm produced by rotor drag
        Q_frdi_ricm = [0; 0; Qrotor(roti)];                      
            
        % Force wrt bcm produced by rotor thrust
        Fi_frd_bcm = DCM_frd_frdi * F_frdi_ricm;
        
        % Torque wrt bcm produced by rotor drag
        Qi_frd_bcm = DCM_frd_frdi * Q_frdi_ricm;        

        % Moment wrt bcm produced by rotor thrust = r x F
        CPM_pos_frd_roti_cg = math_CPMw(pos_frd_roti_cg);
        Mi_frd_bcm = CPM_pos_frd_roti_cg * Fi_frd_bcm; 
        
        % Collect terms
        Frotor_frd_bcm = Frotor_frd_bcm + Fi_frd_bcm;
        Mrotor_frd_bcm = Mrotor_frd_bcm + Mi_frd_bcm + Qi_frd_bcm;
    end    
end

