function sim_st = simulate_ode(sim_st)
        
    vehicle_st  = sim_st.vehicle_st;
    medium_st   = sim_st.medium_st;
        
    x0          = sim_st.fdyn_x0;
    fdyn_input  = @(t) sim_st.fdyn_input(t, vehicle_st, medium_st);
    fdyn_xdot   = @(t, x, u) sim_st.fdyn_xdot(t, x, u, vehicle_st, medium_st);
    fdyn_output = @(t, x, flag) simulate_ode_outputFnc(t, x, flag, sim_st);
        
    ti = sim_st.tinitial;
    tf = sim_st.tfinal;
    dt = sim_st.dt;    
    % tspan = ti:dt:(tf-dt);
    tspan = ti:dt:tf;
    
%    % ode45
%    % options = odeset('RelTol', 1.0e-4); %, 'InitialStep', 1.0e0);
%    % options = odeset('RelTol', 1e-10,'AbsTol', 1e-10);
%    options = odeset('RelTol', 1e-5,'AbsTol', 1e-5, 'OutputFcn', fdyn_output);
%    [time_arr, x_arr] = ode45(...
%        @(t, x) fdyn_xdot(t, x, fdyn_input(t)), ...
%        tspan, ...
%        x0, ...
%        options);    

    % ode15s
    options = odeset('RelTol', 1e-10,'AbsTol', 1e-10, 'OutputFcn', fdyn_output);
    [time_arr, x_arr] = ode15s(...        
        @(t, x) fdyn_xdot(t, x, fdyn_input(t)), ...
        tspan, ...
        x0, ...
        options);

    % Get time_arr
    time_arr = transpose(time_arr);
    time_arr_size = size(time_arr);
    nsamples = time_arr_size(2);
    fprintf('[simulate_ode] size(time_arr) \n');
    disp(size(time_arr));

    % Get x_arr
    x_arr = transpose(x_arr);
    % fprintf('[simulate_ode] size(x_arr) \n');
    % disp(size(x_arr));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    output_st = fdyn_output(0, x0, 'y_arr');
    y_arr = output_st.y_arr;
    u_arr = output_st.u_arr;
    % y_arr = simulate_ode_get_y_arr(time_arr, x_arr, sim_st);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Add nsamples to y_arr struct
    y_arr_size = size(time_arr);   
    y_arr.nsamples = y_arr_size(2);
    
    % Add (t, x, u, y) to sim_st
    sim_st.time_arr = time_arr;
    sim_st.x_arr    = x_arr;
    sim_st.u_arr    = u_arr;
    sim_st.y_arr    = y_arr;
end

