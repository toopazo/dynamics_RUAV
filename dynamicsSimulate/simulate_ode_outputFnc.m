function status = simulate_ode_outputFnc(t, x, flag, sim_st)
    
    persistent y_arr u_arr cnt
    if isempty(y_arr)
        vehicle_st  = sim_st.vehicle_st;
        medium_st   = sim_st.medium_st;
        
        t0          = 0;
        x0          = sim_st.fdyn_x0;
        u0          = sim_st.fdyn_input(t0, vehicle_st, medium_st);       
        [xdot, y]   = sim_st.fdyn_xdot(0, x0, u0, vehicle_st, medium_st);
    
        y_arr = structfun(@(x) [], y, 'UniformOutput', false); 
        u_arr = []; 
        
        cnt = 0;
    end
    
    % https://www.mathworks.com/help/matlab/ref/odeset.html
    if isempty(flag) || strcmp(flag, 'init')
        t = t(1);   % t = [tspan(1) tspan(end)]
        if length(t) == 1
            t
            % cnt = cnt + 1

            vehicle_st  = sim_st.vehicle_st;
            medium_st   = sim_st.medium_st;
            
            fdyn_input  = @(t) sim_st.fdyn_input(t, vehicle_st, medium_st);
            u           = fdyn_input(t);
            
            [xdot, y]   = sim_st.fdyn_xdot(t, x, u, vehicle_st, medium_st);

            u_arr       = [u_arr, u];
            y_arr       = postprocess_append_to_st(y, y_arr);
            
            % assignin('base', 'y_arr', y_arr); % get the data to the workspace.
        end        
    end
    
    if strcmp(flag, 'y_arr')
        disp('returning y_arr')
        status.y_arr = y_arr;
        status.u_arr = u_arr;
    else
        status = 0;
    end    

end

