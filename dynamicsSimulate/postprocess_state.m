function state_st = postprocess_state(x_arr)
    % x_arr = transpose(x_arr);
    fprintf('[postprocess_state] size(x_arr) \n');
    disp(size(x_arr));
    
    x_arr_size = size(x_arr);
    state_st.nstates = x_arr_size(1);
    state_st.nsamples = x_arr_size(2);   

    pos_arr = postprocess_state_get_arr(x_arr, 'pos'); % pos_arr.data;
    fprintf('[postprocess_state] size(pos_arr) \n');
    disp(size(pos_arr));

    q_frd_ned_arr = postprocess_state_get_arr(x_arr, 'quat'); % q_frd_ned_arr.data;
    fprintf('[postprocess_state] size(q_frd_ned_arr) \n');
    disp(size(q_frd_ned_arr));

    vel_arr = postprocess_state_get_arr(x_arr, 'vel'); % vel_arr.data;
    fprintf('[postprocess_state] size(vel_arr) \n');
    disp(size(vel_arr));

    RPY_arr = postprocess_state_get_arr(x_arr, 'rpy'); % RPY_arr.data;
    fprintf('[postprocess_state] size(RPY_arr) \n');
    disp(size(RPY_arr));

    PQR_arr = postprocess_state_get_arr(x_arr, 'pqr'); % PQR_arr.data;
    fprintf('[postprocess_state] size(PQR_arr) \n');
    disp(size(PQR_arr));
    
    omega_arr = postprocess_state_get_arr(x_arr, 'omega'); % PQR_arr.data;
    fprintf('size(wrel_arr) \n');
    disp(size(omega_arr));    
    
    state_st.pos_arr        = pos_arr;
    state_st.q_frd_ned_arr  = q_frd_ned_arr;
    state_st.vel_arr        = vel_arr;    
    state_st.RPY_arr        = RPY_arr;
    state_st.PQR_arr        = PQR_arr;
    state_st.omega_arr      = omega_arr;

end

