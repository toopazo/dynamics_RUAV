function sim_st = simulate_ode(sim_st)
    %t0, tf, dt, x0, fdyn_input, fdyn_xdot)
        
    vehicle_st = sim_st.vehicle_st;
    medium_st = sim_st.medium_st;
        
    fdyn_input = @(t) sim_st.fdyn_input(t, vehicle_st, medium_st);
    % fdyn_xdot = @(t, x, u) sim_st.fdyn_xdot(t, x, u, vehicle_st);
    fdyn_xdot = @(t, x, u) sim_st.fdyn_xdot(t, x, u, vehicle_st, medium_st);
    
    x0 = vehicle_st.x0;
    
    ti = sim_st.tinitial;
    tf = sim_st.tfinal;
    dt = sim_st.dt;
    
    % tspan = ti:dt:(tf-dt);
    tspan = ti:dt:tf;
    % options = odeset('RelTol', 1.0e-4); %, 'InitialStep', 1.0e0);
    % options = odeset('RelTol', 1e-10,'AbsTol', 1e-10);
%    options = odeset('RelTol', 1e-5,'AbsTol', 1e-5);
%    [time_arr, x_arr] = ode45(...
%        @(t, x) fdyn_xdot(t, x, fdyn_input(t)), ...
%        tspan, ...
%        x0, ...
%        options);    

    % ode15s
    options = odeset('RelTol', 1e-5,'AbsTol', 1e-5);
    [time_arr, x_arr] = ode15s(...        
        @(t, x) fdyn_xdot(t, x, fdyn_input(t)), ...
        tspan, ...
        x0, ...
        options);

    time_arr = transpose(time_arr);
%    fprintf('[simulate_ode] size(time_arr) \n');
%    disp(size(time_arr));

    time_arr_size = size(time_arr);
    nsamples = time_arr_size(2);

    x_arr = transpose(x_arr);
%    fprintf('[simulate_ode] size(x_arr) \n');
%    disp(size(x_arr));

    % [xdot, y] = fdyn_xdot(t, x, u) but ode45 only returns x array, 
    % therefore output y and input u need to be calculated again
    ninputs = size(fdyn_input(0));
    ninputs = ninputs(1);
    u_arr = zeros(ninputs, nsamples);
%    fprintf('[simulate_ode] size(u_arr) \n');
%    disp(size(u_arr));
    
    [xdot0, y0] = fdyn_xdot(0, x0, fdyn_input(0));
    noutpus = size(y0);
    noutpus = noutpus(1);
    % y_arr = zeros(noutpus, nsamples);
    % returns an array containing n copies of A in row and column dimensions
    % y_arr = repmat(y0, 1, nsamples); 
    % copy st but with empty field values
    y_arr = structfun(@(x) [], y0, 'UniformOutput', false);  
    
%    fprintf('[simulate_ode] size(y_arr) \n');
%    disp(size(y_arr));

    for i = 1:nsamples
        t = time_arr(i);
        x = x_arr(:, i);
        u = fdyn_input(t);
        [xdot, y] = fdyn_xdot(t, x, u);
        
        u_arr(:, i) = u;
        % y_arr(:, i) = y;
        y_arr = postprocess_append_to_st(y, y_arr);
    end   
    
    % Add nsamples to y_arr struct
    y_arr_size = size(time_arr);   
    y_arr.nsamples = y_arr_size(2);
    
    % Add to sim_st
    sim_st.time_arr = time_arr;
    sim_st.x_arr    = x_arr;
    sim_st.u_arr    = u_arr;
    sim_st.y_arr    = y_arr;
end

