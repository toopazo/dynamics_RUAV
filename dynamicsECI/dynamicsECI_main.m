
% ECI
% x-axis    = line from the Sun to Earth's CM at vernal equinox
% y-axis    = 90deg from x-axis along the equatorial plane
% z-axis    = Along the Earth's rotation axis

% ECEF
% x-axis    = line from Earth's CM to 0deg lon (Greenwich) at the equator
% y-axis    = 90deg from x-axis along the equatorial plane
% z-axis    = Along the Earth's rotation axis

% psi       = geocentric latitude       = ang(object's ECEF xy-plane projection, object)    
% l         = geocentric longitude      = ang(ECEF x-axis, object's ECEF xy-plane projection)    

% psi       = terrestrial latitude
% l         = terrestrial longitude

% psi       = celestial latitude
% lambda    = celestial longitude       = ang(ECI x-axis, object's ECI xy-plane projection)    

% lambda - lambda0 = l - l0 + wEt

% phi       = geodetic latitude         = ang(object's ECEF xy-plane projection, object normal)    
% l         = geodetic longitude
% h         = geodetic height           = dist(object, object's normal along the spheroid)   

    clear all
    close all
    clc

    addpath('../dynamicsPlot');
    addpath('../dynamicsMath');

    kmh2ms = 0.277778;
    km = 1000;

    % a = 6378137.0;              % m
    % b = 6356752.0;              % m

    t0  = 0;
    lat = 0;
    lon = 0;
    alt = 400*km;
    r_ecef_bcm_eci = transpose( lla2ecef([lat lon alt]) )

    % Convert Earth-centered inertial (ECI) to Earth-centered Earth-fixed (ECEF) coordinates    
    % position direction cosine matrix (ECI to ECEF) 
    R_ecef_eci = math_R_ecef_eci(t0)
    R_eci_ecef = transpose(R_ecef_eci);

    r_eci_bcm_eci = R_eci_ecef*r_ecef_bcm_eci
    q_frd_eci = [1; 0; 0; 0];
    R_frd_eci = math_quat2dcm(q_frd_eci);
    R_eci_frd = transpose(R_frd_eci);
    v_frd_bcm_ecef = R_frd_eci * R_eci_ecef * [0; 25000*kmh2ms; 0];
    % v_frd_bcm_ecef = [1000; 0; 0];
    w_frd_frd_eci = [0; 0; 0];
    temp = 273.15; 

    x0 = [r_eci_bcm_eci; q_frd_eci; v_frd_bcm_ecef; w_frd_frd_eci; temp];
    u0 = ones(6, 1);
    body_st = params_body();
    planet_st = params_planet();
    [xdot, y] = dynamicsECI_dynamics(t0, x0, u0, body_st, planet_st);

    latlonalt = y;
    lat = latlonalt(1)
    lon = latlonalt(2)
    atl = latlonalt(3)

    fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
    fprintf('[simulate_body] calling ode45 .. \n');
    xfnct = @dynamicsECI_dynamics;
    ufnct = @dynamicsECI_input;
    x0 = x0;
    t0 = 0;
    tf = 2000; %20000;
    dt = 10;
    tspan = t0:dt:(tf-dt);
    % options = odeset('RelTol', 1.0e-4); %, 'InitialStep', 1.0e0);
    % options = odeset('RelTol', 1e-10,'AbsTol', 1e-10);
    options = odeset('RelTol', 1e-7,'AbsTol', 1e-7);
    [t_arr, x_arr] = ode45(...
        @(t, x) xfnct(t, x, ufnct(t, x, body_st, planet_st), body_st, planet_st), ...
        tspan, ...
        x0, ...
        options);

    t_arr = transpose(t_arr);
    fprintf('size(t_arr) \n');
    disp(size(t_arr));

    t_arr_size = size(t_arr);
    nsamples = t_arr_size(2)

    x_arr = transpose(x_arr);
    fprintf('size(x_arr) \n');
    disp(size(x_arr));

    % [xdot, y] = fdyn_state(t, x, u) but ode45 only returns x array, 
    % therefore output y and input u need to be calculated again
    u0 = ufnct(t0, x0, body_st, planet_st);
    ninputs = size(u0);
    ninputs = ninputs(1);
    u_arr = zeros(ninputs, nsamples);
    fprintf('size(u_arr) \n');
    disp(size(u_arr));
    
    [xdot0, y0] = xfnct(t0, x0, u0, body_st, planet_st);
    noutpus = size(y0);
    noutpus = noutpus(1);
    y_arr = zeros(noutpus, nsamples);
    fprintf('size(y_arr) \n');
    disp(size(y_arr));

    for i = 1:nsamples
        t = t_arr(i);
        x = x_arr(:, i);
        u = ufnct(t, x, body_st, planet_st);
        [xdot, y] = xfnct(t, x, u, body_st, planet_st);
        
        u_arr(:, i) = u;
        y_arr(:, i) = y;
    end    
    
    plot_trajectory(t_arr, x_arr, u_arr, y_arr, body_st, planet_st);

