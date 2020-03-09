function ...
    [...
        Fgrav_frd_bcm    , ... % Gravity Force
        Mgrav_frd_bcm      ... % Gravity Moment
    ] = math_ForMom_gravity(...
        q_frd_ned   , ...   % Quaternion for R_frd_ned rotation
        vehicle_st  , ...   % vehicle parameters
        medium_st     ...   % medium parameters
    )
            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    mass    = vehicle_st.inertia.mass;  % mass body
    g_magn  = medium_st.g_magn;  % medium properties

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Fgrav_frd_bcm = [0; 0; 0];             
    Mgrav_frd_bcm = [0; 0; 0];  
        
    % constant gravity model 
    % this could be replaced by a better model (J2 model)

    % Gravity in frd coord frame
    g_ned = [0; 0; g_magn];
    g_frd = math_quatrotate(q_frd_ned, g_ned);
    
    Fgrav_frd_bcm = mass * g_frd;
    Fgrav_ned_CM = mass * [0; 0; g_magn];
    Mgrav_frd_bcm = [0; 0; 0];  

        
end

