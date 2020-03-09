function [time_arr, x_arr, u_arr, y_arr] = entryDecent_main()

    clear all
    clc
    close all

    fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
    fprintf('[simulate_body] calling ode45 .. \n');
    xfnct = @entryDecent_dynamics;
    ufnct = @entryDecent_input;
    x0 = entryDecent_x0();
    tf = 378;
    dt = 1;
    tspan = 0:dt:(tf-dt);
    % options = odeset('RelTol', 1.0e-4); %, 'InitialStep', 1.0e0);
    % options = odeset('RelTol', 1e-10,'AbsTol', 1e-10);
    options = odeset('RelTol', 1e-7,'AbsTol', 1e-7);
    [time_arr, x_arr] = ode45(...
        @(t, x) xfnct(t, x, ufnct(t)), ...
        tspan, ...
        x0, ...
        options);    
        
    time_arr = transpose(time_arr);
    fprintf('size(time_arr) \n');
    disp(size(time_arr));

    time_arr_size = size(time_arr);
    nsamples = time_arr_size(2)

    x_arr = transpose(x_arr);
    fprintf('size(x_arr) \n');
    disp(size(x_arr));

    % [xdot, y] = fdyn_state(t, x, u) but ode45 only returns x array, 
    % therefore output y and input u need to be calculated again
    ninputs = size(ufnct(0));
    ninputs = ninputs(1);
    u_arr = zeros(ninputs, nsamples);
    fprintf('size(u_arr) \n');
    disp(size(u_arr));
    
    [xdot0, y0] = xfnct(0, x0, ufnct(0));
    noutpus = size(y0);
    noutpus = noutpus(1);
    y_arr = zeros(noutpus, nsamples);
    fprintf('size(y_arr) \n');
    disp(size(y_arr));

    for i = 1:nsamples
        t = time_arr(i);
        x = x_arr(:, i);
        u = ufnct(t);
        [xdot, y] = xfnct(t, x, u);
        
        u_arr(:, i) = u;
        y_arr(:, i) = y;
    end           

    entryDecent_plot(time_arr, x_arr, u_arr, y_arr);

end






