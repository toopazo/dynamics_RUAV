function [fig1, fig2] = plot_output_y(sim_st) 
    fpath = sim_st.fpath;
    time_arr = sim_st.time_arr;   

    % y = [Vrel_bcm; frd_wdot_frd_bcm_ned]        
    Vrel = sim_st.output_st.y.Vrel;
    wdot = sim_st.output_st.y.wdot;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fig1 = figure;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    hold on;
            
    plot(time_arr, Vrel(1, :), '-r', 'LineWidth', 2);
    plot(time_arr, rad2deg(Vrel(2, :)), '-g', 'LineWidth', 2);
    plot(time_arr, rad2deg(Vrel(3, :)), '-b', 'LineWidth', 2);

    grid on;
    % title('Angular velocity of rotors (relative to the body)');
    xlabel('Time s');
    ylabel('Aerodynamic angles');
    cellarr = {'Airspeed m/s', 'AoA deg', 'SSA deg'};
    legend(cellarr, 'Location', 'eastoutside');  % best
    
    set(fig1, 'Position', get(0, 'Screensize'));
    filename = [fpath 'plot_output_y_1'];
    fprintf('[plot_output_y] filename %s \n', filename);
    print(fig1, [filename '.jpeg'], '-djpeg');
    savefig(fig1, filename);       
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    fig2 = figure;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    hold on;
            
    plot(time_arr, rad2deg(wdot(1, :)), '-r', 'LineWidth', 2);
    plot(time_arr, rad2deg(wdot(2, :)), '-g', 'LineWidth', 2);
    plot(time_arr, rad2deg(wdot(3, :)), '-b', 'LineWidth', 2);

    grid on;
    % title('Angular velocity of rotors (relative to the body)');
    xlabel('Time s');
    ylabel('Ang Accel deg/s^2');
    cellarr = {'front', 'right', 'down'};
    legend(cellarr, 'Location', 'eastoutside');  % best
                
    set(fig2, 'Position', get(0, 'Screensize'));
    filename = [fpath 'plot_output_y_2'];
    fprintf('[plot_output_y] filename %s \n', filename);
    print(fig2, [filename '.jpeg'], '-djpeg');
    savefig(fig2, filename);
end
