function ...
    [...
        Mrot_frd_bcm      ... % Moment produced by rotors about the bcm
    ] = math_vehicle_Mrot(...
        w_frd_bcm_ned   , ... % AngVel of vehicle bcm wrt ned, in frd coord
        omega           , ... % AngVel of rotor ricm wrt frd, in frdi coord
        omegadot        , ... % AngAccel of rotor ricm wrt frd, in frdi coord
        vehicle_st        ... % Vehicle parameters
    )    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    nrotors         = vehicle_st.geometry.nrotors;
    R_frd_frdi      = vehicle_st.geometry.R_frd_frdi;
    Jroti_frdi_ricm = vehicle_st.geometry.Jroti_frdi_ricm;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

    % Mrot_frd  = Hrotdot + w x Hrot
    %           = R_frd_frdi * ( Hrotdot_frdi + w_frdi x Hrot_frdi )       

    % CPM_u = Cross Prod Matrix of u => CPM_u*v <==> cross(u,v)
    CPM_w_frd_bcm_ned = math_CPMw(w_frd_bcm_ned);

    Mrot_frd_bcm = [0; 0; 0];
    
    for roti = 1:nrotors   
        % Get rotation matrix from roti to frd
        DCM_frd_frdi = R_frd_frdi(1:3, 1:3, roti);
        
        % Get roti MOI about ricm, in frdi coord
        Jroti = Jroti_frdi_ricm(1:3, 1:3, roti);
                  
        % Time derivative wrt frdi of roti AngMomentum about ricm, in frdi coord
        Hrotidot_frdi = Jroti * [0; 0; omegadot(i)];
        
        % Time derivative wrt frdi of roti AngMomentum about ricm, in frd coord
        Hrotidot_frd = DCM_frd_frdi * Hrotidot_frdi;
     
        % AngMomentum of roti about ricm, in frdi coord
        Hroti_frdi = Jroti * [0; 0; omega(i)];
        
        % AngMomentum of roti about ricm, in frd coord        
        Hroti_frd = DCM_frd_frdi * Hroti_frdi;
        
        % Mrot term associated with roti, in frd coord
        Mroti_frd = Hrotidot_frd + CPM_w_frd_bcm_ned * Hroti_frd;
        
        % Collect terms
        Mrot_frd_bcm = Mrot_frd_bcm + Mroti_frd;
    end    
end

