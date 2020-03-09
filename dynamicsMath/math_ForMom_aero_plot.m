function math_ForMom_aero_plot(vehicle_st, medium_st)

    max_ang = 89;
    aoa_arr = deg2rad(-max_ang):deg2rad(+max_ang);     % from climb to descent
    ssa_arr = deg2rad(-max_ang):deg2rad(+max_ang);     % from left side to right side
    
    altitude = 1000;
    Va = 10;
    for i = 1:length(aoa_arr)
        aoa = aoa_arr(i);
        for j = 1:length(ssa_arr)           
            ssa = ssa_arr(j);
            
            Vrel_bcm = [Va, aoa, ssa];
            [Cdrag, Clift, Ccrosswind, CrollM, CpitchM, CyawM] = ...
                get_coeffs(Vrel_bcm, altitude, vehicle_st, medium_st);
                
            Cdrag_arr(i, j)         = Cdrag;
            Clift_arr(i, j)         = Clift; 
            Ccrosswind_arr(i, j)    = Ccrosswind;
            CrollM_arr(i, j)        = CrollM;
            CpitchM_arr(i, j)       = CpitchM;
            CyawM_arr(i, j)         = CyawM;
        end
    end
    
    condstr = sprintf('Aerodynamic coeff at: Va %.2f m/s, altitude %.2f km \n', Va, altitude/1000);
    plot_Coeff_arr(aoa_arr, ssa_arr, Cdrag_arr, 'Cdrag', condstr);
    plot_Coeff_arr(aoa_arr, ssa_arr, Clift_arr, 'Clift', condstr);
    plot_Coeff_arr(aoa_arr, ssa_arr, Ccrosswind_arr, 'Ccrosswind', condstr);
    plot_Coeff_arr(aoa_arr, ssa_arr, CrollM_arr, 'CrollM', condstr);
    plot_Coeff_arr(aoa_arr, ssa_arr, CpitchM_arr, 'CpitchM', condstr);
    plot_Coeff_arr(aoa_arr, ssa_arr, CyawM_arr, 'CyawM', condstr);
    
    % legend('type I', 'type II', 'type III', 'Location','northwest');
    % saveas(fig, 'img/hover_bet_forces_plot_4.jpg');

    function plot_Coeff_arr(aoa_arr, ssa_arr, Coeff_arr, zname, tname)
        fig = figure();
        hold on;    
        [X, Y] = meshgrid(rad2deg(aoa_arr), rad2deg(ssa_arr));
        surf(X, Y, Coeff_arr);        
        surf(X, Y, Coeff_arr.*0)  % plot zero surface
        title(tname);
        xlabel('Angle of attack deg');
        ylabel('Side Slip angle deg');
        zlabel(zname);
        view(40, 35);    
        grid on;
    end
    function [Cdrag, Clift, Ccrosswind, CrollM, CpitchM, CyawM] = ...
        get_coeffs(Vrel_bcm, altitude, vehicle_st, medium_st)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Parameters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
        % reference quantitites
        b = vehicle_st.aero.wing_span;
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
        
        % Aerodynamic moment defined using wind coordinates
        CrollM      = coeff.CrollM(aoa, ssa, Mach, altitude);
        CpitchM     = coeff.CpitchM(aoa, ssa, Mach, altitude);
        CyawM       = coeff.CyawM(aoa, ssa, Mach, altitude);
    end
end    

