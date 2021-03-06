function simres_st = simulate_firefly()

    clear all       % Reset persistent variables
    close all
    clc
    format compact
    
    fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
    fprintf('[simulate_firefly] add modules .. \n');    
    bpath = '/home/tzo4/Dropbox/tomas/pennState/avia/software/dynamics_RUAV';
    addpath([bpath '/dynamicsMath']);
    addpath([bpath '/dynamicsNED']);
    addpath([bpath '/dynamicsVehicle']);
    addpath([bpath '/dynamicsPlot']);
    
    fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
    fprintf('[simulate_firefly] Create structures .. \n');
    sim_st.medium_st = medium_earth();
    sim_st.vehicle_st = firefly_vehicle_st();
    
    % sim_st.fdyn_x0      = sim_st.vehicle_st.x0;
    % Open loop input function => u = g(t)
    % sim_st.fdyn_input = @vehicle_input;    
    % Open loop dynamics => xdot = f( t, x, u = g(t) )
    % sim_st.fdyn_xdot  = @vehicle_xdot;  

    sim_st.fdyn_x0      = [sim_st.vehicle_st.x0; sim_st.vehicle_st.omega0];
    % Closed loop input function => xcmd = g(t)
    sim_st.fdyn_input   = @clsys_input;      
    % Closed loop dynamics => xdot = f( t, x, u)  , where
    % u     = actuator( x, delta )
    % delta = controller( x, xcmd )
    sim_st.fdyn_xdot    = @clsys_xdot;  

    sim_st.tinitial = 0;
    sim_st.tfinal   = 30;
    sim_st.dt       = 0.1;
    
    sim_st.fpath = 'results/test_';
    
%    fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
%    fprintf('[simulate_firefly] Test vehicle model .. \n');    
%    plot_vehicle_st(sim_st.vehicle_st, sim_st.fpath);
%    firefly_rotor_TQP_test();
%    math_compute_Vrel_test(sim_st.vehicle_st);
%    math_ForMom_aero_plot(sim_st.vehicle_st, sim_st.medium_st);     
    
    fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
    fprintf('[simulate_firefly] Calling simulate_ode .. \n');
    sim_st = simulate_ode(sim_st);

    filename = [sim_st.fpath 'sim_st'];
    save(filename, 'sim_st');
    % return

    fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
    fprintf('[simulate_firefly] Postprocessing sim_st .. \n');
    state_st = postprocess_state(sim_st.x_arr);
    sim_st.state_st = state_st;
    
    input_st = postprocess_input(sim_st.u_arr);
    sim_st.input_st = input_st;    
    
    output_st = postprocess_output(sim_st.y_arr);
    sim_st.output_st = output_st;
    
    % return
    
    fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
    fprintf('[simulate_firefly] Plotting sim_st .. \n');
    plot_input(sim_st);
    plot_state(sim_st);   
    plot_output(sim_st);

    close all;
  
end

