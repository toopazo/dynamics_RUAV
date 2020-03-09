function y  = controller_PID_vel(t, err, controller_st)
    
    persistent n_pid_st
    persistent e_pid_st
    persistent d_pid_st
    if isempty(n_pid_st)
        
        n_pid_st.Kp = controller_st.MPC_XY_VEL_P;
        n_pid_st.Ki = controller_st.MPC_XY_VEL_I;
        n_pid_st.tp = 0;
        n_pid_st.err_tp = 0;
        n_pid_st.interr_tp = 0;
        n_pid_st.y_max = +controller_st.MPC_ACC_HOR_MAX;
        n_pid_st.y_min = -controller_st.MPC_ACC_HOR_MAX;
        
        e_pid_st.Kp = controller_st.MPC_XY_VEL_P;
        e_pid_st.Ki = controller_st.MPC_XY_VEL_I;
        e_pid_st.tp = 0;
        e_pid_st.err_tp = 0;
        e_pid_st.interr_tp = 0;
        e_pid_st.y_max = +controller_st.MPC_ACC_HOR_MAX;
        e_pid_st.y_min = -controller_st.MPC_ACC_HOR_MAX;
        
        d_pid_st.Kp = controller_st.MPC_Z_VEL_P;
        d_pid_st.Ki = controller_st.MPC_Z_VEL_I;
        d_pid_st.tp = 0;
        d_pid_st.err_tp = 0;
        d_pid_st.interr_tp = 0;
        d_pid_st.y_max = +controller_st.MPC_ACC_DOWN_MAX;
        d_pid_st.y_min = -controller_st.MPC_ACC_UP_MAX;
    end
    
    [n_pid_st, yn] = controller_PID_update(t, err(1), n_pid_st);
    [e_pid_st, ye] = controller_PID_update(t, err(2), e_pid_st);
    [d_pid_st, yd] = controller_PID_update(t, err(3), d_pid_st);
    y = [yn; ye; yd];
end
