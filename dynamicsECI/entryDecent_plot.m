function entryDecent_plot(time_arr, x_arr, u_arr, y_arr)    

    pos_x = x_arr(1, :);
    pos_z = x_arr(2, :);
    vel_x = x_arr(3, :);
    vel_z = x_arr(4, :);
    T      = x_arr(5, :);
    
    u_inf   = y_arr(1, :);
    beta    = y_arr(2, :);
    T_inf   = y_arr(3, :);
    a_inf   = y_arr(4, :);
    P_inf   = y_arr(5, :);
    rho_inf = y_arr(6, :);
    Fgrav   = y_arr(7, :);
    Fdrag_x = y_arr(8, :);
    Fdrag_z = y_arr(9, :);
    alt     = y_arr(10, :);
    
    km      = 1000;
    ms2kmh  = 3.6;
    
%    beta_deg = rad2deg(beta(1))
%    beta_deg = rad2deg(beta(2))    
%    
%    pos_x(1, 1) 
%    pos_x(1, 2) 
%    pos_x(1, 3) 
%    
%    vel_x(1, 1) 
%    vel_x(1, 2) 
%    vel_x(1, 3) 
    % return

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    % Phase plots: pos, vel
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fig = figure;
    plot(pos_x/km, pos_z/km)
    xlabel('pos_x km')
    ylabel('pos_z km')
    
    fig = figure;
    plot(vel_x*ms2kmh, vel_z*ms2kmh)
    xlabel('vel_x km/h')
    ylabel('vel_z km/h')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    % Time series: pos, vel
%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    fig = figure;
%    subplot(2, 1, 1);
%    plot(time_arr, pos_x/km)
%    xlabel('time s')
%    ylabel('pos_x m')    
%    % fig = figure;
%    subplot(2, 1, 2);
%    plot(time_arr, pos_z/km)
%    xlabel('time s')
%    ylabel('pos_z km')
%    
%    fig = figure;
%    subplot(2, 1, 1);    
%    plot(time_arr, vel_x*ms2kmh); % plot(time_arr, vel_x/km)
%    xlabel('time s')
%    ylabel('vel_x km/h'); % ylabel('vx_{ned} m/s'); % ylabel('vx_{ned} km/s')        
%    % fig = figure;
%    subplot(2, 1, 2);
%    plot(time_arr, vel_z*ms2kmh); % plot(time_arr, vel_z/km)
%    xlabel('time s')
%    ylabel('vel_z km/h'); % ylabel('vz_{ned} m/s'); % ylabel('vz_{ned} km/s')        
%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Time series: beta, Fgrav, Fdrag, alt
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    fig = figure;
    plot(time_arr, rad2deg(beta))
    xlabel('time s')
    ylabel('beta deg')
    
    fig = figure;
    plot(time_arr, Fgrav)
    xlabel('time s')
    ylabel('Fgrav N')      

    fig = figure;
    subplot(2, 1, 1);
    plot(time_arr, Fdrag_x)
    xlabel('time s')
    ylabel('Fdrag_x m')    
    % fig = figure;
    subplot(2, 1, 2);
    plot(time_arr, Fdrag_z)
    xlabel('time s')
    ylabel('Fdrag_z N')        
    
    fig = figure;
    plot(time_arr, alt/km)
    xlabel('time s')
    ylabel('alt km')         
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end







