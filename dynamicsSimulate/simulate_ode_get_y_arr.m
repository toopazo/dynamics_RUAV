function y_arr = simulate_ode_get_y_arr(time_arr, x_arr, sim_st)
        
    vehicle_st  = sim_st.vehicle_st;
    medium_st   = sim_st.medium_st;
        
    fdyn_input  = @(t) sim_st.fdyn_input(t, vehicle_st, medium_st);
    fdyn_xdot   = @(t, x, u) sim_st.fdyn_xdot(t, x, u, vehicle_st, medium_st);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    time_arr_size   = size(time_arr);
    nsamples        = time_arr_size(2);

    % [xdot, y] = fdyn_xdot(t, x, u) but ode45 only returns x array, 
    % therefore output y and input u need to be calculated again
    ninputs = size(fdyn_input(0));
    ninputs = ninputs(1);
    u_arr   = zeros(ninputs, nsamples);
    
    x0          = vehicle_st.x0;
    [xdot0, y0] = fdyn_xdot(0, x0, fdyn_input(0));  
    y_arr       = structfun(@(x) [], y0, 'UniformOutput', false);    
%    noutpus     = size(y0);
%    noutpus     = noutpus(1);
%    y_arr       = zeros(noutpus, nsamples);      
    % returns an array containing n copies of A in row and column dimensions
    % y_arr       = repmat(y0, 1, nsamples); 
    % copy st but with empty field values

    for i = 1:nsamples
        t = time_arr(i);
        x = x_arr(:, i);
        u = fdyn_input(t);
        [xdot, y] = fdyn_xdot(t, x, u);
        
        u_arr(:, i) = u;
        % y_arr(:, i) = y;
        y_arr = postprocess_append_to_st(y, y_arr);
    end   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
end

