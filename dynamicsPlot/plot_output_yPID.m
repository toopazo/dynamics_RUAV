function [fig1, fig2, fig3, fig4] = plot_output_yPID(sim_st) 
    fpath = sim_st.fpath;
    time_arr = sim_st.time_arr;   

    yPID            = sim_st.output_st.yPID;
    velcmd          = yPID.velcmd;
    vel             = yPID.vel;
    RPYcmd          = yPID.RPYcmd;
    RPY             = yPID.RPY;
    PQRcmd          = yPID.PQRcmd;
    PQR             = yPID.PQR;
    cmd_ad_frd      = yPID.cmd_ad_frd;
    cmd_angAccel    = yPID.cmd_angAccel;
    delta           = yPID.delta;

    % yPID
    % size(velcmd)
    % size(vel)
    % size(cmd_angAccel)
    % size(delta)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fig1 = figure;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    hold on;

    plot(time_arr, vel(1, :), '-r', 'LineWidth', 2);
    plot(time_arr, vel(2, :), '-g', 'LineWidth', 2);
    plot(time_arr, vel(3, :), '-b', 'LineWidth', 2);
                    
    plot(time_arr, velcmd(1, :), '-.r', 'LineWidth', 2);
    plot(time_arr, velcmd(2, :), '-.g', 'LineWidth', 2);
    plot(time_arr, velcmd(3, :), '-.b', 'LineWidth', 2);

    grid on;
    % title('Angular velocity of rotors (relative to the body)');
    xlabel('Time s');
    ylabel('NED velocity m/s');
    cellarr = {'cmd north', 'cmd east' 'cmd down', 'north', 'east' 'down'};
    legend(cellarr, 'Location', 'eastoutside');  % best
    
    set(fig1, 'Position', get(0, 'Screensize'));
    filename = [fpath 'plot_output_yPID_1'];
    fprintf('[plot_output_yPID] filename %s \n', filename);
    print(fig1, [filename '.jpeg'], '-djpeg');
    savefig(fig1, filename);       
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    fig2 = figure;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    hold on;
            
    plot(time_arr, rad2deg(RPY(1, :)), '-r', 'LineWidth', 2);
    plot(time_arr, rad2deg(RPY(2, :)), '-g', 'LineWidth', 2);
    plot(time_arr, rad2deg(RPY(3, :)), '-b', 'LineWidth', 2);
                    
    plot(time_arr, rad2deg(RPYcmd(1, :)), '-.r', 'LineWidth', 2);
    plot(time_arr, rad2deg(RPYcmd(2, :)), '-.g', 'LineWidth', 2);
    plot(time_arr, rad2deg(RPYcmd(3, :)), '-.b', 'LineWidth', 2);

    grid on;
    % title('Angular velocity of rotors (relative to the body)');
    xlabel('Time s');
    ylabel('RPY Euler angles deg');
    cellarr = {'cmd roll', 'cmd pitch' 'cmd yaw', 'roll', 'pitch' 'yaw'};
    legend(cellarr, 'Location', 'eastoutside');  % best
    
    set(fig2, 'Position', get(0, 'Screensize'));
    filename = [fpath 'plot_output_yPID_2'];
    fprintf('[plot_output_yPID] filename %s \n', filename);
    print(fig2, [filename '.jpeg'], '-djpeg');
    savefig(fig2, filename);     
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    fig3 = figure;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    hold on;
            
    plot(time_arr, rad2deg(PQR(1, :)), '-r', 'LineWidth', 2);
    plot(time_arr, rad2deg(PQR(2, :)), '-g', 'LineWidth', 2);
    plot(time_arr, rad2deg(PQR(3, :)), '-b', 'LineWidth', 2);
                    
    plot(time_arr, rad2deg(PQRcmd(1, :)), '-.r', 'LineWidth', 2);
    plot(time_arr, rad2deg(PQRcmd(2, :)), '-.g', 'LineWidth', 2);
    plot(time_arr, rad2deg(PQRcmd(3, :)), '-.b', 'LineWidth', 2);

    grid on;
    % title('Angular velocity of rotors (relative to the body)');
    xlabel('Time s');
    ylabel('PQR Ang. velocity deg/s');
    cellarr = {'cmd P', 'cmd Q' 'cmd R', 'P', 'Q' 'R'};
    legend(cellarr, 'Location', 'eastoutside');  % best
    
    set(fig3, 'Position', get(0, 'Screensize'));
    filename = [fpath 'plot_output_yPID_3'];
    fprintf('[plot_output_yPID] filename %s \n', filename);
    print(fig3, [filename '.jpeg'], '-djpeg');
    savefig(fig3, filename);  

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    fig4 = figure;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    subplot(2, 1, 1);                
    hold on;        
    plot(time_arr, rad2deg(cmd_angAccel(1, :)), '-r', 'LineWidth', 2);
    plot(time_arr, rad2deg(cmd_angAccel(2, :)), '-g', 'LineWidth', 2);
    plot(time_arr, rad2deg(cmd_angAccel(3, :)), '-b', 'LineWidth', 2);
    plot(time_arr, cmd_ad_frd(1, :), '-k', 'LineWidth', 2);

    grid on;
    % title('Angular velocity of rotors (relative to the body)');
    xlabel('Time s');
    ylabel('cmd\_angAccel deg/s^2 , cmd\_ad\_frd m/s^2');
    cellarr = {'front', 'right' 'down', 'heave'};
    legend(cellarr, 'Location', 'eastoutside');  % best
                    
    subplot(2, 1, 2);
    hold on;        
    plot(time_arr, delta(1, :), '-r', 'LineWidth', 2);
    plot(time_arr, delta(6, :), '-.r', 'LineWidth', 2);
    plot(time_arr, delta(2, :), '-g', 'LineWidth', 2);
    plot(time_arr, delta(5, :), '-.g', 'LineWidth', 2);
    plot(time_arr, delta(3, :), '-b', 'LineWidth', 2);
    plot(time_arr, delta(8, :), '-.b', 'LineWidth', 2);
    plot(time_arr, delta(4, :), '-k', 'LineWidth', 2);
    plot(time_arr, delta(7, :), '-.k', 'LineWidth', 2);        

    grid on;
    % title('Angular velocity of rotors (relative to the body)');
    xlabel('Time s');
    ylabel('delta (throttle)');
    cellarr = {'m1', 'm2', 'm3', 'm4', 'm5', 'm6', 'm7', 'm8'};
    legend(cellarr, 'Location', 'eastoutside');  % best
    
    set(fig4, 'Position', get(0, 'Screensize'));
    filename = [fpath 'plot_output_yPID_4'];
    fprintf('[plot_output_yPID] filename %s \n', filename);
    print(fig4, [filename '.jpeg'], '-djpeg');
    savefig(fig4, filename);        
                   
end
