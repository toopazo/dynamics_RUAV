function [fig] = plot_final_state(...
    sim_st   , ...
    fpath       ...
    )   
    
    time_arr = sim_st.time_arr;
          
    % Unpack state
    pos_arr = sim_st.state_st.pos_arr;
    vel_arr = sim_st.state_st.vel_arr;
    q_frd_ned_arr = sim_st.state_st.q_frd_ned_arr;
    RPY_arr = sim_st.state_st.RPY_arr;
    PQR_arr = sim_st.state_st.PQR_arr;
    
    if ~isfield(sim_st, 'output_st')
        % Do nothing
        fig = NaN;
        return;
    end
    
    % Unpack output
    if isfield(sim_st.output_st, 'Faero_frd_bcm_arr')
        Faero_frd_bcm_arr = sim_st.output_st.Faero_frd_bcm_arr;
        Maero_frd_bcm_arr = sim_st.output_st.Maero_frd_bcm_arr;
        Fgrav_frd_bcm_arr = sim_st.output_st.Fgrav_frd_bcm_arr;
        Mgrav_frd_bcm_arr = sim_st.output_st.Mgrav_frd_bcm_arr;
        Frotor_frd_bcm_arr = sim_st.output_st.Frotor_frd_bcm_arr;
        Mrotor_frd_bcm_arr = sim_st.output_st.Mrotor_frd_bcm_arr;
        Fnet_frd_bcm_arr = sim_st.output_st.Fnet_frd_bcm_arr;
        Mnet_frd_bcm_arr = sim_st.output_st.Mnet_frd_bcm_arr;
    else
        % Do nothing
        fig = NaN;
        return;
    end
    
    % Print final state    
    final_state.time = time_arr(:, end);
    final_state.pos = pos_arr(:, end);
    final_state.vel = vel_arr(:, end);
    final_state.q_frd_ned = q_frd_ned_arr(:, end);
    final_state.RPY = RPY_arr(:, end);
    final_state.PQR = PQR_arr(:, end);
    
    final_state.Faero_frd_bcm = Faero_frd_bcm_arr(:, end);
    final_state.Maero_frd_bcm = Maero_frd_bcm_arr(:, end);
    final_state.Frotor_frd_bcm = Frotor_frd_bcm_arr(:, end);
    final_state.Mrotor_frd_bcm = Mrotor_frd_bcm_arr(:, end);
   
    fig = 0;
    filename = [fpath 'plot_final_state' '.mat'];

    % delete filename
    variable = 'final_state';
    % save(filename, variable)
    save(filename, variable);
    
end
