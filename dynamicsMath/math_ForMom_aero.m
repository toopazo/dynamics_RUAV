function ...
    [...
        Faero_frd_bcm    , ... % Aerodynamic Force
        Maero_frd_bcm      ... % Aerodynamic Moment
    ] = math_ForMom_aero(...
        Vrel_bcm    , ...   % Relative [Va, aoa, ssa] of the bcm wrt the wind
        altitude    , ...   % Absolute vertical position of the bcm
        vehicle_st  , ...   % vehicle parameters
        medium_st     ...   % medium parameters  
    )  
      
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
    % reference quantitites 
    S = vehicle_st.aero.cross_area; 
    b = vehicle_st.aero.wing_span;
    c = vehicle_st.aero.wing_chord;
    coeff = vehicle_st.aero.coeff;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    
    % Relative wind
    Va = Vrel_bcm(1);
    aoa = Vrel_bcm(2);
    ssa = Vrel_bcm(3);
    
    % Atmospheric model
    [temperature, Vsound, pressure, density, viscosity] = ...
        medium_st.atmospehre(altitude);
    
    % Mach and Reynolds numbers
    Mach        = Va / Vsound;
    Reynolds    = density * Va * b / viscosity;
    
    % Dynamic pressure
    q = 0.5 * density * Va^2;            
    
    % Aerodynamic force defined using wind coordinates
    Cdrag       = coeff.Cdrag(aoa, ssa, Mach, altitude);
    Clift       = coeff.Clift(aoa, ssa, Mach, altitude);
    Ccrosswind  = coeff.Ccrosswind(aoa, ssa, Mach, altitude);
    Fdrag       = q * S * Cdrag;    
    Flift       = q * S * Clift;
    Fcrosswind  = q * S * Ccrosswind;        
    Faero_wind_bcm = [-Fdrag; -Fcrosswind; -Flift];
    
    % Aerodynamic moment defined using wind coordinates
    CrollM      = coeff.CrollM(aoa, ssa, Mach, altitude);
    CpitchM     = coeff.CpitchM(aoa, ssa, Mach, altitude);
    CyawM       = coeff.CyawM(aoa, ssa, Mach, altitude);
    Mroll       = q * S * b * CrollM;
    Mpitch      = q * S * b * CpitchM;
    Myaw        = q * S * b * CyawM;    
    Maero_wind_bcm = [Mroll; Mpitch; Myaw];

    % Rotation matrix from wind tp body coordinates
    R_wind_frd = math_R_wind_frd(aoa, ssa);
    R_frd_wind = transpose(R_wind_frd);
    
    % Aerodynamic forces and moments expressed in body coordinates
    Faero_frd_bcm = R_frd_wind * Faero_wind_bcm;
    Maero_frd_bcm = R_frd_wind * Maero_wind_bcm;
end

