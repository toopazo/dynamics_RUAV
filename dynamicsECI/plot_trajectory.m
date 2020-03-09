function plot_trajectory(t_arr, x_arr, u_arr, y_arr, body_st, planet_st)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % State vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    [...
        r_eci_bcm_eci   , ...
        q_frd_eci       , ...
        v_frd_bcm_ecef  , ...
        w_frd_frd_eci   , ...
        temp              ...
    ] = dynamicsECI_unpack_state(x_arr);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Output vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
    [...
        latlonalt   , ...
        g_frd         ...
    ] = dynamicsECI_unpack_output(y_arr);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    kmh2ms  = 0.277778;
    km      = 1000;
    m2km    = 1/1000;
    
    % ECI to ECEF
    nsamples = size(t_arr, 2);
    r_ecef_bcm_eci = zeros(3, nsamples);
    for i = 1:nsamples
        t = t_arr(:, i);
        
        % Convert Earth-centered inertial (ECI) to Earth-centered Earth-fixed (ECEF) coordinates    
        % position direction cosine matrix (ECI to ECEF) 
        R_ecef_eci = math_R_ecef_eci(t);
        R_eci_ecef = transpose(R_ecef_eci);
        
        r_ecef_bcm_eci(1:3, :) = R_ecef_eci*r_eci_bcm_eci(1:3, :);
    end        
    
    r0_eci = r_eci_bcm_eci(:, 1)
    r0_ecef = r_ecef_bcm_eci(:, 1)
    lla0 = ecef2lla(transpose(r0_ecef))
    % return
    
    fig = figure;
    plot_earthSphere(50,'m')
    hold on;
    plot3(r_ecef_bcm_eci(1, 1), r_ecef_bcm_eci(2, 1), r_ecef_bcm_eci(3, 1), 'blue','MarkerSize', 6, 'Marker', '*')
    plot3(r_ecef_bcm_eci(1, :), r_ecef_bcm_eci(2, :), r_ecef_bcm_eci(3, :), 'red','LineWidth',3)
    grid on;
    title('r\_ecef\_bcm\_eci');
    xlabel('x-axis (0° lon => Greenwich, UK)');
    ylabel('y-axis (90°E lon => Dhaka, Bangladesh)');
    zlabel('z-axis (North Pole)');
    saveas(fig, 'plot_decent_traj.jpg');
          
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
    alt_arr = latlonalt(3, :);
    % lat = latlonalt(1, :);
    % lon = latlonalt(2, :);
    % alt = latlonalt(3, :);        
    
    fig = figure;
    hold on;  
    plot(t_arr(1), alt_arr(:, 1)*m2km, 'blue','MarkerSize', 6, 'Marker', '*');
    plot(t_arr, alt_arr, 'red','LineWidth', 3);
    grid on;
    title('alt\_arr');
    xlabel('Time s');
    ylabel('Altitude km');
    saveas(fig, 'plot_decent_alt.jpg');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    nsamples = size(t_arr, 2);
    vel_arr = zeros(1, nsamples);
    for i = 1:nsamples
        vel = v_frd_bcm_ecef(:, i);
        airpseed_arr(:, i)  = norm(vel);
    end
    
    fig = figure;
    hold on;  
    plot(t_arr(1), vel_arr(:, 1)*kmh2ms, 'blue','MarkerSize', 6, 'Marker', '*');
    plot(t_arr, airpseed_arr, 'red','LineWidth', 3);
    grid on;
    title('vel\_arr');
    xlabel('Time s');
    ylabel('Velocity km/h');
    saveas(fig, 'plot_decent_vel.jpg');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    fig = figure;
    hold on;  
    plot(t_arr(1), temp(:, 1), 'blue','MarkerSize', 6, 'Marker', '*');
    plot(t_arr, temp, 'red','LineWidth', 3);
    grid on;
    title('temp (273.15 K = 0 C)');
    xlabel('Time s');
    ylabel('Temperature K');
    saveas(fig, 'plot_decent_temp.jpg');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%    % FRD to ECEF
%    nsamples = size(t_arr, 2);
%    v_ecef_bcm_ecef = zeros(3, nsamples);
%    for i = 1:nsamples       
%        R_frd_eci = math_quat2dcm( q_frd_eci(:, i) );
%        R_eci_frd = transpose(R_frd_eci);        
%        
%        t = t_arr(:, i);
%        
%        % Convert Earth-centered inertial (ECI) to Earth-centered Earth-fixed (ECEF) coordinates    
%        % position direction cosine matrix (ECI to ECEF) 
%        R_ecef_eci = math_R_ecef_eci(t);
%        R_eci_ecef = transpose(R_ecef_eci);
%        
%        v_ecef_bcm_ecef(1:3, :) = R_ecef_eci*R_eci_frd*v_frd_bcm_ecef(1:3, :);
%    end    
%    
%    fig = figure
%    % plot_earthSphere(50,'m')
%    hold on;
%    plot3(v_ecef_bcm_ecef(1, 1), v_ecef_bcm_ecef(2, 1), v_ecef_bcm_ecef(3, 1), 'blue','MarkerSize', 6, 'Marker', '*')
%    plot3(v_ecef_bcm_ecef(1, :), v_ecef_bcm_ecef(2, :), v_ecef_bcm_ecef(3, :), 'red','LineWidth',3)
%    grid on;
%    title('v_ecef_bcm_ecef');
%    xlabel('x-axis (0° lon => Greenwich, UK)')
%    ylabel('y-axis (90°E lon => Dhaka, Bangladesh)')
%    zlabel('z-axis (North Pole)')

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end

