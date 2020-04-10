function ...
    [...
        omegadot    , ... % rotors state derivative
        yrotor        ... % rotors output
    ] = rotors_omegadot(...
        t           , ... % time
        omega       , ... % rotors state
        u           , ... % rotors input
        vehicle_st  , ... % rotors parameters
        medium_st     ... % medium parameters
    )    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    nrotors         = vehicle_st.geometry.nrotors;
    R_frd_frdi      = vehicle_st.geometry.R_frd_frdi;
    Jroti_frdi_ricm = vehicle_st.geometry.Jroti_frdi_ricm;
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % State vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Third componenet of the AngVel of rotor ricm wrt frd, in frdi coord
    omega   = omega;                            % nrotors x 1
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Input vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    Qnet    = [ u(1:nrotors) ];                 % nrotors x 1
    Mbdy    = [ u((1+nrotors):(2*nrotors)) ];   % nrotors x 1    
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % State dynamics
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    
    omegadot    = zeros(nrotors, 1);
    for roti = 1:nrotors   
        % Get rotation matrix from roti to frd
        DCM_frd_frdi = R_frd_frdi(1:3, 1:3, roti);
        
        % Get roti MOI about ricm, in frdi coord
        Jroti = Jroti_frdi_ricm(1:3, 1:3, roti);
        
        % AngVel of rotor ricm wrt frd, in frdi coord
        w_frdi_ricm_frd = [0; 0; omega(roti)];

        % CPM_u = Cross Prod Matrix of u => CPM_u*v <==> cross(u,v)
        CPM_w_frdi_ricm_frd = math_CPMw(w_frdi_ricm_frd);
        crossTerm = CPM_w_frdi_ricm_frd * Jroti * w_frdi_ricm_frd;
                
        Qneti = Qnet(roti);
        Mbdyi = Mbdy(roti);
                
        % roti dynamics
        frdi_wdot_frdi_ricm_frd = ...
            Jroti^(-1)*( Qneti - crossTerm - Mbdyi );
            
        % Third componenet of roti dynamics
        omegadot(roti) = frdi_wdot_frdi_ricm_frd(3);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Output vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
    yrotor.Qnet = Qnet;
    yrotor.Mbdy = Mbdy;

end

