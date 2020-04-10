function ...
    [...
        Trotor      , ...   % rotor thrust  
        Qrotor      , ...   % rotor torque (due to drag)
        Protor        ...   % rotor power
    ] = firefly_rotor_TQP(...
        omega       , ...   % rotor state
        Vrel_ricm   , ...   % relative [Va, aoa, ssa] of the ricm wrt the wind
        vehicle_st  , ...   % vehicle parameters
        medium_st     ...   % medium parameters
    )
    %         xdot        , ...   % vehicle state derivative
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    nrotors = vehicle_st.geometry.nrotors;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Rotor model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
    Trotor = zeros(nrotors, 1);
    Qrotor = zeros(nrotors, 1);
    Protor = zeros(nrotors, 1);        
    for roti = 1:nrotors
        omegai = omega(roti);
        Vrel = Vrel_ricm(:, roti);
        signi = firefly_rotor_spin_direction(roti);
        
        [...
            T  , ... % rotor thrust  
            Q  , ... % rotor torque (due to drag)
            P    ... % rotor power
        ] = firefly_rotor_TQP_model(...
            omegai  , ... % AngVel of frdi wrt frd, expressed in frdi coord
            Vrel      ... % Relative [Va, aoa, ssa] of the rotor wrt the wind
        );
        
        Trotor(roti) = T;
        Qrotor(roti) = -1 * signi * Q; % Qrotor = Qaero opposes the spin direction
        Protor(roti) = P;
    end
end

